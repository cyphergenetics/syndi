Change Log
==========

v4.0.0 (unreleased)
-------------------

### alpha.2

_Changes_

- **Required Ruby version increased to 2.0.0.**
- Support for configuration by means of JSON has been terminated.
- Support for SQL has been dropped in favor of Redis.
- The Auto directory has been moved from `~/.config/autobot` to `~/.auto`.
- The #debug and #foreground methods have been removed from Auto::Bot in favor
  of #verbose.
- #verbose, #error, #warning, #info, and #fatal have been moved from Auto::Bot
  to Auto::Logger.
- #warning has been renamed to #warn.
- Formerly, you could pass a backtrace to #error, but we have instead introduced
  a new method, `#error_bt`, which takes two arguments--the message and backtrace.
- `$log` has been added as the Auto::Logger instance.
- Flatfile alternative to Redis added (via **filekv**).
- Rake task `build` added to compile, package, and install Auto, but not test it.

_Fixes_

- A bug which messed up STDOUT output in Microsoft Windows.
- A bug which caused DH-BLOWFISH SASL authentication to fail on x86 systems.
- A few libauto flaws which could've caused compilation to fail.
