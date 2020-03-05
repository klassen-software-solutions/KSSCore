//
//  NSImageExtension.swift
//
//  Created by Steven W. Klassen on 2020-03-04.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import os
import AppKit
import Foundation

@available(OSX 10.14, *)
public extension NSImage {

    /**
     Performs a color invert of the image and returns the new one. If an error occurs, a message is logged
     and the original image is returned.
     */
    func inverted() -> NSImage {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            os_log(.error, "Could not create CGImage from NSImage")
            return self
        }

        let ciImage = CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else {
            os_log(.error, "Could not create CIColorInvert filter")
            return self
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            os_log(.error, "Could not obtain output CIImage from filter")
            return self
        }

        guard let outputCgImage = outputImage.toCGImage() else {
            os_log(.error, "Could not create CGImage from CIImage")
            return self
        }

        return NSImage(cgImage: outputCgImage, size: self.size)
    }
}

fileprivate extension CIImage {
    func toCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}
