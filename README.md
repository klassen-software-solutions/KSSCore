# KSSCore
Miscellaneous Swift utilities

## Description

This package is divided into a number of Swift Modules providing utility methods related to both
UI and non-UI classes. At present only _KSSFoundation_ and _KSSTest_ are available on both Mac 
and Linux. The remaining modules are only available on Mac.

The modules provided by this package are the following:

* _KSSFoundation_ - items that depend on nothing but the Foundation classes
* _KSSMap_ - items that depend on MapKit
* _KSSTest_ - items that depend on XCTest
* _KSSUI_ - items that depend on Foundation and SwiftUI
* _KSSWeb_ - items that depend on WebKit

 [API Documentation](https://www.kss.cc/apis/KSSCore/docs/index.html)
 
 ## Module Availability
 
 Not all modules are currently available on all architechtures. Presently we support the following:
 
 * _macOS_ - All modules are available
 * _iOS_ - All modules are available, except for `KSSCocoa` and `KSSWeb`.
 * _Linux_ - Only `KSSFoundation` and `KSSTest` are available
