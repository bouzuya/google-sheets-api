# Client / Spreadsheet / Worksheet
#
# Example:
# worksheet = null
# client = newClient({ email: config.googleEmail, key: config.googleKey })
# spreadsheet = client.getSpreadsheet(config.googleSheetKey)
# spreadsheet.getWorksheetIds()
# .then (worksheetIds) ->
#   spreadsheet.getWorksheet(worksheetIds[0])
# .then (w) -> worksheet = w
# .then ->
#   worksheet.getValue({ row: 1, col: 1 })
# .then (value) ->
#   worksheet.setValue({ row: 1, col: 1, value: value })
# .then ->
#   worksheet.getCells({ row: 1 })
# .then (cells) ->
#   console.log cells.filter (i) -> i.col is 1
# .catch (e) ->
#   console.error e
#

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

module.exports = (credentials) ->
  new Client(credentials)
