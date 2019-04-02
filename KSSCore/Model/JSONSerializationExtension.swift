//
//  JSONSerializationExtension.swift
//  KSSCore
//
//  Created by Steven W. Klassen on 2017-04-10.
//  Copyright © 2017 Klassen Software Solutions. All rights reserved.
//

import Foundation


/*!
 This extension adds methods to JSONSerialization to allow user defined classes to
 be serialized and unserialized. This is done by using introspection to convert them
 to the arrays and dictionaries that JSONSerialization can then use.
 */
public extension JSONSerialization {

    /*!
     Generate JSON data from a generic Swift object. Note that it does not currenlty
     work with struct values, it requires a class. Although structs may be contained in
     the class, they cannot be the root object. I have not yet determine why that is
     the case. (Mirror.children.count returns 0 for structs at the root, but proper numbers
     for structs that have been passed in as part of a class.)
     */
    class func data(fromSwiftObject obj: Any,
                    options opts: JSONSerialization.WritingOptions = []) throws -> Data
    {
        if isValidJSONObject(obj) {
            return try data(withJSONObject: obj, options: opts)
        }
        else {
            let jsonObj = try toJSONObject(fromSwiftObject: obj, isTopCall: true)
			assert(isValidJSONObject(jsonObj))
            return try data(withJSONObject: jsonObj, options: opts)
        }
    }

    /*!
     Write JSON data for a generic Swift object to a stream. See the warnings for
     data:fromSwiftObject.
     */
    class func writeSwiftObject(obj: Any,
                                to: OutputStream,
                                options: JSONSerialization.WritingOptions = [],
                                error: NSErrorPointer) -> Int
    {
        if isValidJSONObject(obj) {
            return writeJSONObject(obj, to: to, options: options, error: error)
        }
        else {
            let jsonObj: Any?
            do {
                jsonObj = try toJSONObject(fromSwiftObject: obj)
            }
            catch let err as NSError {
                if error != nil {
                    error?.pointee = err
                }
                return 0
            }
            return writeJSONObject(jsonObj!, to: to, options: options, error: error)
        }
    }

    // MARK: private implementation

    // Throw an exception indicating we could not convert the object to JSON.
    private class func generateError(_ msg: String) -> NSError {
        return NSError.init(domain: NSPOSIXErrorDomain, code: kPOSIXErrorEINVAL,
                            userInfo: [NSLocalizedDescriptionKey: msg])
    }

    // Recursive method to generate an object that will work with JSONSerialization.
    private class func toJSONObject(fromSwiftObject obj: Any,
                                    isTopCall: Bool = false) throws -> Any
    {
        if isValidJSONObject(obj) {
            // If we are already suitable for conversion, we are done.
            return obj
        }
        else {
            let mir = Mirror(reflecting: obj)
            guard let displayStyle = mir.displayStyle else {
                if isTopCall {
                    throw generateError("Introspection could not determine displayStyle for the top object.")
                }
                else {
                    return obj
                }
            }
            guard !mir.description.hasPrefix("Mirror for _Swift") else {
                // This is ugly but it seems to indicate the Mirror does not handle the
                // input object type. In Swift 3 this was the case for structs, but they
                // seem to work now and I can no longer find an example that would trigger
                // this. But I'll keep it here as defensive code.
                throw generateError("Introspection could not examine one of the objects.")
            }

            switch displayStyle {
            case .class, .dictionary, .struct:
                return try toJSONObjectFromDictionary(usingMirror: mir)
            case .collection, .set, .tuple, .enum:
                return try toJSONObjectFromArray(usingMirror: mir)
            default:
                throw generateError("Could not convert object into a JSON compatible one.")
            }
        }
    }

    private class func toJSONObjectFromDictionary(usingMirror mir: Mirror) throws -> Any {
        var jsonObj = [String: Any]()
        var mirror: Mirror? = mir
        repeat {
            for case let (label?, value) in mirror!.children {
                jsonObj[label] = try toJSONObject(fromSwiftObject: value)
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
        return jsonObj
    }

    private class func toJSONObjectFromArray(usingMirror mir: Mirror) throws -> Any {
        var jsonObj = [Any]()
        for (_, value) in mir.children {
            jsonObj.append(try toJSONObject(fromSwiftObject: value))
        }
        return jsonObj
    }
}
