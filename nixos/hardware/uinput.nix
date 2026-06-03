{ username, ... }:

{
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';
  hardware.uinput.enable = true;
  users.groups.input.members = [ username ];
}
