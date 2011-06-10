{serialize,deserialize} = require 'blessed-serialization'

values = [ 
  "A", 12, 3.1459, -99999999, 
  [1..10], {x:42,y:'hello'}, [1,2,3,"foo",{x:["a","b"]}] 
]

class Foo
  constructor: (@x=19,@y="yo") ->
  dump: -> "x is #{@x}, y is #{@y}"

class Bar extends Foo
  constructor: (@a="brian",@b=36) -> 
    super()
    @local_foo = new Foo 1,"you!"
  dump: ->
    super() + "; and a is #{@a}, b is #{@b}"

exports.test_primitives = (test) ->
  for v in values
    test.doesNotThrow (-> serialize v)
  for v in values
    test.deepEqual (deserialize (serialize v), {Foo,Bar}), v
  test.done()

exports.test_custom_objects = (test) ->
  x = deserialize (serialize new Foo), {Foo}
  test.ok (x instanceof Object)
  test.ok (x instanceof Foo)
  test.ok x.dump?
  test.equal x.dump(), "x is 19, y is yo"

  x = deserialize (serialize new Bar), {Bar}
  test.ok (x instanceof Object)
  test.ok (x instanceof Foo)
  test.ok (x instanceof Bar)
  test.ok x.dump?
  test.equal x.dump(), "x is 19, y is yo; and a is brian, b is 36"
  test.equal x.local_foo.y, "you!"

  test.done()

