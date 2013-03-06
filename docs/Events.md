# @title Specification of Events

Specification of Events
=======================

**Events** are managed by Syndi's event systems, each of which is an instance
of {Syndi::API::Events}.

`$m.events` manages the **Syndi** events, which is to say the central events,
while libraries have their own individual events systems.

{Syndi::DSL::Base} provides `#on`, `#emit`, `#undo_on`, etc., which all provide
easy distinction between the individual event systems. `:syndi`, for example,
indicates the central system, whereas `:irc` indicates the IRC event system.

:syndi
-----

### :start

This event occurs when Syndi is starting, and each library is expected to await
this event and upon its occurrence, initiate any of their processes.

### :die `|reason|`

**reason** (_String_): The reason for termination.

This occurs when Syndi is terminating.

### :rehash

This event occurs when the configuration file is successfully reprocessed and
reloaded.

:irc
----

### :preconnect |irc|

**irc** (_Syndi::IRC::Server_): The IRC connection.

This event occurs when we are about to register (i.e., send `USER`, `CAP LS`)
on the server and initiate connection.

### :disconnected |irc|

**irc** (_Syndi::IRC::Server_): The IRC connection.

This event occurs after the connection to the IRC server has been lost.

### :receive |irc, data|

**irc** (_Syndi::IRC::Server_): The IRC connection.  
**data** (_String_): The line of data.

This event occurs when data has been removed from the receive queue and is ready
for processing, with CRLFs stripped.

### :connected |irc|

**irc** (_Syndi::IRC::Server_): The IRC connection.

This event occurs after ISUPPORT has been received and processed, and the
connection is fully established.

Typically, at this point, any traditional service identification and syndijoining
occurs.

### :disconnect |irc, reason|

**irc** (_Syndi::IRC::Server_): The IRC connection.  
**reason** (_String_): The reason for which we are disconnecting.

This event occurs when we're about to disconnect from the given server.

### :send_join |irc, channel, key|

**irc** (_Syndi::IRC::Server_): The IRC connection.  
**channel** (_String_): The channel which we are attempting to join.  
**key** (_String_ or _nil_): The key, if provided.

This event occurs when we try to join a channel.

### :send_nick |irc, nickname|

**irc** (_Syndi::IRC::Server_): The IRC connection.  
**nickname** (_String_): The nickname we are trying to use.

This occurs when we try to change our nickname with /NICK.

### :self_who |irc|

**irc** (_Syndi::IRC::Server_): The IRC connection.

This occurs when we send a /WHO on ourselves.

### irc:onWhoReply `[all strs](irc*, nick, username, host, realname, awaystatus, server)`

This event occurs when the bot receives **RPL_WHOREPLY** (numeric 352) in response to a /WHO. Note that
`awaystatus =~ /H/` will be true if the user is not away, while `awaystatus =~ /G/` will be true if the
user is away (`H` meaning _here_, `G` meaning _gone_).
