To-do List
==========

- [ ] Fix the bugs in Syndi::Configure which cause syndi-conf to fail.
- [ ] Simplify Syndi::Configure with quid.
- [ ] We need a (nice) logo! Perhaps a red, gemstone-like theme. A current idea is a ruby atop a leaf.
- [ ] Syndi::IRC::Format, which should provide IRC coloring and extras in a pleasant, Rubyist way!
- [ ] Implement debugging verbosity. The global variable `$VERBOSITY` already exists, but isn't used.
- [ ] A better spec for Syndi::Logger--one which checks the logfile output.
- [ ] Syndi::Configure should use Psych for YAML processes.
- [ ] An Syndi::Configure::Manager to replace Syndi::Configure::Shell--should use the walnut gem.
- [ ] Finish removing usage of Syndi::Bot#debug and #foreground from codebase, in favor of new #verbose.
