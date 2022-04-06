#!/usr/bin/fish

function _install_pkgs
  sudo apt install fonts-font-awesome \
  brightnessctl brightness-udev \
  foot waybar swayidle wofi swaylock \
  grim grimshot \
  pulseaudio-utils \
  mako_notifier \
  lxpolkit
end

function build_wayland_env
  _install_pkgs

end
