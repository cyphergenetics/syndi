Syndi on Windows
===============

Yay
---

Syndi 4.0 _Phoenix_ brings back something which hasn't existed since version 1.0:
support for Microsoft Windows!

This is because we have prioritized programming v4.0 with platform independence
from its inception.

How It Works
------------

Windows users can install Syndi easily by downloading and installing from RubyGems:

    $ gem install Syndi [--pre]

On Windows, this will install the native Windows distribution, which includes the
_csyndi_ library cross-compiled with [Minimalist GNU for Windows](http://www.mingw.org/),
commonly called MinGW.

This assumes that you have installed Ruby compiled with MinGW; this is the case
if you used [RubyInstaller for Windows](http://rubyinstaller.org/).

Compiling
---------

Users who have good cause for doing so are also welcome to compile the source
for Syndi themselves.

We should hope that [DevKit](http://rubyinstaller.org/downloads) will provide
a sufficiently sane build environment for this on Windows. We haven't tested
it since we cross-compile on UNIX systems when packaging gems.

You must then force RubyGems to download the distribution without binaries, so
that _csyndi_ will be compiled:

    $ gem install Syndi [--pre] --platform=ruby --development

Cross-compiling
---------------

You must have a cross-compiling toolset installed on your system. Install the
MinGW toolset.

On Arch Linux, this can be installed with:

    # pacman -Syu mingw32-gcc mingw32-pthreads

Then configure rake-compiler:

    $ rake-compiler cross-ruby VERSION=1.9.3-p362

Now compile the source code for Windows:

    $ rake cross compile

Package the native distribution gem:

    $ rake cross native gem

_Et voila!_ You should find the native gem in `pkg/`.
