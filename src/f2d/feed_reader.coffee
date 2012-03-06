FeedMe = require 'feedme'
http   = require 'http'
URL    = require 'url'

class FeedReader
  constructor: (url) ->
    @url = URL.parse url
    @parser = new FeedMe true

  get: (cb) ->
    @setupParser cb
    buf = ''
    http.get @url, (res) =>
      if res.statusCode != 200
        return cb {message: 'Invalid status code: ' + res.statusCode}, null
      res.on 'data', (data) -> buf += data
      res.on 'close', cb
      res.on 'end', () =>
        @parser.write buf
        @parser.end()
    .on 'error', cb

  setupParser: (cb) ->
    @parser.on 'error', cb
    @parser.on 'end', () => cb null, @parser.done()

exports.FeedReader = FeedReader
