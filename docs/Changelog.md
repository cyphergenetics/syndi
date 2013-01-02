Change Log
==========

Developers, this is produced employing thus:
    
    $ git log <starting hash>..<ending hash> --no-merges --pretty=format:"[%h] %cn \<%ce\>  %nDate: %cd  %n_%s_%n"

4.0.0.a.0.1 [pre-alpha 1]
-------------------------

[9eb21fe] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 18:25:53 2013 -0700  
_Purge the very outdated to-do._

[4c9e890] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 18:23:18 2013 -0700  
_Okay, fixed versioning._

[9e1cdb0] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:22:22 2013 -0500  
_Changing some things in auto/config.rb to use a rescue block scope instead of an individual begin rescue end._

[9b46395] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 18:13:09 2013 -0700  
_Bumping version to prealpha 1_

[777bcaa] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:10:00 2013 -0500  
_Silly typo in install_

[9988c5a] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:08:30 2013 -0500  
_Updating names of required tasks_

[3e28a14] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:05:16 2013 -0500  
_Oops, sorry babe. I messed up your naming._

[c7b3331] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:03:18 2013 -0500  
_Changing the Rakefile a little more and adding desc lines to allow rake -T to give some obvious information._

[4242a84] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 20:02:07 2013 -0500  
_Changing the Rakefile a little more and adding desc lines to allow rake -T to give some obvious information._

[deea55e] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 18:00:31 2013 -0700  
_Fixed gemspec and added rake task 'gem' per my loveybear's suggestion._

[237d355] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 17:34:58 2013 -0700  
_Updated example YAML configuration. Todo: JSON._

[da5d1cc] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 19:31:53 2013 -0500  
_Adding some changes to bin/auto-conf to make it a little more comprehensive_

[c51a30a] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 16:34:24 2013 -0700  
_Fixing the launcher executable._

[b5722b1] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 16:19:10 2013 -0700  
_Added Auto::CODENAME._

[08c71c8] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 16:08:56 2013 -0700  
_Auto::Bot fixed, sort of._

[40cee35] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 15:17:57 2013 -0700  
_New example configuration files._

[26482f9] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 15:10:18 2013 -0700  
_Changed the 'modules' directive to the 'libraries' directive. Also, the current structure of the IRC framework and the means by which we load it is horrendous. This will be fixed._

[b6d1601] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 14:37:59 2013 -0700  
_In theory, the database should connect._

[835da40] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 14:10:11 2013 -0700  
_TIL gem doesn't support require_relative_

[85893f7] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 13:52:16 2013 -0700  
_This is kind of uh, needed._

[5bd5c3f] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 13:51:49 2013 -0700  
_Fixing documentation._

[2c4678a] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 13:45:47 2013 -0700  
_Fine you win._

[b59ef2d] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Tue Jan 1 15:45:45 2013 -0500  
_Fixing an issue in auto-conf caused by lazy typing habits._

[7d8d0f7] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 13:41:29 2013 -0700  
_Fixing files._

[684b372] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 13:21:18 2013 -0700  
_A more sensible gemspec._

[6abff07] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 12:52:35 2013 -0700  
_Moving Auto::Auto to Auto::Bot and tossing in more of this incomplete code..._

[dbdaef5] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:56:33 2013 -0700  
_Ignore *.gem._

[02b0aca] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:55:43 2013 -0700  
_Here's a base gemspec._

[1d9dfdc] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:52:55 2013 -0700  
_Apparently we must settle for MRI 1.9.2._

[11ccee8] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:52:25 2013 -0700  
_A bit of cleaning and changed rehash from SIGUSR1 to SIGHUP._

[888a74e] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:31:43 2013 -0700  
_Added the missing shebang here to bin/auto-conf._

[c67d4bc] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:24:02 2013 -0700  
_confgen.rb -> bin/auto-conf_

[659b9a8] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:23:06 2013 -0700  
_auto.rb -> bin/auto_

[d728f46] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:22:33 2013 -0700  
_Note licensing change._

[cd35c7d] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 04:17:56 2013 -0700  
_Test for MRI 1.9.1 also._

[8df82ee] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Jan 1 00:05:30 2013 -0700  
_Happy 2013_

[ba76552] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 22:47:31 2012 -0700  
_Somehow these escaped my git add._

[fb633fb] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 22:40:05 2012 -0700  
_Updated YARD options._

