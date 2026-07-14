---@module 'hl'

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@165",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@144",
    position = "0x1080",
    scale    = 1,
})


hl.workspace_rule({
    workspace = 1,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 2,
    monitor = "DP-1",
})

hl.workspace_rule({
    workspace = 3,
    monitor = "DP-1",
})

hl.workspace_rule({
    workspace = 4,
    monitor = "DP-2",
})

hl.workspace_rule({
    workspace = 5,
    monitor = "DP-2",
})








-- Window rules for autostarted apps (move to workspace silently, set initial width)
hl.window_rule({
    name = "move-chrome",
    match = { class = "google-chrome" },
    workspace = "1 silent",
})
hl.window_rule({
    name = "move-vesktop",
    match = { class = "vesktop" },
    workspace = "3 silent",
    scrolling_width = 0.5,
})
hl.window_rule({
    name = "move-telegram",
    match = { class = "org.telegram.desktop" },
    workspace = "3 silent",
    scrolling_width = 0.5,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww img ~/.config/awww/wallpapers/4.png")
    hl.exec_cmd("google-chrome-stable")
    hl.exec_cmd("vesktop")
    hl.exec_cmd("Telegram")
end)
