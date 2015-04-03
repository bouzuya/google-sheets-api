assert = require 'power-assert'
projections = require '../src/projections'

describe 'projections', ->
  describe '#basic', ->
    it 'should equal "basic"', ->
      assert projections.basic is 'basic'

  describe '#full', ->
    it 'should equal "full"', ->
      assert projections.full is 'full'
