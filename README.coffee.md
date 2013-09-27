# underscore.deep

Underscore.deep is a collection of Underscore mixins that operate on nested
objects.

The following README is written in Literate CoffeeScript as a Mocha test suite,
so you can execute all of the examples - just run:
  
```
make README.coffee.md
```

## Installation

```
npm install underscore
npm install underscore.deep
```

## Usage

    _ = require 'underscore'
    _.mixin require './underscore.deep' # you should omit the ./

## Functions

    assert = require 'assert'
    describe 'underscore.deep', ->

### _.flatten(obj)

Takes an object and produces a new object with no nested objects, converting any nested objects to sets of fields with dot-notation keys, recursively.

    describe '_.flatten', ->
      it 'flattens a deep object', ->
        assert.deepEqual _.flatten({}), {}
        assert.deepEqual _.flatten( a: 1 ), a: 1
        assert.deepEqual _.flatten( a: { b: 2 } ), 'a.b': 2
        assert.deepEqual _.flatten(
          a:
            b:
              c: 3
              d: 4
            e: 5
          f: 6
        ),
          'a.b.c': 3
          'a.b.d': 4
          'a.e': 5
          f: 6
    
### _.deepen(obj)

Takes an object and produces a new object with no dot-notation keys, converting any set of dot-notation keys with the same prefix to a nested object, recursively.

**Warning:** Any keys with a dot (`.`) in the input object will be converted to nested objects, so if you use dots in your keys you may want to replace them before you deepen.

    describe '_.deepen', ->
      it 'deepens a flat object', ->
        assert.deepEqual _.deepen({}), {}
        assert.deepEqual _.deepen( a: 1 ), a: 1
        assert.deepEqual _.deepen( 'a.b': 2 ), a: { b: 2 }
        assert.deepEqual _.deepen(
          'a.b.c': 3
          'a.b.d': 4
          'a.e': 5
          f: 6
        ),
          a:
            b:
              c: 3
              d: 4
            e: 5
          f: 6

## _.flatten and _.deepen

Taken as a pair, `_.flatten` and `_.deepen` have an interesting relationship:

    describe '_.flatten and _.deepen', ->
      it 'they undo each other', ->
        deepObj = a: 1, b: { c: 2 }
        flatObj = a: 1, 'b.c': 2
        assert.deepEqual flatObj, _.flatten deepObj
        assert.deepEqual deepObj, _.deepen flatObj

They are inverses (of a sort)! We can reformulate this as a property that holds for any `flatObj` and `deepObj`:

        assert.deepEqual flatObj, _.flatten _.deepen flatObj
        assert.deepEqual deepObj, _.deepen _.flatten deepObj

## _.deepClone(obj)

Takes an object and makes a copy of it, recursively copying any nested objects
or arrays.

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

      it 'is equivalent to the composition of _.deepen, _.clone, and _.flatten', ->
        copy2 = _.deepen _.clone _.flatten orig
        assert.deepEqual copy2, orig
        assert.notEqual copy2, orig

## _.deepHas

TODO

## _.deepKeys

TODO
