//
//  CGRectTransformer.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 23.10.2021.
//

import SwiftUI
import CoreData

@objc(CGRectTransformer)
class CGRectTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let cgRect = value as? CGRect else {return nil}
        let data = try! NSKeyedArchiver.archivedData(withRootObject: cgRect, requiringSecureCoding: false)
        return data
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let cgRectData = value as? Data else {return nil}
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cgRectData)
    }
}
