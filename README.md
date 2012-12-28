Auto 4.0 _Phoenix_
==================

**by the Auto Project**:

-   [noxgirl](https://github.com/noxgirl) \<xoeverlux@gmail.com\>
-   [swarley](https://github.com/swarley) \<matthew.b.carey@gmail.com\>
-   [mattwb65](https://github.com/mattwb65) \<mattwb65@gmail.com\>

See also **Contributors** below.

**Latest**:             4.0.0d (codename _Phoenix_)
[![Build Status](https://travis-ci.org/Auto/Auto.png?branch=master)](https://travis-ci.org/Auto/Auto) [![Dependency Status](https://gemnasium.com/Auto/Auto.png)](https://gemnasium.com/Auto/Auto)  
**Homepage**:           http://auto.autoproj.org  
**Git**:                https://github.com/Auto/Auto  
**Wiki**:               https://github.com/Auto/Auto/wiki  
**Docs**:               http://rdoc.info/github/Auto/Auto/  
**Mailing List**:       [autobot-news](https://groups.google.com/forum/#!forum/autobot-news) (news concerning Auto)  
**Issue Hub**:          https://github.com/Auto/Auto/issues

**Copyright**:          2009-2013, Auto Project  
**License**:            New BSD (see **LICENSE.md**)

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

Using Auto 4
------------

You need [Ruby 1.9](http://www.ruby-lang.org/en/downloads/) to use Auto.
Currently, Windows is unsupported; support is however planned for the future. 
You are advised to consult the documentation provided by the 
[wiki](https://github.com/Auto/Auto/wiki).

Additionally, because Auto employs the light and useful SQLite 3 for database
management, you must have [SQLite 3](http://www.sqlite.org/) installed, as well
as the [sqlite3 Ruby gem](https://rubygems.org/gems/sqlite3).

Open `conf/example.yml` and go over the configuration, which is in YAML,
specifying the settings to your liking, then save it as `conf/auto.yml`.
See [Configuring Auto](https://github.com/Auto/Auto/wiki/Configuring-Auto).

If YAML is not pleasing to you, Auto has support for **JSON**. There is no
wiki page for this, however, so you will have to configure `conf/example.json`
using your own intuition. Save it as `conf/auto.json`, and start Auto with the
`-j` (`--json`) switch (which is effectively an alias for `--config=conf/auto.json`).

Run Auto 4 with `ruby auto.rb`.

Developing for Auto 4
---------------------

Developers are provided extensive documentation of Auto 4 
[on rdoc.info](http://rdoc.info/github/Auto/Auto/).

If you should desire to generate your own copy of the documentation, mind that
Auto uses [YARD](http://yardoc.org/). Obtain the 
[yard gem](https://rubygems.org/gems/yard) and the 
[redcarpet gem](https://rubygems.org/gems/redcarpet); then, run `yardoc` in the
main directory.

We advise you to consult with especial the {file:doc/Contributing.md Standards of Contributing}.

Events are documented in {file:doc/Events.md API Events}. See also the [Project](#Project)
section below.

Support
-------

If you should find yourself in need of support, please foremost consult with the
documentation on the [wiki](https://github.com/Auto/Auto/wiki).

If the wiki fails to address your needs, please either:

1. Ideally, use the [issue management hub](https://github.com/Auto/Auto/issues), **or**
2. Use the [official forums](http://rubyforge.org/forum/?group_id=10312), **or**
3. Join the _unofficial_ IRC chatroom at 
[##nox on irc.freenode.net](http://webchat.freenode.net/?randomnick=1&channels=##nox&prompt=1)

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
