assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.deepKeys', ->

    tests = [
      { input: { a: 1, b: 1, c: { d: 1, e: 1 } }, output: [ 'a', 'b', 'c.d', 'c.e' ] }
      { input: { a: 1, b: 1, c: { d: 1, e: { f: 1 } } }, output: [ 'a', 'b', 'c.d', 'c.e.f' ] }
    ]
    _(tests).each (test) ->
      it "extracts keys in dot notation from #{JSON.stringify test.input}", ->
        assert.deepEqual _.deepKeys(test.input), test.output
