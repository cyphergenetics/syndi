Syndi
=====

_A modern, elegant, extensible multi-protocol bot&mdash;reloaded._

**Formerly known as Auto.**

**Version**:            4.0.0.alpha.1 "Phoenix"  
[![Build Status](https://travis-ci.org/Syndi/Syndi.png?branch=master)](https://travis-ci.org/Syndi/Syndi)
[![Dependency Status](https://gemnasium.com/Syndi/Syndi.png)](https://gemnasium.com/Syndi/Syndi)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Syndi/Syndi)

+ [Homepage](http://syndiproj.org) (lots of information)
+ [Git](https://github.com/Syndi/Syndi)
+ [RubyGems](https://rubygems.org/gems/Syndi)
+ [Wiki](https://github.com/Syndi/Syndi/wiki)
+ [Mailing List](https://groups.google.com/group/syndibot-talk)
+ [Issue Hub](https://github.com/Syndi/Syndi/issues)

**Documentation** is available for the [latest git](http://rdoc.info/github/Syndi/Syndi),
and [this release](http://syndiproj.org/rdoc/4.0.0.alpha.1/).

Our official IRC channel is [#syndi on irc.freenode.net](irc://irc.freenode.net/#syndi).

### Is it Production-Ready&trade;?

Not yet. Syndi 4's a fairly sizable project.

Synopsis
--------

Syndi is automated chat bot software, developed per this philosophy:

* _Friendly_ to users, and to developers.
* _Simple_, _smart_, and _clean_.
* _Minimal_ but _extensible_.

Installation
------------

Please read the [Syndi Handbook](https://github.com/Syndi/Syndi/wiki/Handbook).

**Compiling from source:**

```shell
$ git clone git://github.com/Syndi/Syndi.git syndi
$ cd syndi/
```
Use a [specific version](https://github.com/Syndi/Syndi/tags):

```shell
$ git checkout v4.0.0.alpha.1
```

Or the cutting-edge HEAD:

```shell
$ git checkout master
```

```shell
$ bundle install
$ rake
$ rake install
```

Syndi is currently known to function on these operating systems:

+ Microsoft Windows
+ Mac OS X
+ Linux
+ BSD flavors

Using these Ruby virtual machines:

+ MRI/YARV (official) 2.0.0

Support
-------

If you should find yourself in need of support, please foremost consult with the
documentation on the [wiki](https://github.com/Syndi/Syndi/wiki).

If the wiki fails to address your needs, please either:

1. Post to the [syndibot-talk](https://groups.google.com/group/syndibot-talk)
   group under the _support_ category, **or**
2. Join the official IRC chatroom at 
[#syndi on irc.freenode.net](http://webchat.freenode.net/?randomnick=1&channels=#syndi&prompt=1)

**Bugs** should be reported on the [issue management hub](https://github.com/Syndi/Syndi/issues).

Authors
-------

Syndi 4 was rewritten from scratch by Autumn Perrault (noxgirl) in Ruby and C,
and is actively developed by the **Syndi Project**.

Legal
-----

Copyright (c) 2009-2013, Autumn Perrault, et al. All rights reserved.

Syndi is free, open-source software, distributed per the terms of the two-clause
("FreeBSD") license, the full terms of which are in **LICENSE**.