[426a7eb] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 22:37:14 2012 -0700  
_Auto::IRC::Std::Numerics: added basic RFC2812 numerics, with the exception that 005 is RPL_ISUPPORT and 010 is RPL_BOUNCE._

[0e80966] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 22:30:39 2012 -0700  
_Purge this..._

[292ce24] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 22:27:25 2012 -0700  
_A module of IRC numerics per the RFC1459 and IRCv3.1 specifications._

[02a8978] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:34:17 2012 -0700  
_And that should do it_

[64bb013] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:33:28 2012 -0700  
_Update the mocks also_

[568748b] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:32:18 2012 -0700  
_This didn't even have the notice, or the modeline..._

[1fdc070] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:31:21 2012 -0700  
_And here_

[a81ea72] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:29:50 2012 -0700  
_Reflect licensing change_

[02c7ef1] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:09:25 2012 -0700  
_Fix indentation_

[a84fd82] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 10:07:58 2012 -0700  
_We're changing from the three-clause BSD to the FreeBSD license._

[678718c] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 08:50:05 2012 -0700  
_Added DatabaseError exception._

[0ee36a4] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 08:28:50 2012 -0700  
_Auto::API to simplify the API._

[7883ec7] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:54:15 2012 -0700  
_And next is Auto::Auto..._

[f3aa741] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:24:04 2012 -0700  
_Updated docs._

[5081fc6] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:21:31 2012 -0700  
_Updated docs._

[2fca87a] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:20:57 2012 -0700  
_Added Auto::API::Helper::Timers._

[64942f1] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:16:34 2012 -0700  
_Purge the old API:: namespace, which is rubbish._

[5258122] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:15:46 2012 -0700  
_Um, this will output 'cow' not 'animal.'_

[4c60592] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:13:38 2012 -0700  
_timers_spec: fixed a few issues. Added Auto::API::Timers, the new timers system._

[14fe703] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:03:20 2012 -0700  
_-.-_

[1ac99ff] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 07:02:50 2012 -0700  
_Populated the specifications._

[47f829c] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 06:57:05 2012 -0700  
_We need a new instance of Auto::API::Timers with which to work._

[38b993e] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 06:55:41 2012 -0700  
_...err..._

[9ba21ff] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 06:54:28 2012 -0700  
_More code for the timers_spec_

[2f60fb3] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 05:14:21 2012 -0700  
_Begin timers_spec_

[bef9c5d] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 00:49:18 2012 -0700  
_Make this a subclass of Auto::API::Object._

[038f772] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 31 00:47:38 2012 -0700  
_Auto::API::Object, created to eliminate repetition._

[37b0998] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 21:57:19 2012 -0700  
_Updated YARD options._

[8508cee] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 21:56:04 2012 -0700  
_Added Auto::API::Helper::Events._

[7487c23] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 21:20:12 2012 -0700  
_Renamed #tidy! to #tidy_

[362404e] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 21:09:01 2012 -0700  
_Added Connor Y. to past contributors_

[a7d8016] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:47:32 2012 -0700  
_Auto::API::Events: Implemented hook execution prevention._

[408329d] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:43:27 2012 -0700  
_event_spec: Test blocking ability._

[f031015] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:36:52 2012 -0700  
_Report this as debug data._

[c87a8f0] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:31:07 2012 -0700  
_Add a link here._

