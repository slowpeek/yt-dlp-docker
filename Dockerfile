FROM alpine as ffmpeg_static

ARG FFMPEG_REPO=https://github.com/yt-dlp/FFmpeg-Builds

RUN <<EOF
target=$(arch | sed -En '/x86_64|aarch64/{s,x86_64,64,;s,aarch64,arm64,;p}')
if [ -z "$target" ]; then
   echo 'ERROR: This dockerfile only supports x86_64 and aarch64 builds'
   exit 1
fi

cd /tmp
wget "$FFMPEG_REPO/releases/download/latest/ffmpeg-master-latest-linux${target}-gpl.tar.xz"
# -o is a must, because files in the tar are owned by 1001:127
# https://github.com/BtbN/FFmpeg-Builds/issues/416
tar xof *.tar.xz
mv -t . ffmpeg-*/bin/*
EOF

# FFmpeg static builds above are linked to glibc, so no alpine here
FROM python:3.12-slim

COPY --from=ffmpeg_static /tmp/ffmpeg /tmp/ffprobe /usr/bin

RUN adduser --disabled-password user
USER user

RUN pip install --user yt-dlp

WORKDIR /workdir

ENTRYPOINT ["/home/user/.local/bin/yt-dlp"]
