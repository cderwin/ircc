import client
import options
import parseopt
import strutils

type
  Args = object
    nick: string
    chan: string
    serv: string

const
  version = "v0.1"
  doc = """
ircc

Usage:
  ircc [-n nick] [-c chan] [-s server]

Options:
  -h, --help                   Show this message
  -n nick, --nick nick         Use this nick
  -c chan, --chan chan         Connect to this channel
  -s server, --server server   Connect to this server [default: irc.freenode.net]
"""
  usage = """
Usage:
  ircc [-n nick] [-c chan] [-s server]
"""

proc print_help() =
  echo doc
  quit 0

proc print_version() =
  echo("Version v$1" % [version])
  quit 0

proc error(msg: string) =
  echo usage
  echo("Error: $1" % [msg])
  quit 1

proc parse_args(): Args =
  var
    nick = none(string)
    channels: seq[string] = @[]
    server = none(string)

  for kind, key, val in getopt():
    if kind == cmdArgument:
      error "No arguments accepted"

    case key
    of "help", "h":
      printHelp()

    of "version", "v":
      printVersion()

    of "nick", "n":
      if nick.isSome:
        error "Nick already passed in"

      nick = some(val)

    of "chan", "c":
      channels.add val

    of "server", "s":
      if server.isSome:
        error "Server already passed in"

      server = some(val)

    else:
      error("Unrecognized option `$1 $2`" % [key, val])

  if nick.isNone:
    error "No nick given"

  if channels.len > 1:
    error "Can only handle one channel currently"

  return Args(nick: nick.get, chan: channels[0], serv: server.get("irc.freenode.net"))


proc main() =
  let args = parse_args()
  let client = Client(nick: args.nick, host: args.serv, chan: args.chan)
  client.connect()
  client.login()
  client.join()
  client.listen()

main()
