*This is a copy of https://github.com/Syndi/Syndi/wiki/Install-Guide as it appeared Jan 13 2013 4:16 UTC.*

Thank you for choosing **Syndi 4** to serve your needs! Please foremost read the [licensing terms](/Syndi/Syndi/wiki/License), as *by proceeding you confirm your agreement to them*.

Before installing, you must decide on how you would like to install Syndi. There is a relatively easy way, and a somewhat more advanced way.

For most users, the relatively easy way is advisable, and that is the **gem method**.

Users who have some reason for doing so and are more advanced can install Syndi from source. See further below for that.

---

# Gem

You must have [Ruby 1.9.2 or later](http://www.ruby-lang.org).

## Installation

There is a complete list of releases and links therefor on the [official releases page](http://syndi.syndiproj.org/releases.html).

We recommend merely installing the latest (pre-)release from [RubyGems](https://rubygems.org/gems/Syndi):

    $ gem install Syndi --pre

If you downloaded the source, either from Git or in an archive, do this in the main directory to compile a gem:

    $ gem build Syndi.gemspec
    $ gem install Syndi-*.gem

Depending on which database management system you wish to use, you must separately download the respective gem whether you use the distributed **Syndi** or your own build:

**SQLite**: `$ gem install sqlite3`  
**MySQL**: `$ gem install mysqlplus`  
**PostgreSQL**: `$ gem install pg`

## Configuration

The indispensable [Syndi Configure](/Syndi/Syndi/wiki/Syndi-Configure) utility will help you configure Syndi, and this is the suggested method as it is the easiest.

    $ syndi-conf

Otherwise you must navigate to the path to which **syndibot** was installed (typically somewhere in `~/.gem/`) and find the `conf/` directory; that is unless you cloned from Git, in which case you'll find it in `Syndi/conf/`.

The **Y**AML **A**in't **M**arkup **L**anguage configuration, which is suggested, is `example.yml`. Open it with your favorite editor and save it as `~/.config/syndibot/syndi.yml`. You can also save it to a path of your choosing, but remember to invoke Syndi with `--config=path/to/config.yml`:

    $ syndi --config=/somewhere/where/cows/speak/syndi.yml

If you prefer, the **J**ava **S**cript **O**bject **N**otation configuration is `example.json`. Modify it as above (except use a `.json` extension). Invoke Syndi with the `-j` flag (unless you specify `--config`, in which case the `--j` is superfluous).

    $ syndi -j

## Start

    $ syndi

Consult with the [Syndi Handbook](/Syndi/Syndi/wiki/Syndi-Handbook) for information on using Syndi.

# Source

You need at least [Ruby 1.9.2](http://www.ruby-lang.org)!

The easiest way to install Syndi's gem prerequisites is to use [**GemBundler**](https://rubygems.org/gems/bundler). Install it:

    $ gem install bundler

After downloading the source code and entering the main directory, invoke bundler:

    $ bundle install --without dev

If testing and/or development are among your intentions, exclude the `--without dev` to install testing/development dependencies.

Depending on which database management system you wish to use, you must separately download the respective gem:

**SQLite**: `$ gem install sqlite3`  
**MySQL**: `$ gem install mysqlplus`  
**PostgreSQL**: `$ gem install pg`

All releases can be obtained in either Git, Tar/GZ, or Zip format from the [official releases page](http://syndi.syndiproj.org/releases.html).

Compile the source code:

    $ rake compile

To test Syndi (and you must have installed the testing dependencies), invoke:

    $ rake test
