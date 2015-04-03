{Worksheet} = require './worksheet'
baseUrl = require './base-url'
projections = require './projections'
visibilities = require './visibilities'

class Spreadsheet
  constructor: ({ @client, @key }) ->

  getWorksheet: (id) ->
    new Worksheet({ @client, spreadsheet: @, id })

  getWorksheetIds: ->
    url = @_getWorksheetsUrl
      key: @key
      visibilities: visibilities.private
      projections: projections.basic

    @client.request({ url })
    .then @client.parseXml.bind(@client)
    .then (data) ->
      data.feed.entry.map (i) ->
        u = i.id[0]
        throw new Error() if u.indexOf(url) isnt 0
        u.replace(url + '/', '')

  # visibilities: private / public
  # projections: full / basic
  _getWorksheetsUrl: ({ key, visibilities, projections }) ->
    path = "/worksheets/#{key}/#{visibilities}/#{projections}"
    baseUrl + path

module.exports.Spreadsheet = Spreadsheet
