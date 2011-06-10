serialize = (x) ->
  json = JSON.stringify x
  switch x.constructor.name
    when 'Object','String','Number','Array','Function'
      json
    else
      "{\"__bless__\":\"#{x.constructor.name}\",#{json[1..]}" 

deserialize = (s, protos) ->
  JSON.parse s, (key, value) ->
    if value.__bless__?
      value.__proto__ = (protos ? GLOBAL)[value.__bless__].prototype
      delete value.__bless__
    value

exports.serialize   = serialize
exports.deserialize = deserialize
