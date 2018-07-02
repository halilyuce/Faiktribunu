//
//  Base.swift
//  faiktribunu
//
//  Created by Halil İbrahim YÜCE on 1.07.2018.
//  Copyright © 2018 Halil İbrahim YÜCE. All rights reserved.
//

import Foundation
import ObjectMapper

public class Base: BaseItem {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let media = "featured_media"
        static let id = "id"
        static let categories = "categories"
        static let title = "title"
        static let content = "content"
    }
    
    // MARK: Properties
    public var media: Int?
    public var id: Int?
    public var categories: [Int]?
    public var title: Title?
    public var content: Content?
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        media <- map[SerializationKeys.media]
        id <- map[SerializationKeys.id]
        categories <- map[SerializationKeys.categories]
        title <- map[SerializationKeys.title]
        content <- map[SerializationKeys.content]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public override func dictionaryRepresentation() -> [String: AnyObject] {
        var dictionary: [String: Any] = [:]
        if let value = media { dictionary[SerializationKeys.media] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = categories { dictionary[SerializationKeys.categories] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = content { dictionary[SerializationKeys.content] = value }
        return dictionary as [String : AnyObject] as [String : AnyObject]
    }
    
}
