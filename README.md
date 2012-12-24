Auto 4
======

by the Auto Project:

-   [noxgirl](https://github.com/noxgirl) \<xoeverlux@gmail.com\>
-   [swarley](https://github.com/swarley) \<matthew.b.carey@gmail.com\>
-   [mattwb65](https://github.com/mattwb65) \<mattwb65@gmail.com\>

Contributors to earlier versions:

-   Matthew Barksdale \<mattwb65@gmail.com\>
-   Russell Bradford \<russell@rbradford.me\>
-   Liam Smith \<me@liam.co\>
-   Alyx Wolcott \<contact@alyxw.me\>
-   Mitchell Cooper \<mitchell@notroll.net\>
-   Timothy Estes \<tim7967@gmail.com\>
-   Douglas Freed :[GitHub](https://github.com/dwfreed)
-   Eitan Adler :[GitHub](https://github.com/grimreaper)

Description
-----------

Auto 4 is a minimal and simple multi-protocol chat bot designed in the Ruby
programming language, with emphasis on IRC.

Auto was initially released in December of 2009, and has since undergone four
major revisions. The legacy line is the 3.x line, which is currently relatively
unmaintained, but is available at [Auto-legacy](https://github.com/Auto/Auto-legacy).

In December of 2012, noxgirl released this fourth major revision of Auto to the
public on Git. It is largely functional, but as it is being actively developed
in the core, it retains its status of 'unstable' for the time being and is not
yet ready to supersede Auto v3.

Come stability, Auto 4 will supersede Auto 3. The most notable change is in its
fundamental structure, which is much cleaner and simpler, and less esoteric.

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

Start Auto 4 by running `ruby auto.rb`.

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

License
-------

Auto 4 is free software distributed under the three-clause BSD license:

    Copyright (c) 2013, Auto Project
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted
    provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions
      and the following disclaimer.
    
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials provided
      with the distribution.
    
    * Neither the name of the Auto Project nor the names of its contributors may be used to endorse
      or promote products derived from this software without specific prior written permission.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
    CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
    OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.

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
