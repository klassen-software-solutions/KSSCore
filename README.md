# KSSCore
Miscellaneous non-UI Swift utilities

## Description

This package is divided into a number of Swift Modules providing utility methods related to both
UI and non-UI classes. At present only _KSSFoundation_ and _KSSTest_ are available on both Mac 
and Linux. The remaining modules are only available on Mac.

The modules provided by this package are the following:

* _KSSFoundation_ - items that depend on nothing but the Foundation classes
* _KSSTest_ - items that depend on XCTest

 [API Documentation](https://klassensoftwaresolutions.ca/apis/KSSCore/docs/index.html)
 
 ## What Has Changed In Version 5
 
 This was only going to be a minor change bringing us to V4.1, however the logging was becoming
 more and more cumbersome due to the limitations is OSX pre 10.12. So we have made 10.12 the
 new minimum for this library.
 
 In addition this version includes the following:
 
 * Made the XCTest extension for `expect` more general and removed the older version of the API.
 * Added XCTestCase extensions for generating random test data.
 * Added the ability to watch a file and obtain the change notifications. This is a wrapper around the
 Apple Core Services, hence is not available on Linux.
 * Added a simple version of `os_log` for Linux for internal use only. (So some items that were previously
 logged in OSX and silent on Linux, are now logged on Linux as well.)
 * Added an additional `duration` version that computes a duration from a given date. This is more 
 accurate than the previous version, which still exists, which does not require a given date but uses
 approximate values for the length of a month and year.
 * Added Dictionary extensions for dealing with case insensitive lookups.
 * Added InputStreamReader for efficiently reading streams in blocks.
 * Added a Platform struct to make it easier to determine what platform on which we are running.
 * Added a Wrapper class to allow a pass by value object to outlive the current scope.
 
 ## What Has Changed In Version 4
 
 The primary change from version 3 to 4 is that all the UI related items have been removed
 from this package into a separate package, KSSCoreUI. The primarily reason for this was to
 make it easier to deal with both Linux and Mac systems in the same library, without a lot of
 exceptions to our standard development tools.
 
 In particular this eliminates the need for manually maintaining the `Makefile` when new modules
 are added since we no longer need to distinguish between Linux supported and non-Linux
 supported modules.
 
  ## Module Availability
 
 At present we support all modules in _macOS_, _iOS_, and _Linux_. Note that the only Linux
 we have tested on is Ubuntu.
 
