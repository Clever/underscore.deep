assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.deepMapValues', ->
  _.each [
    "foo"
    String
    5
    null
    []
  ], (input) ->
    it "throws on non object '#{input}'", ->
      assert.throws (-> _.deepMapValues input, (v) -> v),
        /deepMapValues must be called on an object/

  it "maps over an empty object", ->
    res = _.deepMapValues {}, (val) -> assert.fail "shouldn't have called map fn"
    assert.deepEqual res, {}

  it "maps add1 over a flat object", ->
    res = _.deepMapValues { a: 1, b: 2 }, (val) -> val + 1
    assert.deepEqual res, { a: 2, b: 3 }

  it "maps add1 over a deep object", ->
    res = _.deepMapValues { a: { b: 1, c: 2 }, d: e: f: 3 }, (val) -> val + 1
    assert.deepEqual res, { a: { b: 2, c: 3 }, d: e: f: 4 }
