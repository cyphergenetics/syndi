*This is a copy of https://github.com/Auto/Auto/wiki/Install-Guide as it appeared Jan 13 2013 4:16 UTC.*

Thank you for choosing **Auto 4** to serve your needs! Please foremost read the [licensing terms](/Auto/Auto/wiki/License), as *by proceeding you confirm your agreement to them*.

Before installing, you must decide on how you would like to install Auto. There is a relatively easy way, and a somewhat more advanced way.

For most users, the relatively easy way is advisable, and that is the **gem method**.

Users who have some reason for doing so and are more advanced can install Auto from source. See further below for that.

---

# Gem

You must have [Ruby 1.9.2 or later](http://www.ruby-lang.org).

## Installation

There is a complete list of releases and links therefor on the [official releases page](http://auto.autoproj.org/releases.html).

We recommend merely installing the latest (pre-)release from [RubyGems](https://rubygems.org/gems/Auto):

    $ gem install Auto --pre

If you downloaded the source, either from Git or in an archive, do this in the main directory to compile a gem:

    $ gem build Auto.gemspec
    $ gem install Auto-*.gem

Depending on which database management system you wish to use, you must separately download the respective gem whether you use the distributed **Auto** or your own build:

**SQLite**: `$ gem install sqlite3`  
**MySQL**: `$ gem install mysqlplus`  
**PostgreSQL**: `$ gem install pg`

## Configuration

The indispensable [Auto Configure](/Auto/Auto/wiki/Auto-Configure) utility will help you configure Auto, and this is the suggested method as it is the easiest.

    $ auto-conf

Otherwise you must navigate to the path to which **autobot** was installed (typically somewhere in `~/.gem/`) and find the `conf/` directory; that is unless you cloned from Git, in which case you'll find it in `Auto/conf/`.

The **Y**AML **A**in't **M**arkup **L**anguage configuration, which is suggested, is `example.yml`. Open it with your favorite editor and save it as `~/.config/autobot/auto.yml`. You can also save it to a path of your choosing, but remember to invoke Auto with `--config=path/to/config.yml`:

    $ auto --config=/somewhere/where/cows/speak/auto.yml

If you prefer, the **J**ava **S**cript **O**bject **N**otation configuration is `example.json`. Modify it as above (except use a `.json` extension). Invoke Auto with the `-j` flag (unless you specify `--config`, in which case the `--j` is superfluous).

    $ auto -j

## Start

    $ auto

Consult with the [Auto Handbook](/Auto/Auto/wiki/Auto-Handbook) for information on using Auto.

# Source

You need at least [Ruby 1.9.2](http://www.ruby-lang.org)!

The easiest way to install Auto's gem prerequisites is to use [**GemBundler**](https://rubygems.org/gems/bundler). Install it:

    $ gem install bundler

After downloading the source code and entering the main directory, invoke bundler:

    $ bundle install --without dev

If testing and/or development are among your intentions, exclude the `--without dev` to install testing/development dependencies.

Depending on which database management system you wish to use, you must separately download the respective gem:

**SQLite**: `$ gem install sqlite3`  
**MySQL**: `$ gem install mysqlplus`  
**PostgreSQL**: `$ gem install pg`

All releases can be obtained in either Git, Tar/GZ, or Zip format from the [official releases page](http://auto.autoproj.org/releases.html).

Compile the source code:

    $ rake compile

To test Auto (and you must have installed the testing dependencies), invoke:

    $ rake test
