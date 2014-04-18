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

 describe '_.mapKeys', ->
  it "throws on a non-object", ->
    assert.throws (-> _.mapKeys [], (v) -> v),
      /mapKeys must be called on an object/

  it "maps over an empty object", ->
    res = _.mapKeys {}, (val) -> assert.fail "shouldn't have called map fn"
    assert.deepEqual res, {}

  it "maps add1 over an object", ->
    res = _.mapKeys { a: 1, b: 2 }, (val) -> val + '_'
    assert.deepEqual res, { a_: 1, b_: 2 }

  it "passes vals to the map fn", ->
    res = _.mapKeys { a: 1, b: 2 }, (val, key) -> val + key
    assert.deepEqual res, { a1: 1, b2: 2 }

  it "passes weird vals also", ->
    res = _.mapKeys { a: [1], b: 2 }, (key) -> key + '_'
    assert.deepEqual res, { a_: [1], b_: 2 }
