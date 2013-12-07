assert = require 'assert'
_ = require('underscore')
_.mixin require('../underscore.deep.js')

describe '_.groupValues', ->

  tests = [
  	input: [{ a: 1, b: 2, c: 3, d: 4 }, ['a', 'b'], ['c'] ]
  	output: [[1, 2], [3]]
  ,
  	input: [{ a: 1, b: 2, c: 3, d: 4 }, ['a', 'b'], ((k) -> k isnt 'd') ]
  	output: [[1, 2], [3]]
  ,
	  input: [{ a: 1, b: 2, c: 3, d: 4 }, ((k) -> k isnt 'd'), ['a', 'b'] ]
  	output: [[1, 2, 3], []]
  ]
  _(tests).each (test) ->
  	it "groups values from #{JSON.stringify test.input[0]} based on #{JSON.stringify test.input[1..]}", ->
  		assert.deepEqual _.groupValues(test.input[0], test.input[1..]...), test.output
