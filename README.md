Auto 4
======

_A modern, simple, extensible multi-protocol bot reloaded._

**Version**:            4.0.0.alpha.1 "Phoenix"  
[![Build Status](https://travis-ci.org/Auto/Auto.png?branch=master)](https://travis-ci.org/Auto/Auto)
[![Dependency Status](https://gemnasium.com/Auto/Auto.png)](https://gemnasium.com/Auto/Auto)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Auto/Auto)

+ [Homepage](http://autoproj.org) (lots of information)
+ [Git](https://github.com/Auto/Auto)
+ [RubyGems](https://rubygems.org/gems/Auto)
+ [Wiki](https://github.com/Auto/Auto/wiki)
+ [Mailing List](https://groups.google.com/group/autobot-talk)
+ [Issue Hub](https://github.com/Auto/Auto/issues)

**Documentation** is available for the [latest git](http://rdoc.info/github/Auto/Auto),
and [this release](http://autoproj.org/rdoc/4.0.0.alpha.1/).

Our official IRC channel is [#auto on irc.freenode.net](irc://irc.freenode.net/#auto).

Synopsis
--------

Auto is automated chat bot software, developed per this philosophy:

* _Friendly_ to users, and to developers.
* _Simple_, _smart_, and _clean_.
* _Minimal_ but _extensible_.

Installation
------------

Please read the [Auto Handbook](https://github.com/Auto/Auto/wiki/Handbook).

**Compiling from source:**

```shell
$ git clone git://github.com/Auto/Auto.git auto
$ cd auto/
```
Use a [specific version](https://github.com/Auto/Auto/tags):

```shell
$ git checkout v4.0.0.alpha.1
```

Or the cutting-edge HEAD:

```shell
$ git checkout master
```

```shell
$ bundle install
$ rake build
```

Auto is currently known to function on these operating systems:

+ Microsoft Windows
+ Mac OS X
+ Linux
+ BSD flavors

Using these Ruby virtual machines:

+ MRI/YARV (official) 2.0.0

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
and is actively developed by the **Auto Project**.

Legal
-----

Copyright (c) 2009-2013, Autumn Perrault, et al. All rights reserved.

Auto is free, open-source software, distributed per the terms of the two-clause
("FreeBSD") license, the full terms of which are in **LICENSE**.
