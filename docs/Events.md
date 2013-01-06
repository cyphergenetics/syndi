# @title Events Specification

Events
======

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

### :disconnect |irc, reason|

**irc** (_Auto::IRC::Server_): The IRC connection.  
**reason** (_String_): The reason for which we are disconnecting.

This event occurs when we're about to disconnect from the given server.

### irc:introduceUser

**->** `(user*)`

This event occurs when a new user, `user`, is introduced to the bot.

### irc:onDisconnect

**->** `(irc*, [str] reason)`

This event occurs immediately before the bot disconnects from the given IRC network.

### irc:onPreJoin

**->** `(irc*, [str] channel, [str] key)`

This event occurs immediately before the bot attempts to join a channel. `key` will be nil if it is
unneeded. See irc:onJoinChan for a successful /JOIN.

### irc:onJoin

**->** `(irc*, [str] channel, [str] key)`

This event occurs immediately after the bot attempts to join a channel. `key` will be nil if it is
unneeded. See irc:onJoinChan for a successful /JOIN.

### irc:onRecvChanMsg `(irc*, sender*, [str] channel, [ary] message)`

This event occurs when a channel the bot is in receives a message. `channel` is the channel in
question, and `message` is the body of the message in an array (the message is split into elements
by its spaces).

### irc:onRecvPrivMsg `(irc*, sender*, [str] message)`

This event occurs when the bot receives a private message. `message` is the body of the message in
an array (the message is split into elements by its spaces).

### irc:onPreMsgUser

**->** `(user*, [str] message)`

This event occurs prior to the bot sending a private message to a user.

### irc:onMsgUser

**->** `(user*, [str] message)`

This event occurs following the bot sending a private message to a user.

### irc:onPreNick

**->** `(irc*, [str] nickname)`

This event occurs before the bot attempts to change its nickname to `nickname`.

### irc:onNick

**->** `(irc*, [str] nickname)`

This event occurs after the bot attempts to change its nickname to `nickname`.

### irc:onPreNoticeUser

**->** `(user*, [str] notice)`

This event occurs prior to the bot sending a notice to a user.

### irc:onNoticeUser

**->** `(user*, [str] notice)`

This event occurs following the bot sending a notice to a user.

### irc:onWhoSelf

**->** `(irc*)`

This event occurs when the bot requests a /WHO of itself.

### irc:onWhoUser

**->** `(user*)`

This event occurs after a /WHO has been requested of a user.

### irc:onWhoReply `[all strs](irc*, nick, username, host, realname, awaystatus, server)`

This event occurs when the bot receives **RPL_WHOREPLY** (numeric 352) in response to a /WHO. Note that
`awaystatus =~ /H/` will be true if the user is not away, while `awaystatus =~ /G/` will be true if the
user is away (`H` meaning _here_, `G` meaning _gone_).

## System
