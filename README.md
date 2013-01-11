Auto 4
======

_A modern, simple, extensible multi-protocol bot, reloaded._

**Version**:            4.0.0.a.0.3 (prealpha 3) "Phoenix"  
[![Build Status](https://travis-ci.org/Auto/Auto.png?branch=master)](https://travis-ci.org/Auto/Auto)
[![Dependency Status](https://gemnasium.com/Auto/Auto.png)](https://gemnasium.com/Auto/Auto)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Auto/Auto)

+ [Homepage](http://auto.autoproj.org) 
+ [Git](https://github.com/Auto/Auto)
+ [RubyGems](https://rubygems.org/gems/autobot)
+ [Wiki](https://github.com/Auto/Auto/wiki)
+ [Mailing List](https://groups.google.com/group/autobot-talk)
+ [SourceForge](https://sourceforge.net/p/auto-bot)
+ [Issue Hub](https://github.com/Auto/Auto/issues)

**Documentation** is available for the [latest git](http://rdoc.info/github/Auto/Auto),
and [this release](http://auto-bot.sourceforge.net/doc/4.0.0.a.0.3/).

Our official IRC channel is [#auto on irc.freenode.net](irc://irc.freenode.net/#auto).

Synopsis
--------

Auto is automated bot software, developed per thus philosophy:

* _Friendly_ to users, and to developers.
* _Simple_, _smart_, and _clean_.
* _Minimal_ but _extensible_.

Auto has a three-year history of service, dating back to December of 2009.
[Auto 3.0](https://github.com/Auto/Auto-legacy) was the last stable release,
and now the Auto Project presents this fourth major revision, 4.0 _Phoenix_,
intended to supersede 3.0 as a superior version.

Currently, it supports the IRCv3 protocol, with planned support for the XMPP
protocol. You can use it on many networks, including the six largest: Freenode,
QuakeNet, UnderNet, EFnet, DALnet, and IRCnet.

Quickstart
----------

This will install the latest (pre)release:

    $ gem install autobot --pre
    $ gem install sqlite3
    $ auto-conf
    $ auto

If you would prefer to use **MySQL** or **Postgres**, substitute the respective
command below for `gem install sqlite3`:

    $ gem install mysqlplus

**or**

    $ gem install pg

For detailed installation instructions, see
[the guide](https://github.com/Auto/Auto/wiki/Install-Guide). This will guide
you to such things as configuring Auto manually, installing a standalone
copy, and building from git.

**Note: Ruefully, as of January 10, 2013, we no longer support JRuby. Please
use MRI (the official interpreter) or Rubinius. Thank you.**

Developing
----------

Developers are provided extensive documentation of Auto 4 
[on rdoc.info](http://rdoc.info/github/Auto/Auto/).

With especial, peruse the [Developing for Auto](http://rdoc.info/github/Auto/Auto/file/docs/Developing.md)
document.

Support
-------

If you should find yourself in need of support, please foremost consult with the
documentation on the [wiki](https://github.com/Auto/Auto/wiki).

If the wiki fails to address your needs, please either:

1. Post to the [autobot-talk](https://groups.google.com/group/autobot-talk)
   group under the _support_ category, **or**
2. Join the official IRC chatroom at 
[#auto on irc.freenode.net](http://webchat.freenode.net/?randomnick=1&channels=#auto&prompt=1)

**Bugs** should be reported on the [issue management hub](https://github.com/Auto/Auto/issues).

Authors
-------

Auto 4 was rewritten from scratch by Autumn Perrault (noxgirl) in Ruby and C,
and is actively developed by the **Auto Project**:

+   [noxgirl](https://github.com/noxgirl)           - [xoeverlux@gmail.com](mailto://xoeverlux@gmail.com)
+   [swarley](https://github.com/swarley)           - [matthew.b.carey@gmail.com](mailto://matthew.b.carey@gmail.com)
+   [mattwb65](https://github.com/mattwb65)         - [mattwb65@gmail.com](mailto://mattwb65@gmail.com)

Contributors to earlier versions:

-   [Russell Bradford](https://github.com/RussellB28) \<russell@rbradford.me\>
-   [Liam Smith](https://github.com/liamsmithuk) \<me@liam.co\>
-   [Alyx Wolcott](https://github.com/alyx) \<contact@alyxw.me\>
-   [Mitchell Cooper](https://github.com/cooper) \<mitchell@notroll.net\>
-   [Timothy Estes](https://github.com/tim7967) \<tim7967@gmail.com\>
-   [Douglas Freed](https://github.com/dwfreed)
-   [Eitan Adler](https://github.com/grimreaper)
-   [Clay Freeman](https://github.com/clayfreeman) \<admin@clayfreeman.com\>
-   [Connor Youngquist](https://github.com/TheNull) \<thenull2.0@gmail.com\>

Legal
-----

Copyright (c) 2009-2013, Autumn Perrault, et al. All rights reserved.

Auto is free, open-source software, distributed per the terms of the two-clause
("FreeBSD") license, the full terms of which are in **LICENSE.md**.
