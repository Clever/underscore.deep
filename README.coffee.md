# underscore.deep

Underscore.deep is a collection of Underscore mixins that operate on nested
objects.

This README is written in [Literate CoffeeScript](http://coffeescript.org/#literate) as a [Mocha](http://visionmedia.github.io/mocha/) test suite, so you can execute all of the examples - just run:
  
```
make README.coffee.md
```

## Installation

```
npm install underscore
npm install underscore.deep
```

## Usage

```
_ = require 'underscore'
_.mixin require 'underscore.deep'
```

## Functions

    describe 'underscore.deep', ->
      {assert, _} = require './test/readmeHelpers'

### _.deepToFlat(obj)

Takes an object and produces a new object with no nested objects, converting any nested objects to sets of fields with dot-notation keys, recursively.

      describe '_.deepToFlat', ->

        it 'does nothing with shallow objects', ->
          assert.deepEqual _.deepToFlat({}),             {}
          assert.deepEqual _.deepToFlat( shallow: 1 ),   shallow: 1

        it 'deepToFlats nested objects', ->
          assert.deepEqual _.deepToFlat( deeply: { nested: 2 } ), 'deeply.nested': 2
          assert.deepEqual _.deepToFlat(
            user1:
              name:
                first: 'Deep'
                last: 'Blue'
              age: 33
          ), 
            'user1.name.first': 'Deep'
            'user1.name.last': 'Blue'
            'user1.age': '33'
    
### _.deepFromFlat(obj)

Takes an object and produces a new object with no dot-notation keys, converting any set of dot-notation keys with the same prefix to a nested object, recursively.

**Warning:** Any keys with a dot (`.`) in the input object will be converted to nested objects, so if you use dots in your keys you may want to replace them before you call `_.deepFromFlat`.

      describe '_.deepFromFlat', ->
        it 'does nothing with objects with no dot-notation', ->
          assert.deepEqual _.deepFromFlat({}),             {}
          assert.deepEqual _.deepFromFlat( shallow: 1 ),   shallow: 1

        it 'deepFromFlats a flat object', ->
          assert.deepEqual _.deepFromFlat( 'deeply.nested': 2 ), deeply: { nested: 2 }
          assert.deepEqual _.deepFromFlat(
            'user1.name.first': 'Deep'
            'user1.name.last': 'Blue'
            'user1.age': '33'
          ),
            user1:
              name:
                first: 'Deep'
                last: 'Blue'
              age: 33

### _.deepToFlat and _.deepFromFlat

Taken as a pair, `_.deepToFlat` and `_.deepFromFlat` have an interesting relationship:

      describe '_.deepToFlat and _.deepFromFlat', ->
        it 'they undo each other', ->
          deepObj = a: 1, b: { c: 2 }
          flatObj = a: 1, 'b.c': 2
          assert.deepEqual flatObj, _.deepToFlat deepObj
          assert.deepEqual deepObj, _.deepFromFlat flatObj

They are inverses (of a sort)! We can reformulate this as a property that holds for any `flatObj` and `deepObj`:

          assert.deepEqual flatObj, _.deepToFlat _.deepFromFlat flatObj
          assert.deepEqual deepObj, _.deepFromFlat _.deepToFlat deepObj

### _.deepClone(obj)

Takes an object and makes a copy of it, recursively copying any nested objects
or arrays. Instances of classes, like `Number` or `String`, are *not* cloned.

      describe '_.deepClone', ->

        orig =
          deepThings:
            proverbs:
              quote: 'Computer science is no more about computers' +
                'than astronomy is about telescopes.'
              sayer: 'Dijkstra'
            pools: [
              { depth: 10 }
              { depth: 20 }
              { depth: 30 }
            ]

        it 'clones an object deeply', ->
          copy = _.deepClone orig
          assert.deepEqual copy, orig
          assert.notStrictEqual copy, orig
          assert.notStrictEqual copy.deepThings.proverbs, orig.deepThings.proverbs
          assert.notStrictEqual copy.deepThings.pools, orig.deepThings.pools

        it 'is equivalent to the composition of _.deepFromFlat, _.clone, and _.deepToFlat', ->
          copy2 = _.deepFromFlat _.clone _.deepToFlat orig
          assert.deepEqual copy2, orig
          assert.notEqual copy2, orig

### _.deepHas

TODO

### _.deepKeys

TODO
