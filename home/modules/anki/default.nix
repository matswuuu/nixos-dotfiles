{ pkgs, ... }:
{
  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [
      anki-connect
      ajt-card-management
      fsrs4anki-helper
      review-heatmap
      image-occlusion-enhanced
      local-audio-yomichan
      yomichan-forvo-server
      passfail2
    ];
  };
}