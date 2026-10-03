import {
    ApplicationCommandInputType,
    ApplicationCommandOptionType,
    findOption,
    sendBotMessage,
} from "@api/Commands";
import definePlugin from "@utils/types";
import type { CommandArgument, CommandContext } from "@vencord/discord-types";
import { DraftType, UploadHandler, UserUtils } from "@webpack/common";
import {
    DEFAULT_RESOLUTION,
    DEFAULT_SPEED,
    MAX_RESOLUTION,
    MAX_SPEED,
    MIN_RESOLUTION,
    MIN_SPEED,
    clamp,
    num,
} from "./logic";
import { loadImage, renderGif } from "./render";

/** Avatar fetch size. 512 is Discord's canonical bucket and strictly exceeds
 *  MAX_RESOLUTION (498), so the avatar is never upscaled into the circle. */
const AVATAR_SIZE = 512;

async function resolveAvatarUrl(user: string, ctx: CommandContext): Promise<string> {
    const u = await UserUtils.getUser(user);
    // Not 2048: the avatar is drawn at most MAX_RESOLUTION (498) px wide, so a
    // 2048px fetch is hundreds of KB downloaded and CORS-decoded to be thrown
    // away on every invocation.
    return u.getAvatarURL(ctx.guild?.id, AVATAR_SIZE);
}

export default definePlugin({
    name: "LinuxScratch",
    description: "Adds a /linux-scratch command to make Tux scratch a user's avatar.",
    authors: [{ name: "matswuuu", id: 0n }],
    tags: ["Fun", "Commands"],
    commands: [
        {
            inputType: ApplicationCommandInputType.BUILT_IN,
            name: "linux-scratch",
            description: "Make Tux scratch an avatar. Attaches the gif to your message.",
            options: [
                {
                    name: "user",
                    description: "User whose avatar to use",
                    type: ApplicationCommandOptionType.USER,
                    required: true,
                },
                {
                    name: "resolution",
                    description: `Output resolution in px (${MIN_RESOLUTION}-${MAX_RESOLUTION})`,
                    type: ApplicationCommandOptionType.INTEGER,
                },
                {
                    name: "speed",
                    description: "Playback speed multiplier. 1 is real time, 2 is double.",
                    type: ApplicationCommandOptionType.NUMBER,
                },
            ],
            async execute(opts: CommandArgument[], ctx: CommandContext) {
                let avatar: HTMLImageElement;
                try {
                    avatar = await loadImage(
                        await resolveAvatarUrl(findOption(opts, "user", ""), ctx),
                    );
                } catch (err) {
                    // Distinct from the render failure below: an avatar 404, a
                    // network error or a CORS rejection all land here, and the
                    // generic render message would tell the user nothing
                    // actionable about any of them.
                    console.error("[linux-scratch] failed to load avatar\n", err);
                    sendBotMessage(ctx.channel.id, {
                        content: "Could not load that user's avatar. Try a different user.",
                    });
                    return;
                }

                const resolution = clamp(
                    num(findOption(opts, "resolution", undefined), DEFAULT_RESOLUTION),
                    MIN_RESOLUTION,
                    MAX_RESOLUTION,
                );
                const speed = clamp(
                    num(findOption(opts, "speed", undefined), DEFAULT_SPEED),
                    MIN_SPEED,
                    MAX_SPEED,
                );

                try {
                    const file = await renderGif({ avatar, resolution, speed });
                    // Discord clears slash-command input (and pending
                    // attachments) the moment the command resolves, so defer.
                    // The try/catch cannot be the enclosing one: it has already
                    // exited by the time this fires.
                    setTimeout(() => {
                        try {
                            void UploadHandler.promptToUpload(
                                [file],
                                ctx.channel,
                                DraftType.ChannelMessage,
                            ).catch((err: unknown) =>
                                console.error("[linux-scratch] upload failed\n", err),
                            );
                        } catch (err) {
                            console.error("[linux-scratch] upload failed\n", err);
                        }
                    }, 10);
                } catch (err) {
                    console.error("[linux-scratch] render failed\n", err);
                    sendBotMessage(ctx.channel.id, {
                        content: "Failed to generate the gif. Check the console for details.",
                    });
                }
            },
        },
    ],
});
