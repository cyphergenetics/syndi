How To Contribute
=================

1. Create a [GitHub account](https://github.com) if you've thus far neglected such.
2. Fork the [Syndi repository](https://github.com/Syndi/Syndi).
3. Make your changes.
4. Test with RSpec.
5. Document your changes.
6. Submit a [pull request](https://github.com/Syndi/Syndi/wiki).
7. They will be reviewed and either accepted or rejected, but in any event will receive
   a response.

Standards of Contributing
=========================

So that Syndi 4 may maintain consistency, usability, and functionality,
we ask that all contributions to Syndi 4 conform with a few standards and
conventions.

While this is solely a requirement for contributions to Syndi 4, we would
suggest following it whenever extending or modifying Syndi, whether your
intention is to ship your code upstream, release it independently, or
merely keep for your own personal use.

Moreover, to further the philosophy of free software, while we do not
demand it, we do ask that you publish code you write for Syndi.

**Documentation**

Syndi maintains thorough documentation. Please document your code employing rdoc
and YARD standards. 

When using the `@author` tag, please provide your GitHub
username at minimum.

**Coding**

For indentation, ensure that you use spaces in lieu of tabs. For Ruby code and
YAML, use two spaces. For C code, use four spaces.

Vim users, observe the modelines each source file contains:

    # vim: set ts=4 sts=2 sw=2 et:

and

    /* vim: set ts=4 sts=4 sw=4 et cindent: */

Ruby coders, largely keep your code in compliance with [this style guide](https://github.com/bbatsov/ruby-style-guide).

C coders, we prefer Allman (not K&R) style.

Oh, and UNIX line endings only. Put carriage returns in our code, we will kill
a kitten.

**Language**

In documentation, commit messages, and other such things, we require compliance
with these three rules:

1. No obscene language.
2. It must be legible.
3. It must be grammatically correct at least to a reasonable degree.

**Membership**

While we recognize and credit all individuals who contribute, no matter how
small their contribution, we are also willing to grant commit access and
official membership to regular contributors.

Please contact Autumn Perrault (also known as noxgirl) if you wish to become
a member of the Syndi Project:

+ By e-mail: autumn@destellae.net
+ By IRC: "autumn" on irc.freenode.net (usually in #syndi)

**Releasing**

For developers, to release a new version:

1. You should already have the latest bundle: `bundle install`
2. You must have installed MinGW. (Arch package is `mingw32-gcc`)
3. You must have configured your cross-compilation toolchain: `rake-compiler cross-ruby VERSION=2.0.0-rc2`
4. You must have commit bit on [syndi/syndibot.github.com](https://github.com/syndi/syndibot.github.com).
5. You must be listed as an owner on the [syndi gem](https://rubygems.org/gems/syndi).
6. This does not change codenames.
7. Run `rake release[VERSION]` (prepend `noglob` for Z shell), with VERSION being the version number (e.g. 0.5.0).
8. Post the provided link to the mailing list as an announcement.
