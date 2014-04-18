assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.mapValues', ->
  it "maps over an empty object", ->
    res = _.deepMapValues {}, (val) -> assert.fail "shouldn't have called map fn"
    assert.deepEqual res, {}

  it "maps add1 over a flat object", ->
    res = _.deepMapValues { a: 1, b: 2 }, (val) -> val + 1
    assert.deepEqual res, { a: 2, b: 3 }

  it "maps add1 over a deep object", ->
    res = _.deepMapValues { a: { b: 1, c: 2 }, d: e: f: 3 }, (val) -> val + 1
    assert.deepEqual res, { a: { b: 2, c: 3 }, d: e: f: 4 }

  _.each [
    "foo"
    String
    5
    null
    []
  ], (input) ->
    it "applies the function on non object '#{input}'", ->
      res = _.deepMapValues input, (val) -> '_' + val
      assert.deepEqual res, '_' + input

describe '_.mapKeys', ->
  _.each [
    "foo"
    String
    5
    null
    []
  ], (input) ->
    it "returns the value on non object #{input}", ->
      res = _.deepMapKeys input, (val) -> assert.fail "shouldn't have called map fn"
      assert.deepEqual res, input

  it "maps over an empty object", ->
    res = _.deepMapKeys {}, (val) -> assert.fail "shouldn't have called map fn"
    assert.deepEqual res, {}

  it "maps add_ over a flat object", ->
    res = _.deepMapKeys { a: 1, b: 2 }, (val) -> val + '_'
    assert.deepEqual res, { a_: 1, b_: 2 }

  it "maps add_ over a deep object", ->
    res = _.deepMapKeys { a: { b: 1, c: 2 }, d: e: f: 3 }, (k) -> k + '_'
    assert.deepEqual res, { a_: { b_: 1, c_: 2 }, d_: e_: f_: 3 }
