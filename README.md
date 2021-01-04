Mini Cinema Bot
===

The LINE Bot to find Cinema information.

## Requirements

* Ruby 2.6+

## Usage

Run below command to start chatbot

```bash
# Fill your LINE Bot tokens
export LINE_CHANNEL_ID=
export LINE_CHANNEL_SECRET=
export LINE_CHANNEL_TOKEN=
# Start server
rackup
```

### Ngrok

You can user ngrok for development


```bash
ngrok http 9292
```

## Features

* [ ] Persistent Movie Data
  * [ ] Daily Refresh Movies
* [x] Load Movies from VSCiemas
* [x] List Movies
* [x] Sort Movies
* [x] Random Movies
* [ ] Movies Categories
* [ ] Movies Timelines
* [x] Dockerize

## Play with LINE Bot

![QR Code](https://github.com/elct9620/mini-cinema-bot/blob/master/.github/assets/qrcode.png)
