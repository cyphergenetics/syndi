# @title API Events

API Events
==========

## Bot

### bot:onLoadPlugin `([str] plugin)`

This event occurs when a plugin, `plugin`, is successfully initialized.

### bot:onUnloadPlugin `([str] plugin)`

This event occurs when a plugin, `plugin`, is unloaded from the runtime.

### bot:onRehash

**->** `(nil)`

This event occurs when the configuration file is successfully reprocessed and reloaded.

### bot:onTerminate `(nil)`

This event occurs when the bot is terminating, immediately prior **irc** module's disconnection
from all networks.

## IRC

Common variables are marked with an asterisk (`*`):

* `irc*` is the {IRC::Server} object.
* `sender*` and `user*` are the {IRC::Object::User} objects.
* `msg*` is an {IRC::Object::Message} object.

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