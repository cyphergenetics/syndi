# @title Specification of Events

Specification of Events
=======================

**Events** are managed by Auto's event systems, each of which is an instance
of {Auto::API::Events}.

`$m.events` manages the **Auto** events, which is to say the central events,
while libraries have their own individual events systems.

{Auto::DSL::Base} provides `#on`, `#emit`, `#undo_on`, etc., which all provide
easy distinction between the individual event systems. `:auto`, for example,
indicates the central system, whereas `:irc` indicates the IRC event system.

:auto
-----

### :start

This event occurs when Auto is starting, and each library is expected to await
this event and upon its occurrence, initiate any of their processes.

### :die `|reason|`

**reason** (_String_): The reason for termination.

This occurs when Auto is terminating.

### :net_receive `|socket_object|`

**socket_object** (_Object_): The object with which the socket (`.socket`) is
associated.

This occurs when the socket associated with `socket_object` has data waiting to
be read (as determined by `select()`).

### :rehash

This event occurs when the configuration file is successfully reprocessed and
reloaded.

:irc
----

### :preconnect |irc|

**irc** (_Auto::IRC::Server_): The IRC connection.

This event occurs when we are about to register (i.e., send `USER`, `CAP LS`)
on the server and initiate connection.

### :net_receive |irc|

**irc** (_Auto::IRC::Server_): The IRC connection.

This event occurs when there is data in the connection's receive queue waiting
to be processed.

### :receive |irc, data|

**irc** (_Auto::IRC::Server_): The IRC connection.  
**data** (_String_): The line of data.

This event occurs when data has been removed from the receive queue and is ready
for processing, with newlines and carriage returns stripped.

### :disconnect |irc, reason|

**irc** (_Auto::IRC::Server_): The IRC connection.  
**reason** (_String_): The reason for which we are disconnecting.

This event occurs when we're about to disconnect from the given server.

### :send_join |irc, channel, key|

**irc** (_Auto::IRC::Server_): The IRC connection.  
**channel** (_String_): The channel which we are attempting to join.  
**key** (_String_ or _nil_): The key, if provided.

This event occurs when we try to join a channel.

### :send_nick |irc, nickname|

**irc** (_Auto::IRC::Server_): The IRC connection.  
**nickname** (_String_): The nickname we are trying to use.

This occurs when we try to change our nickname with /NICK.

### :self_who |irc|

**irc** (_Auto::IRC::Server_): The IRC connection.

This occurs when we send a /WHO on ourselves.

### irc:onWhoReply `[all strs](irc*, nick, username, host, realname, awaystatus, server)`

This event occurs when the bot receives **RPL_WHOREPLY** (numeric 352) in response to a /WHO. Note that
`awaystatus =~ /H/` will be true if the user is not away, while `awaystatus =~ /G/` will be true if the
user is away (`H` meaning _here_, `G` meaning _gone_).
