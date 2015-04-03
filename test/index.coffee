assert = require 'power-assert'
index = require '../src/'

describe 'index', ->
  it 'should be defined as a function', ->
    assert typeof index is 'function'
