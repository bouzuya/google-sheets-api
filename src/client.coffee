google = require 'googleapis'
{Promise} = require 'es6-promise'
{parseString} = require 'xml2js'

baseUrl = require './base-url'
projections = require './projections'
visibilities = require './visibilities'
{Spreadsheet} = require './spreadsheet'
{Worksheet} = require './worksheet'

class Client
  @baseUrl: baseUrl

  @visibilities: visibilities

  @projections: projections

  constructor: ({ @email, @key }) ->

  getSpreadsheet: (key) ->
    new Spreadsheet({ client: @, key })

  request: (options) ->
    @_authorize({ @email, @key })
    .then (client) ->
      new Promise (resolve, reject) ->
        client.request options, (err, data) ->
          if err? then reject(err) else resolve(data)

  _authorize: ({ email, key })->
    new Promise (resolve, reject) ->
      scope = ['https://spreadsheets.google.com/feeds']
      jwt = new google.auth.JWT(email, null, key, scope, null)
      jwt.authorize (err) ->
        if err? then reject(err) else resolve(jwt)

  parseXml: (xml) ->
    new Promise (resolve, reject) ->
      parseString xml, (err, parsed) ->
        if err? then reject(err) else resolve(parsed)

module.exports.Client = Client
