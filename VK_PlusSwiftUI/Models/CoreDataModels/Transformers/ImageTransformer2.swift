//
//  ImageTransformer2.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//

import SwiftUI
import CoreData

@objc(ImageTransformer2)
class ImageTransformer2: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else {return nil}
        let data = image.pngData()
        return data
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let imageData = value as? Data else {return nil}
        return UIImage(data: imageData)
    }
}
