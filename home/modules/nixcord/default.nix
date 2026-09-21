{
  programs.nixcord = {
    enable = true;
    #discord.vencord.enable = true;
    discord.equicord.enable = true;
    vesktop.enable = true;

    config = {
      frameless = true;

      plugins = {
        betterGifAltText.enable = true;
        betterRoleContext.enable = true;
        callTimer.enable = true;
        concatenatedComponentExtractor.enable = true;
        copyUserUrls.enable = true;
        crashHandler.enable = true;
        customRpc.enable = true;
        disableDeepLinks.enable = true;
        experiments.enable = true;
        expressionCloner.enable = true;
        fakeNitro.enable = true;
        fakeProfileThemes.enable = true;
        favoriteEmojiFirst.enable = true;
        forceOwnerCrown.enable = true;
        fullSearchContext.enable = true;
        iLoveSpam.enable = true;
        imageFilename.enable = true;
        memberCount.enable = true;
        messageLatency.enable = true;
        messageLogger = {
          enable = true;
          ignoreBots = false;
        };
        newGuildSettings.enable = true;
        noDevtoolsWarning.enable = true;
        noF1.enable = true;
        noTrack.enable = true;
        noTypingAnimation.enable = true;
        noUnblockToJump.enable = true;
        permissionFreeWill.enable = true;
        permissionsViewer.enable = true;
        petpet.enable = true;
        platformIndicators.enable = true;
        replyTimestamp.enable = true;
        roleColorEverywhere.enable = true;
        sendTimestamps.enable = true;
        serverInfo.enable = true;
        settings.enable = true;
        showHiddenChannels.enable = true;
        showHiddenThings.enable = true;
        showTimeoutDuration.enable = true;
        supportHelper.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        webContextMenus.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
        biggerStreamPreview.enable = true;
      };

    };
    userPlugins = {
      removeChildishChannelNames = "github:matswuuu/vc-removeChildishChannelNames/d2c609ed22a78a9df37425c620158947e4fe5497";
    };
    extraConfig = {
      plugins = {
        removeChildishChannelNames.enable = true;
      };
    };
  };
}
