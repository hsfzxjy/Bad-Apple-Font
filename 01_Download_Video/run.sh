#!/bin/bash

source "$(dirname $0)/../util.sh"

YT_DLP="$HERE/yt-dlp"
download "https://github.com/yt-dlp/yt-dlp/releases/download/2023.07.06/yt-dlp_linux" "yt-dlp.sha256" "$YT_DLP"
chmod +x "$YT_DLP"

download_ex "$YT_DLP https://www.nicovideo.jp/watch/sm8628149 -o badapple.mp4" badapple.sha256
