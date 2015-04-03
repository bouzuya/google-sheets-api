assert = require 'power-assert'
{Spreadsheet} = require '../src/spreadsheet'

describe 'Spreadsheet', ->
  beforeEach ->
    client = {}
    key = ''
    @worksheet = new Spreadsheet({ client, key })

  describe '#getWorksheet', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.getWorksheet is 'function'

  describe '#getWorksheetIds', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.getWorksheetIds is 'function'
