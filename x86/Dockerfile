# runtime
FROM python:alpine

RUN adduser -D user
USER user

WORKDIR /workdir

RUN pip install --user yt-dlp

ENTRYPOINT ["/home/user/.local/bin/yt-dlp"]
