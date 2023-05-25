# build
FROM python:alpine as build

RUN apk add musl-dev gcc g++
RUN adduser -D user
USER user

RUN pip install --user yt-dlp

# runtime
FROM python:alpine

RUN adduser -D user
USER user

WORKDIR /workdir

COPY --from=build /home/user/.local /home/user/.local/

ENTRYPOINT ["/home/user/.local/bin/yt-dlp"]
