#!/bin/fish

function _install_font_awesome
  sudo apt-get install fonts-font-awesome
end

function _install_brightness_ctl
  sudo apt-get install brightnessctl brightness-udev
end

function _install_sway_related_packages
  sudo apt-get install foot waybar swayidle wofi swaylock
end

function _install_grim_packages
  sudo apt-get install grim grimshot
end

function _install_pulseaudio_utils
  sudo apt-get install pulseaudio-utils
end

function build_wayland_env
  _install_font_awesome
  _install_brightness_ctl
  _install_sway_related_packages
  _install_grim_packages
  _install_pulseaudio_utils

end
