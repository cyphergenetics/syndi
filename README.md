Auto 4.0 _Phoenix_
==================

**by the Auto Project**:

-   [noxgirl](https://github.com/noxgirl) \<xoeverlux@gmail.com\>
-   [swarley](https://github.com/swarley) \<matthew.b.carey@gmail.com\>
-   [mattwb65](https://github.com/mattwb65) \<mattwb65@gmail.com\>

See also **Contributors** below.

**Latest**:             4.0.0.a.0.1 (pre-alpha 1) "Phoenix"
[![Build Status](https://travis-ci.org/Auto/Auto.png?branch=master)](https://travis-ci.org/Auto/Auto) [![Dependency Status](https://gemnasium.com/Auto/Auto.png)](https://gemnasium.com/Auto/Auto)  
**Homepage**:           http://auto.autoproj.org  
**Git**:                https://github.com/Auto/Auto  
**RubyGems**:           https://rubygems.org/gems/autobot  
**Wiki**:               https://github.com/Auto/Auto/wiki  
**Docs**:               http://rdoc.info/github/Auto/Auto/  
**Mailing Group**:      [autobot-talk](https://groups.google.com/group/autobot-talk)  
**Issue Hub**:          https://github.com/Auto/Auto/issues

**Copyright**:          2009-2013, Auto Project  
**License**:            FreeBSD (see **LICENSE.md**)

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
protocol.

Requirements
------------

You need at least [Ruby 1.9.2](http://www.ruby-lang.org/en/downloads/).

To make life easier, we suggest you install [bundler](https://rubygems.org/gems/bundler),
run `bundle install --without test` (exclude `--without test` if you wish to
develop/test), and then install your database gem (see below).

Users of the [autobot](https://rubygems.org/gems/autobot) gem need only concern
themselves with their database gem (see below).

Mandatory Ruby gems:

* [sequel](https://rubygems.org/gems/sequel)
* [slop](https://rubygems.org/gems/slop)
* [colored](https://rubygems.org/gems/colored)

Needed for testing and development:

* [rake](https://rubygems.org/gems/rake)
* [bacon](https://rubygems.org/gems/bacon)
* [mocha](https://rubygems.org/gems/mocha)
* [mocha-on-bacon](https://rubygems.org/gems/mocha-on-bacon)

Depending on the database management system you are using, you need:

* **SQLite** (suggested): [sqlite3](https://rubygems.org/gems/sqlite3)
* **MySQL**: [mysqlplus](https://rubygems.org/gems/mysqlplus)
* **PostgreSQL**: [pg](https://rubygems.org/gems/pg)

Quickstart
----------

Configure Auto:

    $ bin/auto-conf

Now start your bot:

    $ bin/auto

**Note** that if you installed the [autobot](https://rubygems.org/gem/autobot)
gem, you mustn't include `bin/` in your commands (e.g. just use `auto`).

For full installation directions, see [the guide](https://github.com/Auto/Auto/wiki/Install-Guide).

You may wish to browse the [community-maintained wiki](https://github.com/Auto/Auto/wiki),
join the [autobot-talk mailing group](https://groups.google.com/group/autobot-talk),
and join the official IRC channel, [#auto on irc.freenode.net](irc://irc.freenode.net/#auto).

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

Contributors
------------

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
