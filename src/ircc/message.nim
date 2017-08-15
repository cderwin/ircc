import strutils

type
  Message* = ref object
    user*, command*, param*, text*: string

proc skip(base: string; pat: char): tuple[first: string, last: string] =
  let index = base.find(pat)
  if index == -1:
    return (first: base, last: "")

  return (base[0..index], base[index+1..^1])

proc parse_message*(raw: string): Message =
  result = Message()
  if raw.isNil:
    return result

  var msg = raw.strip()

  var body = msg
  if msg[0] == ':':
    var header: string
    msg = msg[1..^1]
    (header, body) = msg.skip(' ')
    result.user = header.skip('!').first

  var rest: string
  (result.command, rest) = body.skip(' ')
  (result.param, result.text) = rest.skip(':')
  result.param = result.param.strip()
