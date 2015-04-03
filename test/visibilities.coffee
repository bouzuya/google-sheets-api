assert = require 'power-assert'
visibilities = require '../src/visibilities'

describe 'visibilities', ->
  describe '#private', ->
    it 'should equal "private"', ->
      assert visibilities.private is 'private'

  describe '#public', ->
    it 'should equal "public"', ->
      assert visibilities.public is 'public'
