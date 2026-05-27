{ username, ... }:

{
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';
  users.groups.input.members = [ username ];
}
