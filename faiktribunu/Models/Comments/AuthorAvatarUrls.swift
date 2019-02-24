//
//  AuthorAvatarUrls.swift
//
//  Created by Mac on 24.02.2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class AuthorAvatarUrls: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let foureight = "48"
    static let ninesix = "96"
    static let twofour = "24"
  }

  // MARK: Properties
  public var foureight: String?
  public var ninesix: String?
  public var twofour: String?

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
    foureight <- map[SerializationKeys.foureight]
    ninesix <- map[SerializationKeys.ninesix]
    twofour <- map[SerializationKeys.twofour]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = foureight { dictionary[SerializationKeys.foureight] = value }
    if let value = ninesix { dictionary[SerializationKeys.ninesix] = value }
    if let value = twofour { dictionary[SerializationKeys.twofour] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.foureight = aDecoder.decodeObject(forKey: SerializationKeys.foureight) as? String
    self.ninesix = aDecoder.decodeObject(forKey: SerializationKeys.ninesix) as? String
    self.twofour = aDecoder.decodeObject(forKey: SerializationKeys.twofour) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(foureight, forKey: SerializationKeys.foureight)
    aCoder.encode(ninesix, forKey: SerializationKeys.ninesix)
    aCoder.encode(twofour, forKey: SerializationKeys.twofour)
  }

}
