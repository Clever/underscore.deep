_ = require 'underscore'

module.exports =

  deepKeys: deepKeys = (obj, prefix='') ->
    keys = []
    for key, val of obj
      if _.isObject(val) and not _.isArray(val)
        keys = _.union keys, deepKeys(val, "#{prefix}#{key}.")
      else
        keys.push "#{prefix}#{key}"
    keys

  # http://stackoverflow.com/questions/4459928/how-to-deep-clone-in-javascript
  # This is mostly the same as the accepted answer, just shorter.
  # However, whereas they convert instances of String, etc. to the literal, we create a new instance
  # (`return type object for type` -> `return new type object for type`). This also allows us to
  # handle Dates in the same statement.
  # TODO: Support all core objects in js: Array, Boolean, Date, Function, Math, Number, RegExp, and
  #       String. Currently missing Function, Math, and RegExp.
  deepClone: deepClone = (object) ->
    return object if not object?

    # normalizing primitives e.g. if someone did new String('aaa'), or new Number('444');
    return new type object for type in [Date, Number, String, Boolean] when object instanceof type

    # for arrays clone each element of it
    return _(object).map deepClone if _(object).isArray()

    # primitives like numbers, strings and stuff
    return object if not _(object).isObject()

    # if this is a DOM element
    return object.cloneNode true if object.nodeType and _(object.cloneNode).isFunction()

    # a class of some sort - we can't handle this, so we just return it
    return object unless object.constructor is {}.constructor

    # it is an object literal
    mapValues object, deepClone

  # like "of" operator except can recurse on keys with dot notation
  deepHas: (obj, keys) ->
    helper = (obj, keys) ->
      if (keys.length is 0) or (not _.isObject obj)
        false
      else if keys.length is 1
        _.first(keys) of obj
      else
        helper obj[_.first(keys)], _.rest(keys)
    helper obj, if _.isArray keys then keys else keys.split('.')

  deepDelete: deepDelete = (obj, key) ->
    return if not key? or not obj?
    key = key.split '.' if not _(key).isArray()
    if key.length is 1
      delete obj[key]
      return
    deepDelete obj[key[0]], key.slice(1, key.length)

  # Like _.extend, except instead of overwriting all nested objects, it extends
  # each leaf of `obj` with the value at the corresponding leaf of `ext`.
  # Note: this function is pure - it returns a new object instead of mutating
  # the original object. If you must have a mutative version, pass true as the
  # third `mutate` parameter.
  deepExtend: deepExtend = (obj, ext, mutate) ->
    _.reduce ext, (acc, val, key) =>
      acc[key] =
        if (key of obj) and isPlainObject(obj[key]) and isPlainObject(val)
        then deepExtend obj[key], val
        else val
      acc
    , if mutate then obj else _.clone obj

  isPlainObject: isPlainObject = (value) -> value?.constructor is {}.constructor

  deepToFlat: (obj) ->
    res = {}
    recurse = (obj, current) ->
      for key of obj
        value = obj[key]
        newKey = ((if current then current + "." + key else key)) # joined key with dot
        if value and isPlainObject value
          recurse value, newKey # it's a nested object, so do it again
        else
          res[newKey] = value # it's not an object, so set the property
    recurse obj
    res

  # Takes an object with keys with dot.notation and deepens it into dot{notation:{}}
  deepFromFlat: (o) ->
    oo = {}
    t = undefined
    parts = undefined
    part = undefined
    for k of o
      t = oo
      parts = k.split(".")
      key = parts.pop()
      while parts.length
        part = parts.shift()
        t = t[part] = t[part] or {}
      t[key] = o[k]
    oo

  # Takes an object and replaces each of its values with the result of a
  # function applied to that value (and its key).
  mapValues: mapValues = (obj, f_val) ->
    _.object _.keys(obj), _.map(obj, f_val)

  deepMapValues: deepMapValues = (obj, f) ->
    if isPlainObject obj
      mapValues obj, (v) -> deepMapValues v, f
    else
      f obj
