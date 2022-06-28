assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.deepClone', ->
  orig =
    prims:
      num: 1
      str: '2'
      bool: true
    objects:
      Number: new Number()
      String: new String()
      Boolean: new Boolean()
      Date: new Date()
    structs:
      array: [4, 5, 6]
      instance: new Error("i'm an error")

  copy = _.deepClone orig

  it 'clones an object', ->
    assert.deepEqual copy, orig
    assert.notStrictEqual copy, orig

  it 'clones nested objects recursively', ->
    _.each copy, (nested, k) ->
      assert.deepEqual nested, orig[k]
      assert.notStrictEqual nested, orig[k]

  it "doesn't clone primitives, since you can't", ->
    _.each copy.prims, (v, k) ->
      assert.strictEqual v, orig.prims[k]

  it 'clones primitive objects', ->
    _.each copy.objects, (v, k) ->
      assert.deepEqual v, orig.objects[k]
      assert.notStrictEqual v, orig.objects[k]

  it 'clones arrays recursively', ->
    assert.deepEqual copy.structs.array, orig.structs.array
    assert.notStrictEqual copy.structs.array, orig.structs.array

  it "doesn't clone class intances", ->
      assert.strictEqual copy.structs.instance, orig.structs.instance

  it "correcly copies truthy and falsy boolean objects", ->
    bools =
      truthy_true: new Boolean(true)
      truthy_anything: new Boolean("anything")
      falsy_empty: new Boolean()
      falsy_false: new Boolean(false)
      falsy_zero: new Boolean(0)
    copied_bools = _.deepClone(bools)

    assert.deepEqual bools, copied_bools
    assert.notStrictEqual bools, copied_bools
