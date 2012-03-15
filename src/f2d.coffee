argv       = require('optimist').argv
Feeds      = require('./f2d/store').feeds
FeedReader = require('./f2d/feed_reader').FeedReader
util       = require 'util'

class CmdParser
  constructor: (@argv) ->
    @commands =
      add:    2
      list:   0
      config: 2
      update: 0

  run: () ->
    cmd   = @argv._.shift()
    arity = @commands[cmd]
    return @help() if arity is undefined or arity != @argv._.length

    @feeds = new Feeds "/tmp/foo.db"
    @[cmd](@argv._...)

  list: () ->
    @feeds.each (feed) ->
      console.log util.inspect(feed)

  add: (account, url) ->
    process.stdout.write "Importing... "
    @feeds.existUrl url, (exist) =>
      if exist
        console.log "✖".bold.red, "Feed already exists!"
        process.exit 2
      else
        reader = new FeedReader url
        reader.get (err, feed) =>
          if err
            console.log "✖".bold.red, err.message
            process.exit 127
          title = feed.title || url
          @feeds.create url, title, account, () -> console.log "✓".bold.green

  config: (key, value) ->
    console.log "Set config key #{key} to #{value}"
    Config.set key, value, (err) ->
      console.log "Error: #{err}" if err

  update: () ->
    console.log "Update all feeds"

  help: () ->
    console.log """
    Usage: f2d <command> [args]
      f2d list                      list feeds
      f2d add <account> <feed url>  add a feed URL to an account
      f2d config <key> <value>      set config key to value
      f2d update                    refresh all feeds
    """
    process.exit 1

exports.cli = new CmdParser argv
