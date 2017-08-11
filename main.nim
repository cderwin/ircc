import client

proc main() =
  let client = Client(nick: "cd", host: "irc.freenode.net", chan: "#irchacks")
  client.connect()
  client.login()
  client.join()
  client.listen()

main()
