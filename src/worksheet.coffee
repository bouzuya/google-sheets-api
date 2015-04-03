# FIXME: require './client' is circular reference.
# FIXME: Client.visibilities
# FIXME: Client.projections
# FIXME: Client.baseUrl

class Worksheet
  constructor: ({ @client, @spreadsheet, @id }) ->

  getValue: (position) ->
    { row, col } = @_parsePosition(position)
    url = @_getCellUrl
      key: @spreadsheet.key
      worksheetId: @id
      visibilities: Client.visibilities.private
      projections: Client.projections.full
      row: row
      col: col
    @client.request({
      url,
      method: 'GET'
      headers:
        'GData-Version': '3.0'
        'Content-Type': 'application/atom+xml'
    })
    .then @client.parseXml.bind(@client)
    .then (data) ->
      data.entry.content[0]

  getCells: ->
    url = @_getCellsUrl
      key: @spreadsheet.key
      worksheetId: @id
      visibilities: Client.visibilities.private
      projections: Client.projections.full
    @client.request({
      url,
      method: 'GET'
      headers:
        'GData-Version': '3.0'
        'Content-Type': 'application/atom+xml'
    })
    .then @client.parseXml.bind(@client)
    .then (data) =>
      data.feed.entry.map (i) =>
        [_, colName, rowString] = i.title[0].match(/^([A-Z]+)(\d+)$/)
        row = parseInt(rowString, 10)
        col = @_parseColumnName(colName)
        { row, col, value: i.content[0] }

  setValue: (positionAndValue) ->
    { row, col } = @_parsePosition(positionAndValue)
    { value } = positionAndValue
    url = @_getCellUrl
      key: @spreadsheet.key
      worksheetId: @id
      visibilities: Client.visibilities.private
      projections: Client.projections.full
      row: row
      col: col
    @client.request({
      url,
      method: 'GET'
      headers:
        'GData-Version': '3.0'
        'Content-Type': 'application/atom+xml'
    })
    .then @client.parseXml.bind(@client)
    .then (data) =>
      contentType = 'application/atom+xml'
      xml = """
        <entry xmlns="http://www.w3.org/2005/Atom"
            xmlns:gs="http://schemas.google.com/spreadsheets/2006">
          <id>#{url}</id>
          <link rel="edit" type="#{contentType}" href="#{url}"/>
          <gs:cell row="#{row}" col="#{col}" inputValue="#{value}"/>
        </entry>
      """
      @client.request({
        url,
        method: 'PUT'
        headers:
          'GData-Version': '3.0'
          'Content-Type': contentType
          'If-Match': data.entry.$['gd:etag']
        body: xml
      })
    .then @client.parseXml.bind(@client)

  deleteValue: (position) ->
    { row, col } = @_parsePosition(position)
    url = @_getCellUrl
      key: @spreadsheet.key
      worksheetId: @id
      visibilities: Client.visibilities.private
      projections: Client.projections.full
      row: row
      col: col
    @client.request({
      url,
      method: 'GET'
      headers:
        'GData-Version': '3.0'
        'Content-Type': 'application/atom+xml'
    })
    .then @client.parseXml.bind(@client)
    .then (data) =>
      contentType = 'application/atom+xml'
      @client.request({
        url,
        method: 'DELETE'
        headers:
          'GData-Version': '3.0'
          'Content-Type': contentType
          'If-Match': data.entry.$['gd:etag']
      })
    .then @client.parseXml.bind(@client)

  # visibilities: private / public
  # projections: full / basic
  _getCellUrl: ({ key, worksheetId, visibilities, projections, row, col }) ->
    path = """
/cells/#{key}/#{worksheetId}/#{visibilities}/#{projections}/R#{row}C#{col}
    """
    Client.baseUrl + path

  # visibilities: private / public
  # projections: full / basic
  _getCellsUrl: ({ key, worksheetId, visibilities, projections }) ->
    path = "/cells/#{key}/#{worksheetId}/#{visibilities}/#{projections}"
    Client.baseUrl + path

  _parsePosition: ({ row, col, r1c1 }) ->
    return { row, col } if row? and col?
    throw new Error() if row? or col?
    throw new Error() unless r1c1?
    [_, row, col] = r1c1.match(/^R(\d+)C(\d+)$/)
    { row, col }

  _getColumnName: (col) ->
    String.fromCharCode('A'.charCodeAt(0) + col - 1)

  _parseColumnName: (colName) ->
    # TODO: colName 'AA' support
    colName.charCodeAt(0) - 'A'.charCodeAt(0) + 1

module.exports.Worksheet = Worksheet
