#!/usr/bin/env python3

import asyncio
import colorsys
import json
import sys
from pathlib import Path

import dbus
import dbus.mainloop.glib
from gi.repository import GLib
from tapo import ApiClient

CONFIG_PATH = Path.home() / ".config" / "notification-light" / "config.json"


def read_file(path: str) -> str:
    with open(path) as f:
        return f.read().strip()


def load_config() -> dict:
    with open(CONFIG_PATH) as f:
        cfg = json.load(f)
    tapo = cfg["tapo"]
    if "email_path" in tapo:
        tapo["email"] = read_file(tapo.pop("email_path"))
    if "password_path" in tapo:
        tapo["password"] = read_file(tapo.pop("password_path"))
    if "ip_path" in tapo:
        tapo["ip"] = read_file(tapo.pop("ip_path"))
    return cfg


class NotificationLight:
    def __init__(self, config: dict):
        self.config = config
        self.client: ApiClient | None = None

    async def ensure_client(self) -> ApiClient:
        if self.client is None:
            tapo = self.config["tapo"]
            self.client = ApiClient(tapo["email"], tapo["password"])
        return self.client

    async def flash(self, r: int, g: int, b: int) -> None:
        client = await self.ensure_client()
        device = await client.l900(self.config["tapo"]["ip"])

        h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)

        info = await device.get_device_info_json()
        original_hue = info["hue"]
        original_saturation = info["saturation"]
        was_on = info["device_on"]

        await device.set_hue_saturation(
            hue=round(h * 360),
            saturation=round(s * 100),
        )

        await asyncio.sleep(self.config.get("duration", 0.5))

        await device.set_hue_saturation(
            hue=original_hue,
            saturation=original_saturation,
        )

        if was_on:
            await device.off()

    def on_notification(self, bus, message):
        args = message.get_args_list()
        if len(args) < 4:
            return

        app_name = args[0]
        body = args[3]

        for app_pattern, color in self.config["apps"].items():
            if (
                app_pattern.lower() in app_name.lower()
                or app_pattern.lower() in body.lower()
            ):
                r, g, b = color
                print(f"[notification-light] {app_name}: flash RGB({r},{g},{b})")
                try:
                    asyncio.run(self.flash(r, g, b))
                except Exception as e:
                    print(f"[notification-light] Error: {e}", file=sys.stderr)
                break


def main():
    config = load_config()

    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()

    nl = NotificationLight(config)

    bus.add_match_string_non_blocking(
        "eavesdrop=true, interface='org.freedesktop.Notifications', member='Notify'"
    )
    bus.add_message_filter(nl.on_notification)

    print("[notification-light] Started")

    loop = GLib.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        loop.quit()


if __name__ == "__main__":
    main()
