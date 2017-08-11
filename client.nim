import message
import net
import strutils

const
  debug = true

type
  Client* = ref object
    nick*, host*, chan*: string
    sock: Socket


proc log(msg: string) =
  if debug:
    echo msg, "\n"


proc send(self: Client, msg: string) {.raises: [IOError, OSError].} =
  if self.sock.isNil:
    raise newException(IOError, "Socket is nil")

  self.sock.send(msg & "\r\n")


proc wait_for(self: Client, cmd: string) {.raises: [IOError, TimeoutError, OSError].} =
  if self.sock.isNil:
    raise newException(IOError, "Socket is nil")

  while true:
    let raw_msg = self.sock.recvLine()
    if raw_msg == "":
      return

    echo raw_msg
    let msg = parse_message(raw_msg)
    if msg.command == cmd:
      return


proc connect*(self: Client, server: string = nil) {.raises: [OSError, ValueError].} =
  var server = server
  if server.isNil:
    server = self.host

  self.host = server
  self.sock = newSocket()
  self.sock.connect(server, Port(6667))
  log("Connected to `$1`" % [server])
  

proc login*(self: Client, nick: string = nil, msg = "Hi!") {.raises: [IOError, TimeoutError, OSError, ValueError].} =
  var nick = nick
  if nick.isNil:
    nick = self.nick

  self.nick = nick
  self.send("NICK $1" % [nick])
  self.send("USER $1 8 * : $2" % [nick, msg])
  self.wait_for("004")
  log("Client logged in with nick `$1`" % [nick])


proc join*(self: Client, chan: string = nil) {.raises: [IOError, TimeoutError, OSError, ValueError].} =
  var chan = chan
  if chan.isNil:
    chan = self.chan

  self.chan = chan
  self.send("JOIN $1" % [chan])
  self.wait_for("JOIN")
  log("Joined channel `$1`" % [chan])


proc listen*(self: Client) {.raises: [IOError, TimeoutError, OSError].} =
  if self.sock.isNil:
    raise newexception(IOError, "Socket is nil")

  while true:
    let raw_msg = self.sock.recvLine()
    if raw_msg == "":
      return

    let msg = raw_msg.parse_message()
    echo repr(msg)
