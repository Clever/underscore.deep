assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.mapValues', ->
  it "throws on a non-object", ->
    assert.throws (-> _.mapValues [], (v) -> v),
      /mapValues must be called on an object/

  it "maps over an empty object", ->
    res = _.mapValues {}, (val) -> assert.fail "shouldn't have called map fn"
    assert.deepEqual res, {}

  it "maps add1 over an object", ->
    res = _.mapValues { a: 1, b: 2 }, (val) -> val + 1
    assert.deepEqual res, { a: 2, b: 3 }

  it "passes keys to the map fn", ->
    res = _.mapValues { a: 1, b: 2 }, (val, key) -> val + key
    assert.deepEqual res, { a: '1a', b: '2b' }
