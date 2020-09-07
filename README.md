# KSSCore
Miscellaneous non-UI Swift utilities

## Description

This package is divided into a number of Swift Modules providing utility methods related to both
UI and non-UI classes. At present only _KSSFoundation_ and _KSSTest_ are available on both Mac 
and Linux. The remaining modules are only available on Mac.

The modules provided by this package are the following:

* _KSSFoundation_ - items that depend on nothing but the Foundation classes
* _KSSTest_ - items that depend on XCTest

 [API Documentation](https://www.kss.cc/apis/KSSCore/docs/index.html)
 
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
 
