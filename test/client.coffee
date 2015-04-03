assert = require 'power-assert'
{Client} = require '../src/client'

describe 'Client', ->
  beforeEach ->
    email = ''
    key = ''
    @worksheet = new Client({ email, key })

  describe '#parseXml', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.parseXml is 'function'

  describe '#request', ->
    it 'should be defined as a function', ->
      assert typeof @worksheet.request is 'function'
