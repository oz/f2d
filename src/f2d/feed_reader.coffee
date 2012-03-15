FeedMe = require 'feedme'
http   = require 'http'
URL    = require 'url'
fs     = require 'fs'

class FeedReader
  constructor: (url) ->
    @url = URL.parse url
    @parser = new FeedMe true

  get: (cb) ->
    parser = new FeedMe true
    req = http.get @url, (res) -> res.pipe(parser)
    req.on 'error', cb
    parser.on 'error', cb
    parser.on 'end', () -> cb null, parser.done()
    req.end()

exports.FeedReader = FeedReader