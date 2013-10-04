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
