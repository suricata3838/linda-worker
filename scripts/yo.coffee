## config Yo API token with ENV var
# export YO_DELTA="DeltaS112's token"
# export YO_IOTA="Iota411's token"

Yo = require 'yo-api'

module.exports = (linda) ->

  config = linda.config

  getToken = (name) ->
    return process.env["YO_#{name.toUpperCase()}"]

  yo = (name, callback = ->) ->
    unless token = getToken(name)
      return callback 'token not exists'
    _yo = new Yo(token)
    _yo.yo_all callback


  ts = linda.tuplespace config.linda.space

  linda.io.on 'connect', ->
    linda.debug "watch #{ts.name}"

    ts.watch {type: "yo"}, (err, tuple) ->
      return if err
      return if tuple.data.result?
      return unless tuple.data.value?
      linda.debug tuple
      yo tuple.data.value, (err, res) ->
        if err
          tuple.data.result = "fail"
        else
          tuple.data.result = "success"
        ts.write tuple.data
