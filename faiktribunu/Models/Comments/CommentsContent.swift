//
//  Content.swift
//
//  Created by Mac on 24.02.2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class CommentsContent: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let rendered = "rendered"
  }

  // MARK: Properties
  public var rendered: String?

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
    rendered <- map[SerializationKeys.rendered]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = rendered { dictionary[SerializationKeys.rendered] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.rendered = aDecoder.decodeObject(forKey: SerializationKeys.rendered) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(rendered, forKey: SerializationKeys.rendered)
  }

}
