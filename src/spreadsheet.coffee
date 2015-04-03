# FIXME: require './client' is circular reference.
# FIXME: Client.visibilities
# FIXME: Client.projections
# FIXME: Client.baseUrl

class Spreadsheet
  constructor: ({ @client, @key }) ->

  getWorksheet: (id) ->
    new Worksheet({ @client, spreadsheet: @, id })

  getWorksheetIds: ->
    url = @_getWorksheetsUrl
      key: @key
      visibilities: Client.visibilities.private
      projections: Client.projections.basic

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
    Client.baseUrl + path

module.exports.Spreadsheet = Spreadsheet
