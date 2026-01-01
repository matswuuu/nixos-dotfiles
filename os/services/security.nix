{
  services.gnome = {
    gnome-keyring.enable = true;
  };
  security.pam.services = {
    login.enableKwallet = true;
    sddm.enableGnomeKeyring = true;
  };
}