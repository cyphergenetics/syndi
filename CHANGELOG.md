Change Log
==========

v4.0.0 (unreleased)
-------------------

### alpha.2

_Changes_

- Support for configuration by means of JSON has been terminated.
- Support for SQL has been dropped in favor of Redis.
- The Auto directory has been moved from `~/.config/autobot` to `~/.auto`.
- The #debug and #foreground methods have been removed from Auto::Bot in favor
  of #verbose.

_Fixes_

- A bug which messed up STDOUT output in Microsoft Windows.
- A bug which caused DH-BLOWFISH SASL authentication to fail on x86 systems.
- A few libauto flaws which could've caused compilation to fail.
