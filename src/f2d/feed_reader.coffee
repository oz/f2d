FeedMe  = require 'feedme'
http    = require 'http'
URL     = require 'url'

class FeedReader
  constructor: (url) ->
    @url = URL.parse url
    @parser = new FeedMe true

  get: (cb) ->
    @setupParser cb
    buf = ''
    http.get @url, (res) =>
      res.on 'error', (err) -> cb err, null
      res.on 'data', (data) -> buf += data
      res.on 'end', () =>
        @parser.write buf
        @parser.end()

  setupParser: (cb) ->
    @parser.on 'error', (err) -> cb err, null
    @parser.on 'end', () =>
      cb null, @parser.done()

exports.FeedReader = FeedReader
