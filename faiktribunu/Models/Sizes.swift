//
//  Sizes.swift
//  faiktribunu
//
//  Created by Mac on 20.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation
import ObjectMapper

public class Sizes: BaseItem {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let sizes = "sizes"
    }
    
    // MARK: Properties
    public var sizes: Medium?
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        sizes <- map[SerializationKeys.sizes]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public override func dictionaryRepresentation() -> [String: AnyObject] {
        var dictionary: [String: Any] = [:]
        if let value = sizes { dictionary[SerializationKeys.sizes] = value }
        return dictionary as [String : AnyObject] as [String : AnyObject]
    }
    
}

