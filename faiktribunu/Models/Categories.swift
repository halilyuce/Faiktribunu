//
//  BaseClass.swift
//
//  Created by Mac on 21.02.2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Categories: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let link = "link"
    static let name = "name"
    static let slug = "slug"
    static let id = "id"
    static let parent = "parent"
    static let count = "count"
    static let meta = "meta"
    static let descriptionValue = "description"
    static let taxonomy = "taxonomy"
  }

  // MARK: Properties
  public var link: String?
  public var name: String?
  public var slug: String?
  public var id: Int?
  public var parent: Int?
  public var count: Int?
  public var meta: [Any]?
  public var descriptionValue: String?
  public var taxonomy: String?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    link <- map[SerializationKeys.link]
    name <- map[SerializationKeys.name]
    slug <- map[SerializationKeys.slug]
    id <- map[SerializationKeys.id]
    parent <- map[SerializationKeys.parent]
    count <- map[SerializationKeys.count]
    meta <- map[SerializationKeys.meta]
    descriptionValue <- map[SerializationKeys.descriptionValue]
    taxonomy <- map[SerializationKeys.taxonomy]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = link { dictionary[SerializationKeys.link] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = slug { dictionary[SerializationKeys.slug] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = parent { dictionary[SerializationKeys.parent] = value }
    if let value = count { dictionary[SerializationKeys.count] = value }
    if let value = meta { dictionary[SerializationKeys.meta] = value }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = taxonomy { dictionary[SerializationKeys.taxonomy] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.link = aDecoder.decodeObject(forKey: SerializationKeys.link) as? String
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.slug = aDecoder.decodeObject(forKey: SerializationKeys.slug) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.parent = aDecoder.decodeObject(forKey: SerializationKeys.parent) as? Int
    self.count = aDecoder.decodeObject(forKey: SerializationKeys.count) as? Int
    self.meta = aDecoder.decodeObject(forKey: SerializationKeys.meta) as? [Any]
    self.descriptionValue = aDecoder.decodeObject(forKey: SerializationKeys.descriptionValue) as? String
    self.taxonomy = aDecoder.decodeObject(forKey: SerializationKeys.taxonomy) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(link, forKey: SerializationKeys.link)
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(slug, forKey: SerializationKeys.slug)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(parent, forKey: SerializationKeys.parent)
    aCoder.encode(count, forKey: SerializationKeys.count)
    aCoder.encode(meta, forKey: SerializationKeys.meta)
    aCoder.encode(descriptionValue, forKey: SerializationKeys.descriptionValue)
    aCoder.encode(taxonomy, forKey: SerializationKeys.taxonomy)
  }

}
