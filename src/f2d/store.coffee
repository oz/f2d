sqlite3 = require 'sqlite3'
colors  = require 'colors'

# Wraps sqlite3 a little...
class Store
  constructor: (@dbpath) -> @db = new sqlite3.Database @dbpath

  run: (sql..., cb) ->
    @with_table () =>
      #console.log "Run SQL: #{sql}"
      @db.run sql..., cb()

  get: (sql..., cb) ->
    @with_table () =>
      @db.get sql..., (err, row) ->
        if (err) then throw(err) else cb(row)

  each: (sql, cb) -> @with_table () => @db.each sql, cb

  with_table: (cb) ->
    @db.run @table_definition, (err) ->
      if err then throw(err) else cb()

class Feeds extends Store
  # Table definition for node-sqlite3
  table_definition: """
                    create table if not exists 'feeds' (
                      url             text,
                      name            varchar(255),
                      account         varchar(255),
                      last_updated_at datetime
                    )
                    """

  constructor: (@dbpath) -> super @dbpath

  each: (cb) ->
    super "select rowid as id,
                  url,
                  name,
                  account,
                  last_updated_at
           from feeds", (err, row) -> if (err) then throw(err) else cb row

  existUrl: (url, cb) ->
    @get "select rowid as id,
                 name
          from feeds
          where url = ?", [url], (row) -> cb(row isnt undefined)

  create: (url, title, account, cb) ->
    @run "insert into feeds (name, url, account)
          values(?, ?, ?)", [title, url, account] , cb

  update: () ->
    console.log "Update feeds"

exports.feeds = Feeds
