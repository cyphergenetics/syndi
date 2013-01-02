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
* _Minimal_ but _extendable_.

Auto has a three-year history of service, dating back to December of 2009.
[Auto 3.0](https://github.com/Auto/Auto-legacy) was the last stable release,
and now the Auto Project presents this fourth major revision, 4.0 _Phoenix_,
intended to supersede 3.0 as a superior version.

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

Developing for Auto 4
---------------------

Developers are provided extensive documentation of Auto 4 
[on rdoc.info](http://rdoc.info/github/Auto/Auto/).

If you should desire to generate your own copy of the documentation, mind that
Auto uses [YARD](http://yardoc.org/). Obtain the 
[yard gem](https://rubygems.org/gems/yard) and the 
[redcarpet gem](https://rubygems.org/gems/redcarpet); then, run `yardoc` in the
main directory.

We advise you to consult with especial the {file:docs/Contributing.md Standards of Contributing}.

Events are documented in {file:docs/Events.md API Events}. See also the [Project](#Project)
section below.

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

Project
-------

Auto 4 is maintained by the Auto Project, of which [noxgirl](https://github.com/noxgirl)
is the head. If you are interested in volunteering to join the team and aid
with Auto, please contact her [by e-mail](mailto://xoeverlux@gmail.com) and be
mindful of thus:

**Anyone** may contribute to Auto. Fork the repository using GitHub; change
the code as you will; to submit your changes as a contribution, submit a
[pull request](https://github.com/Auto/Auto/pulls) and the team will review
your changes. If they are acceptable, they will be merged into the main 
repository.

If you desire to be a developer, a history of contributions will be expected.
Why? Joining the team makes it easier to submit changes, and gives you certain
administrative privileges. Therefore, it is only sensible that you demonstrate
a history of contributing to Auto 4 before you are approved for this position.

Please note moreover that any contributions to
[Auto-legacy](https://github.com/Auto/Auto-legacy) will be additionally
considered.

Thank you. -noxgirl
