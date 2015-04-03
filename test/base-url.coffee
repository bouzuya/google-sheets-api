assert = require 'power-assert'
baseUrl = require '../src/base-url'

describe 'baseUrl', ->
  it 'should equal "https://spreadsheets.google.com/feeds"', ->
    assert baseUrl is 'https://spreadsheets.google.com/feeds'
