import docopt
import ircc/client

type
  Args = object
    nick: string
    chan: string
    serv: string

let doc = """
ircc.

Usage:
  ircc [-n nick] [-c chan] [<server>]

Options:
  -h, --help                   Show this message
  -n nick, --nick nick         Use this nick
  -c chan, --chan chan         Connect to this channel
  -s server, --server server   Connect to this server [default: irc.freenode.net]
"""

proc parse_args(): Args =
  let args = docopt(doc, version = "ircc v0.1")
  result = Args()
  result.nick = args["--nick"]
  result.chan = args["--chan"]
  result.serv = args["--server"]


proc main() =
  let args = parse_args()
  let client = Client(nick: args.nick, host: args.serv, chan: args.chan)
  client.connect()
  client.login()
  client.join()
  client.listen()

main()
