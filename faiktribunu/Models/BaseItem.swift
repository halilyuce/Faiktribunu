//
//  BaseItem.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 1.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation
import ObjectMapper

public class BaseItem: NSObject, Mappable{
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let status1 = "Status"
        static let recordCount1 = "RecordCount"
        static let errorMessage1 = "ErrorMessage"
        static let errorCode1 = "ErrorCode"
        static let hasNextPage1 = "HasNextPage"
    }
    
    // MARK: Properties
    public var status1: Bool? = false
    public var recordCount1: Int? = 0
    public var errorMessage1: String? = "Error"
    public var errorCode1: Int? = 0
    public var hasNextPage1: Bool? = false
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    
    public required override init() {
        super.init()
        
    }
    
    public required init?(map: Map) {
        
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public func mapping(map: Map) {
        status1 <- map[SerializationKeys.status1]
        recordCount1 <- map[SerializationKeys.recordCount1]
        errorMessage1 <- map[SerializationKeys.errorMessage1]
        errorCode1 <- map[SerializationKeys.errorCode1]
        hasNextPage1 <- map[SerializationKeys.hasNextPage1]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: AnyObject] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.status1] = status1
        if let value = recordCount1 { dictionary[SerializationKeys.recordCount1] = value }
        if let value = errorMessage1 { dictionary[SerializationKeys.errorMessage1] = value }
        if let value = errorCode1 { dictionary[SerializationKeys.errorCode1] = value }
        dictionary[SerializationKeys.hasNextPage1] = hasNextPage1
        return dictionary as [String: AnyObject]
    }
    
}
