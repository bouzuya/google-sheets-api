assert = require 'power-assert'
{Worksheet} = require '../src/worksheet'

describe 'Worksheet', ->
  beforeEach ->
    client = {}
    spreadsheet = {}
    id = ''
    @worksheet = new Worksheet({ client, spreadsheet, id })

  describe '#getValue', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.getValue is 'function'

  describe '#getCells', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.getCells is 'function'

  describe '#setValue', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.setValue is 'function'

  describe '#deleteValue', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.deleteValue is 'function'
