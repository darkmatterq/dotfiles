#!/bin/bash

if i3-msg -t get_tree | grep -q '"study_timer"'; then
    i3-msg '[class="study_timer"] kill'
else
    # padding.x=15 (căn hai bên), padding.y=8 (đẩy chữ xuống giữa khung 55px)
    alacritty --class study_timer \
      --option "window.padding.x=15" \
      --option "window.padding.y=8" \
      -e bash -c 'tput civis; s=3000; while [ $s -gt 0 ]; do printf "\r%02d:%02d:%02d " $((s/3600)) $((s/60%60)) $((s%60)); sleep 1; ((s--)); done'
fi