[1c0248b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:28:35 2012 -0700  
_These are in the Auto:: namespace._

[4ff4910] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:24:54 2012 -0700  
_Make YARD document the new stuff in lieu of the old stuff._

[44236d5] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:22:43 2012 -0700  
_Document the public readonly ::threads attribute._

[8297dfb] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 19:20:17 2012 -0700  
_Changed the spec to demand a sensible events model which also reconciles priority and non-blocking multithreading. Auto::API::Events changed to support this model._

[7ae6e0f] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 21:11:55 2012 -0500  
_Using test group to allow travis to still work_

[e731187] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 21:09:54 2012 -0500  
_Making sure I don't break travis_

[2351d6e] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 21:06:08 2012 -0500  
_Removing message and creating groups inside of the Gemfile to keep bacon from being required in a distribution install._

[a14efa5] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 21:01:05 2012 -0500  
_Adding a message for if users do not have highline._

[9098e68] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 20:51:05 2012 -0500  
_Rewrite of confgen.rb_

[de114a4] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 16:14:48 2012 -0700  
_We now have an official IRC channel: #auto on irc.freenode.net._

[9f3bdc9] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 15:44:10 2012 -0700  
_Call String#uc not String#us_

[ff9152f] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 30 17:42:38 2012 -0500  
_Changing some things around at the request of Autumn._

[44e41cf] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 04:15:14 2012 -0700  
_Timers are next._

[ef9097d] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 04:05:06 2012 -0700  
_Added rake to dependencies..._

[1ddb035] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 03:57:26 2012 -0700  
_Presenting the new, fancier Auto::API::Events, now with threading._

[736b421] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 30 03:00:03 2012 -0700  
_Recording the caller object is superfluous._

[7cf4ad6] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 29 20:49:01 2012 -0700  
_Add the template disclaimer+modeline_

[b27d81e] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sat Dec 29 22:39:52 2012 -0500  
_Terrible base for confgen.rb I'll need to rewrite it to make it less offensive to any programmer._

[844dde2] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 29 19:57:28 2012 -0700  
_Add colored to deps_

[4b0f5d9] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 29 18:29:15 2012 -0700  
_Document protected and private methods._

[2dd97d1] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 29 14:28:38 2012 -0700  
_events_spec: Updated for new Auto::API::Events model_

[d57efe8] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 29 12:52:15 2012 -0700  
_Change our dependencies to bacon and sequel._

[dc35b15] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 28 08:19:52 2012 -0700  
_...compact this link sensibly..._

[0697867] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 28 07:49:27 2012 -0700  
_Updates. Note autobot-talk_

[c11a56a] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 28 03:08:48 2012 -0700  
_The DNS has successfully propagated, so point homepage to http://auto.autoproj.org._

[8e73b45] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 28 01:39:37 2012 -0700  
_Unfinished Auto::API::Events_

[cbcccb3] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 23:03:33 2012 -0700  
_Added Gemnasium, because why not_

[f8a761c] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 22:53:13 2012 -0700  
_Specify our active developers._

[62a7990] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 20:12:17 2012 -0700  
_Note the build page._

[9d287b2] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 20:10:49 2012 -0700  
_Added a build status image._

[21a718c] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 20:04:31 2012 -0700  
_Configuration for Travis CI_

[b63b1b4] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 19:57:12 2012 -0700  
_events_spec: tests for Auto::API::Events; current result: 3 success, 1 fail_

[ecdf735] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 19:22:22 2012 -0700  
_Simplify the synopsis._

[5979a7e] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 19:01:04 2012 -0700  
_The address is not as useful as a place where users may subscribe._

[b3a4e15] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 18:56:20 2012 -0700  
_More links._

[f4ae05d] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 18:45:13 2012 -0700  
_Works this time_

[046283f] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 18:42:23 2012 -0700  
_Fix formatting_

[32d8907] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 18:40:57 2012 -0700  
_Include LICENSE.md in YARD processing._

[f109cae] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 18:39:41 2012 -0700  
_Doc updates. Auto 4.0 is now codenamed 'Phoenix,' because it represents the death and rebirth of Auto into a superior version._

[35edc13] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 17:25:17 2012 -0700  
_Consistency: -x_

[c51d2af] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 17:24:45 2012 -0700  
_Start Auto::API::Events; among the changes at this moment is a removal of access to the events instance variable, because nobody should be accessing the events list directly._

[c7ddb8c] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 12:15:17 2012 -0700  
_#initialize using a 'method' variable could cause conflicts; changed to 'meth' both because it is unused and because it is something about which Alyx can make jokes._

[9fe778a] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 12:10:16 2012 -0700  
_All core/ libraries have been removed in favor of superior libraries under the Auto namespace._

[3d9b00b] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 12:07:32 2012 -0700  
_Core::Logging is deprecated in favor of Auto::Logger._

[cda22d4] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 12:07:02 2012 -0700  
_Auto::Logger, which supersedes Core::Logging. I don't think it needs to be tested since it performs very little._

[409b2e4] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 11:58:13 2012 -0700  
_Added exception LogError_

[c309672] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 11:27:35 2012 -0700  
_Updated --version/-v._

[a69464c] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 11:15:49 2012 -0700  
_Actually, this directive is useless if an exception is raised for it not being recognized before its state of non-existence._

[23d117b] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 11:09:07 2012 -0700  
_config_other_spec: additional tests of Auto::Config (which succeed)_

[5943996] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 05:11:36 2012 -0700  
_Ensure cleanup_

[b5e8b80] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 05:07:48 2012 -0700  
_config_(yaml,json)_spec: specifications now in order and all tests succeed_

[8dac0ef] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 04:53:07 2012 -0700  
_Consider data to be rubbish if it's not of class Hash._

[2ebdbbe] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 04:35:33 2012 -0700  
_should.be.same_as is more sensible in these cases than should.equal_

[ee884bb] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 04:29:43 2012 -0700  
_Oh oops, this spec needs to call #rehash! to test properly_

[1333df1] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 04:27:13 2012 -0700  
_config_yaml_spec improved_

[5638f3d] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 03:50:34 2012 -0700  
_Why is this return statement here? The ConfigError exception suffices._

[edaee09] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 03:05:43 2012 -0700  
_Strip the @markup tags since YARD should automatically detect by the .md extension that these are Markdown._

[b1fa0d2] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 03:03:10 2012 -0700  
_Make the .gitignore better_

[cd7c916] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:54:19 2012 -0700  
_config_json_spec for JSON configurations_

[c3eabf2] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:44:47 2012 -0700  
_Added Auto::Config#[] which passed the tests_

[99c53e0] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:41:49 2012 -0700  
_Add a directive to config_yaml_spec for #[]_

[84648e3] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:37:12 2012 -0700  
_Err, an integer is better than a boolean_

[15e14cd] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:35:13 2012 -0700  
_Presumably this spec, config_yaml_spec, is done_

[18a5c7a] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:21:23 2012 -0700  
_Use the damn fakes_

[87d7d78] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:17:07 2012 -0700  
_Use the fake_

[0b49458] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:14:48 2012 -0700  
_Superfluous require of auto/api since auto/auto uses it_

[b0955b0] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:13:27 2012 -0700  
_fake Spec::Auto_

[13047cf] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:12:51 2012 -0700  
_Test suite should use spec/test_helpers_

[ebdc548] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:11:40 2012 -0700  
_mock @events in Spec::Auto::Auto_

[a25f604] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:10:09 2012 -0700  
_fake Spec::Auto::API_

[114b855] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 02:09:51 2012 -0700  
_fake Spec::Auto::API::Events_

[83f4924] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 01:54:30 2012 -0700  
_Added Clay Freeman to earlier contributors_

[63f3f52] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 01:10:35 2012 -0700  
_spec/test_helpers_

[bb56531] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 00:55:40 2012 -0700  
_More garbage_

[d435779] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 00:53:43 2012 -0700  
_Ugh._

[96f7026] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 00:51:21 2012 -0700  
_core/config is garbage_

[3f1f2b7] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 00:49:12 2012 -0700  
_A few base files_

[5869af7] noxgirl \<xoeverlux@gmail.com\>  
Date: Thu Dec 27 00:37:07 2012 -0700  
_A marvelous template for Ruby files which includes the copyright and vim modeline_

[c59b7a8] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 20:56:34 2012 -0700  
_YAML uses keys of String not Symbol_

[1bffc90] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 20:52:43 2012 -0700  
_Updates to Auto::Config; however, config_yaml_spec continues to fail_

[3308c9b] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 20:51:17 2012 -0700  
_Exceptions_

[0914df7] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 20:36:51 2012 -0700  
_Here's an updated spec_

[cd4ccf3] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 20:02:51 2012 -0700  
_I love octothorpes because my loveybear does_

[45c69fc] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:28:57 2012 -0700  
_ok we need verbosity_

[bf1e2e0] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:28:13 2012 -0700  
_Oops_

[b499ed6] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:27:17 2012 -0700  
_My bad_

[52d6c13] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:24:34 2012 -0700  
_Auto::Auto -> Spec::Auto::Auto_

[a6d5e2d] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:22:44 2012 -0700  
_fake Auto::Auto_

[0b11419] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:20:07 2012 -0700  
_Make this more sensible._

[335e9cc] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Wed Dec 26 21:09:08 2012 -0500  
_Fixing syntax error in spec. Tests still fail._

[72c234f] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 19:05:35 2012 -0700  
_I don't know what to do with this; I'm tired_

[e0a386c] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Wed Dec 26 21:02:55 2012 -0500  
_Adding Gemfile.lock to the .gitignore_

[95fb043] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:45:52 2012 -0700  
_Dammit Autumn, you moron._

[b35c33d] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:28:14 2012 -0700  
_yay I love you loveybear_

[10cfcf8] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:26:57 2012 -0700  
_ok_

[eee1661] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:24:49 2012 -0700  
_Note rake usage_

[9729583] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Wed Dec 26 20:24:20 2012 -0500  
_Adding a Gemfile to build upon as we continue._

[adeb933] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:22:52 2012 -0700  
_No verbose_

[5ea5e51] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:18:12 2012 -0700  
_Directives for Ruby Make (rake)_

[53794e5] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 18:10:06 2012 -0700  
_unshift() the lib/ path into $: so require()'s can be more sensible._

[145cae6] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 12:39:33 2012 -0700  
_Although IRC::Std will be soon deprecated, let us fix the CTCP VERSION._

[d29843a] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 12:27:37 2012 -0700  
_A bit of tidying._

[dae160e] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 26 04:02:58 2012 -0700  
_Port the fancy git-revision constant from 3 into 4; constant is REVISION._

[1ac4dcd] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 24 12:10:19 2012 -0700  
_auto/rubyext/string supersedes ruby_core_ext_

[56591db] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 24 12:09:12 2012 -0700  
_Auto::Rubyext::String which modifies String of the stdlib_

[8956aed] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 24 06:43:44 2012 -0700  
_Reflect the move from noxgirl/Auto to Auto/Auto._

[79fc2bf] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 24 04:46:15 2012 -0700  
_Reflect the legacy change._

[d1f2f6a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 22:50:45 2012 -0700  
_File#extname is more sensible._

[2e8c41e] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 22:27:52 2012 -0700  
_Use a tilde for nil values._

[621c8a9] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 22:25:55 2012 -0700  
_I see not a need for this. The single quotes are sufficient._

[2ae5aee] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 19:33:13 2012 -0700  
_ok_

[4cb57a1] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 18:36:39 2012 -0700  
_Update._

[2507c42] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:52:03 2012 -0700  
_Use Auto::Config. Provide -j/--json switch._

[a46525a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:45:51 2012 -0700  
_Formatting issue._

[9ef4914] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:44:56 2012 -0700  
_YAML is the configuration type of choice._

[84a7f5f] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:38:03 2012 -0700  
_Ignore auto.yml_

[d6ccdbb] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:34:37 2012 -0700  
_Example YAML config_

[328182a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 15:22:22 2012 -0700  
_output not new. I'm dumb_

[28162bb] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 23 17:19:38 2012 -0500  
_Changed the regular expression for eliminating comments. Also changed the JSON parse method call. <3 autumn_

[b5e5efb] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 23 17:13:48 2012 -0500  
_Changed the loading process of the IRC module to make it more visually appealing._

[c6d0794] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 14:54:21 2012 -0700  
_yaml_json.rb: Convert files between YAML/JSON._

[81aeda2] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 14:23:45 2012 -0700  
_Update_

[163a9a5] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 14:20:14 2012 -0700  
_Auto::Config and bot:onRehash. Auto::Config supersedes Core::Config, and supports both YAML and JSON. <3 swarley_

[a00998b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 23 00:35:33 2012 -0700  
_Completed IRC::Server#new_user and added event irc:introduceUser._

[4f56e12] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Sun Dec 23 01:03:16 2012 -0500  
_Changing mixin methods in API::Resource::EventsWrapper_

[4ceef2d] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 22:51:37 2012 -0700  
_Apparently I neglected to update IRC::Commands._

[19d272d] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 20:49:19 2012 -0700  
_Ah, yes. This can't use a mixin._

[55f9ce9] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 20:22:34 2012 -0700  
_Import the API::Resource::EventsWrapper library._

[058d346] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 20:22:10 2012 -0700  
_Use the DSL methods provided by API::Resource::EventsWrapper._

[3710db7] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 20:15:44 2012 -0700  
_Add some useful #inspect methods to IRC::Server and IRC::Object::User, per the adorable swarley's suggestion._

[589b2e8] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 18:32:14 2012 -0700  
_Added API::Resource::EventsWrapper, a DSL-type wrapper of API::Events._

[b5ceefc] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 12:40:19 2012 -0700  
_todo on IRC::Server#bind_default_handlers_

[2a56d0a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 12:37:01 2012 -0700  
_Improvements in YARD._

[ca3df0b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 12:35:30 2012 -0700  
_IRC::Server: Mostly finished YARD. #new_user is incomplete; #part, #msg, #notice, #who are deprecated. New #who requests a /WHO of the bot. Events: irc:onDisconnect, irc:onPreJoin, irc:onJoin, irc:WhoSelf._

[05e6f39] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 11:38:12 2012 -0700  
_Add plugins section._

[9a7d48e] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 09:48:17 2012 -0700  
_Ohloh, you have deceived me. N. Ridley, as mattwb65 kindly informs me, was an alias of A. Wolcott._

[fed6129] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 09:38:39 2012 -0700  
_Recognize the contributions of M. Cooper, T. Estes, D. Freed, E. Adler, and N. Ridley._

[4908e30] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 08:06:32 2012 -0700  
_More YARD for IRC::Server, and created #nickname=; also, created irc:onPreNick and irc:onNick._

[a54ec82] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 07:15:56 2012 -0700  
_IRC::Server: Close unfinished #new_user so IRC::Server stops throwing syntax errors._

[94e2440] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 07:15:00 2012 -0700  
_IRC::Object::Channel's skeleton._

[7b1b402] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 07:07:48 2012 -0700  
_Fix a formatting error._

[43f7545] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 07:06:05 2012 -0700  
_IRC::Server#msg and #notice are deprecated._

[f587e7b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 05:34:19 2012 -0700  
_Shorter is better._

[b686fa5] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 05:32:27 2012 -0700  
_IRC::Object::User: Reflect new API model._

[d662cc6] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 04:21:23 2012 -0700  
_Renamed irc:onSelf* to irc:on*User/Chan; added IRC::Object::User#notice and #who, and irc:onNoticeUser, irc:onPreNoticeUser, irc:onWhoUser._

[8d36b62] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 04:12:35 2012 -0700  
_Another._

[bcc7d41] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 04:11:57 2012 -0700  
_Formatting issue._

[82367fd] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 04:10:54 2012 -0700  
_Document irc:onSelfMsg and irc:onSelfPreMsg._

[d1c8b57] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 04:00:22 2012 -0700  
_Improvements to and YARD for API::Plugin._

[b9a5846] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 03:27:33 2012 -0700  
_Garbage._

[f70c56c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 03:27:15 2012 -0700  
_Documentation provisions._

[9509c9b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 02:44:05 2012 -0700  
_Revert "Move these files to docfiles/."_

[b9f5bc1] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 02:40:33 2012 -0700  
_Move these files to docfiles/._

[ecbd650] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 22 02:34:24 2012 -0700  
_Add doc/* and .yardoc to .gitignore._

[62243d7] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 21:42:00 2012 -0700  
_+x_

[1398c45] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 21:41:28 2012 -0700  
_Optimizations of IRC::Object::User; docs for that and IRC::Object::Message._

[13b466d] Matthew Carey \<matthew.b.carey@gmail.com\>  
Date: Fri Dec 21 22:32:53 2012 -0500  
_Changed lib/irc/server.rb to extremely optimize the process of receiving text_

[0f554d0] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 20:17:55 2012 -0700  
_Use this in lieu of the wiki._

[7d225dc] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 19:53:18 2012 -0700  
_Note._

[807fc84] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 19:51:33 2012 -0700  
_Standards and conventions of contributing._

[87eb580] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 18:58:48 2012 -0700  
_Ahoy. Welcome aboard the SS Auto 4, mattwb65 and swarley!_

[14dffc2] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:45:52 2012 -0700  
_Remove these: they're for development only._

[ddef8ba] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:43:30 2012 -0700  
_Forgot this._

[23e5a1e] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:42:05 2012 -0700  
_Add YARD note._

[ae977f8] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:37:38 2012 -0700  
_Add .yardopts for generation of documentation using YARD. This begins a rewrite of the code to use YARD._

[9d4bbb1] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:36:28 2012 -0700  
_Fixes._

[3104de5] noxgirl \<xoeverlux@gmail.com\>  
Date: Fri Dec 21 17:11:03 2012 -0700  
_Unfinished IRC::Object::Message. Oddly, this first nicely documented library is the only one YARD ignores._

[9202e8e] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 19 18:50:50 2012 -0700  
_Added IRC::Object::User._

[1102d9e] noxgirl \<xoeverlux@gmail.com\>  
Date: Wed Dec 19 18:07:16 2012 -0700  
_Rename @sockets and @cmd to @irc_sockets and @irc_cmd respectively, to respect that Auto's IRC functions are modular and thus Auto is a multi-protocol bot._

[1f182e2] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 11:25:46 2012 -0700  
_deinitialize is preferable_

[a72381a] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 10:47:26 2012 -0700  
_Note_

[2f75975] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 10:43:17 2012 -0700  
_This breaks compatibility with Windows._

[7719daa] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 10:17:03 2012 -0700  
_'Past' contributors can misconvey that they're contributors to Auto 4, whereas this is not quite accurate._

[aa9f30b] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 04:15:29 2012 -0700  
_IRC::Commands: Added new_cmd() and del_cmd(), and a few private methods. Started initialize()_

[8ae02a9] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 03:08:20 2012 -0700  
_Core::Config: STABLE._

[2c42caa] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 03:02:43 2012 -0700  
_Cleaning up the libraries and starting IRC::Commands._

[74deb0f] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:49:28 2012 -0700  
_Ignore any databases._

[9122a41] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:48:44 2012 -0700  
_Bam. SQLite database added as Auto.db._

[71bdfb7] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:41:56 2012 -0700  
_More palatable._

[6414706] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:40:47 2012 -0700  
_Note future sqlite3 requirement._

[4715368] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:23:04 2012 -0700  
_Another note._

[2d725fa] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:19:57 2012 -0700  
_Link to to-do list._

[a271483] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:18:53 2012 -0700  
_Remove this space._

[0545555] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:17:36 2012 -0700  
_Added 'Project' section_

[4e896cf] noxgirl \<xoeverlux@gmail.com\>  
Date: Tue Dec 18 01:08:49 2012 -0700  
_I suck at JSON._

[8ad24c6] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 23:33:34 2012 -0700  
_Adding +x._

[a0ad63a] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 23:32:41 2012 -0700  
_OK, I think this is effectively useless._

[d27395a] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 22:27:33 2012 -0700  
_Added 'conf/auto.json' to .gitignore._

[e5b50cb] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 22:22:45 2012 -0700  
_Changed IRC::Server.nick() to .chgnick() to prevent a conflict arising of @nick and nick() sharing the same external name._

[ea6c56b] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 22:21:51 2012 -0700  
_Added PRIVMSG parsing and irc:onRecvPrivMsg/irc:onRecvChanMsg; added CTCP VERSION reply._

[d53128e] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 21:35:42 2012 -0700  
_Added RPL_WHOREPLY handler; added irc:onWhoReply; added parsing for our own WHO data._

[c78b024] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 19:26:32 2012 -0700  
_In theory, Auto 4 now supports plugins, so the 'plugins' directive should be specified in example.json._

[8d1adc2] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 19:16:42 2012 -0700  
_Fixed Auto.terminate() and added bot:onTerminate_

[713f15b] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 19:14:04 2012 -0700  
_Catch SIGINT & SIGUSR1_

[4b1bd1c] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 19:10:33 2012 -0700  
_Change IRC::Server.quit() to .disconnect() as originally intended_

[9a0e793] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 19:06:38 2012 -0700  
_Changed irc.nickname conf directive from string into array; added support for alternate nicks._

[56f2a7e] noxgirl \<xoeverlux@gmail.com\>  
Date: Mon Dec 17 18:38:56 2012 -0700  
_Change versioning to match v3: -dev -> d_

[b267e05] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 16:12:28 2012 -0700  
_Fixed a possible bug._

[46ddb33] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 16:08:40 2012 -0700  
_Oops_

[b726ee7] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 15:55:28 2012 -0700  
_Don't offer this_

[479edbe] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 13:44:49 2012 -0700  
_emphasize 'active'_

[4f80d18] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 13:43:34 2012 -0700  
_link_

[ef5cda6] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 13:41:35 2012 -0700  
_more info_

[8a81164] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 13:11:31 2012 -0700  
_Added Core::Config.rehash! (public method)_

[9df6940] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 12:19:12 2012 -0700  
_this bothered me_

[2bb6b2b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 12:17:55 2012 -0700  
_API::Extender is now functional._

[224e1fc] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 11:45:04 2012 -0700  
_API::Extender: prevent undesirable plugins_

[d946fe4] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 11:36:33 2012 -0700  
_private API::Extender.unload() and public API::Extender.punload; use a hash for @plugins [questionable stability]_

[2caa473] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 10:59:31 2012 -0700  
_Plugin functionality._

[576723d] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 04:08:53 2012 -0700  
_API::Plugin superclass_

[1b4ec29] noxgirl \<xoeverlux@gmail.com\>  
Date: Sun Dec 16 00:31:28 2012 -0700  
_irc chatroom changed_

[9176a09] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 23:53:21 2012 -0700  
_issues hub_

[e2f9108] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:53:04 2012 -0700  
_config changes_

[b420b7a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:48:31 2012 -0700  
_Getting support_

[6cb7af9] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:47:36 2012 -0700  
_Getting support_

[6253611] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:42:57 2012 -0700  
_UPGRADE.md_

[6121e71] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:36:30 2012 -0700  
_irc/server_

[83577b5] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 22:06:01 2012 -0700  
_fixes_

[6d1680e] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 21:14:41 2012 -0700  
_wow, just wow, we'll definitely need this in bold in the FAQ: MAKE SURE YOUR COMMAS ARE RIGHT IN THE CONFIG_

[dc7ab78] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 21:13:06 2012 -0700  
_added example irc.autojoin_

[d50f5f0] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 21:10:49 2012 -0700  
_irc.nick -> irc.nickname_

[a3a6487] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 21:02:03 2012 -0700  
_updated to reflect config/API changes_

[af6dd4a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 20:52:34 2012 -0700  
_oops_

[59a782c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 20:35:12 2012 -0700  
_IRC::Std updated to reflect config/API changes_

[18ae533] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 20:21:52 2012 -0700  
_Okay, I think the heavy usage of class variable Core::Config.conf warrants a rename to Core::Config.x._

[d5b7ced] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 20:16:11 2012 -0700  
_updated to reflect API change_

[17d001c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 20:15:04 2012 -0700  
_Updated to use Core::Config; changed debug() to assume log=false; changed event usage to reflect forthcoming API change_

[bedc3c5] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:56:51 2012 -0700  
_deprecated_

[ba29fff] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:49:59 2012 -0700  
_Add --config/-c for specifying an alternate config file_

[fb682da] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:35:40 2012 -0700  
_New Core::Config, reflecting new JSON standard. [codebase broken]_

[b2b4a2f] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:19:23 2012 -0700  
_Group SASL information into a single block._

[582c918] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:15:29 2012 -0700  
_Group SASL information into a single block._

[cd78f7f] Autumn \<xmoonlightx14@gmail.com\>  
Date: Sat Dec 15 19:12:41 2012 -0700  
_Okay, there. I hope it still works._

[15884ff] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:07:52 2012 -0700  
_dammit_

[da32a65] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:06:05 2012 -0700  
_Prettified it a bit._

[be4a30b] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 19:02:53 2012 -0700  
_Here's an example JSON-based configuration file._

[02c4a29] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 17:53:06 2012 -0700  
_Fixed forking as well as added trapping for signals._

[3a89092] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 17:52:45 2012 -0700  
_added Auto.terminate_

[49ed5bb] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 17:52:22 2012 -0700  
_added QUIT_

[cc98195] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:53:51 2012 -0700  
_API::Events and API::Timers_

[f330c30] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:49:32 2012 -0700  
_Core::Logging_

[00dc748] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:48:00 2012 -0700  
_this is no longer appropriate_

[9fc30cb] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:44:06 2012 -0700  
_This is IRC::State::Client [incomplete]. I'll have to figure out what it is later._

[7aed66c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:42:53 2012 -0700  
_superfluous duplicate_

[9c21244] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 16:24:30 2012 -0700  
_Standard IRC functionality_

[8a17d64] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:37:38 2012 -0700  
_IRC connection lib_

[e6dcd3c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:34:13 2012 -0700  
_IRC parser lib_

[02cb725] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:26:08 2012 -0700  
_Renaming lib/core to lib/ruby_core_ext_

[e82b61f] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:24:50 2012 -0700  
_Modifications to Ruby's integrated classes._

[3355ef0] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:19:56 2012 -0700  
_Main library._

[ec02931] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 15:02:26 2012 -0700  
_Present configuration library._

[f78073c] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:58:12 2012 -0700  
_Useful notation._

[4f5cd46] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:53:00 2012 -0700  
_This is the current example configuration file._

[1396d5a] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:50:04 2012 -0700  
_gitignore_

[759e463] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:35:16 2012 -0700  
_Updated Alyx's e-mail address._

[059a9ef] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:22:44 2012 -0700  
_Here comes the launcher._

[e1ee4f6] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:17:40 2012 -0700  
_Grammar._

[a7314f2] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:16:48 2012 -0700  
_Here also._

[d7cecd4] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:15:59 2012 -0700  
_Markdown..._

[ba46946] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:14:57 2012 -0700  
_Consistency!_

[85db044] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:13:02 2012 -0700  
_Pointer to documentation._

[ad622f6] noxgirl \<xoeverlux@gmail.com\>  
Date: Sat Dec 15 14:10:05 2012 -0700  
_Updated README._
