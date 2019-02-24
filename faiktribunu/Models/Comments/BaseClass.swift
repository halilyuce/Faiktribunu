//
//  BaseClass.swift
//
//  Created by Mac on 24.02.2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class BaseClass: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let meta = "meta"
    static let authorAvatarUrls = "author_avatar_urls"
    static let authorUrl = "author_url"
    static let date = "date"
    static let links = "_links"
    static let author = "author"
    static let type = "type"
    static let authorName = "author_name"
    static let content = "content"
    static let link = "link"
    static let status = "status"
    static let id = "id"
    static let parent = "parent"
    static let post = "post"
    static let dateGmt = "date_gmt"
  }

  // MARK: Properties
  public var meta: [Any]?
  public var authorAvatarUrls: AuthorAvatarUrls?
  public var authorUrl: String?
  public var date: String?
  public var author: Int?
  public var type: String?
  public var authorName: String?
  public var content: CommentsContent?
  public var link: String?
  public var status: String?
  public var id: Int?
  public var parent: Int?
  public var post: Int?
  public var dateGmt: String?

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
    meta <- map[SerializationKeys.meta]
    authorAvatarUrls <- map[SerializationKeys.authorAvatarUrls]
    authorUrl <- map[SerializationKeys.authorUrl]
    date <- map[SerializationKeys.date]
    author <- map[SerializationKeys.author]
    type <- map[SerializationKeys.type]
    authorName <- map[SerializationKeys.authorName]
    content <- map[SerializationKeys.content]
    link <- map[SerializationKeys.link]
    status <- map[SerializationKeys.status]
    id <- map[SerializationKeys.id]
    parent <- map[SerializationKeys.parent]
    post <- map[SerializationKeys.post]
    dateGmt <- map[SerializationKeys.dateGmt]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = meta { dictionary[SerializationKeys.meta] = value }
    if let value = authorAvatarUrls { dictionary[SerializationKeys.authorAvatarUrls] = value.dictionaryRepresentation() }
    if let value = authorUrl { dictionary[SerializationKeys.authorUrl] = value }
    if let value = date { dictionary[SerializationKeys.date] = value }
    if let value = author { dictionary[SerializationKeys.author] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    if let value = authorName { dictionary[SerializationKeys.authorName] = value }
    if let value = content { dictionary[SerializationKeys.content] = value.dictionaryRepresentation() }
    if let value = link { dictionary[SerializationKeys.link] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = parent { dictionary[SerializationKeys.parent] = value }
    if let value = post { dictionary[SerializationKeys.post] = value }
    if let value = dateGmt { dictionary[SerializationKeys.dateGmt] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.meta = aDecoder.decodeObject(forKey: SerializationKeys.meta) as? [Any]
    self.authorAvatarUrls = aDecoder.decodeObject(forKey: SerializationKeys.authorAvatarUrls) as? AuthorAvatarUrls
    self.authorUrl = aDecoder.decodeObject(forKey: SerializationKeys.authorUrl) as? String
    self.date = aDecoder.decodeObject(forKey: SerializationKeys.date) as? String
    self.author = aDecoder.decodeObject(forKey: SerializationKeys.author) as? Int
    self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
    self.authorName = aDecoder.decodeObject(forKey: SerializationKeys.authorName) as? String
    self.content = aDecoder.decodeObject(forKey: SerializationKeys.content) as? CommentsContent
    self.link = aDecoder.decodeObject(forKey: SerializationKeys.link) as? String
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.parent = aDecoder.decodeObject(forKey: SerializationKeys.parent) as? Int
    self.post = aDecoder.decodeObject(forKey: SerializationKeys.post) as? Int
    self.dateGmt = aDecoder.decodeObject(forKey: SerializationKeys.dateGmt) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(meta, forKey: SerializationKeys.meta)
    aCoder.encode(authorAvatarUrls, forKey: SerializationKeys.authorAvatarUrls)
    aCoder.encode(authorUrl, forKey: SerializationKeys.authorUrl)
    aCoder.encode(date, forKey: SerializationKeys.date)
    aCoder.encode(author, forKey: SerializationKeys.author)
    aCoder.encode(type, forKey: SerializationKeys.type)
    aCoder.encode(authorName, forKey: SerializationKeys.authorName)
    aCoder.encode(content, forKey: SerializationKeys.content)
    aCoder.encode(link, forKey: SerializationKeys.link)
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(parent, forKey: SerializationKeys.parent)
    aCoder.encode(post, forKey: SerializationKeys.post)
    aCoder.encode(dateGmt, forKey: SerializationKeys.dateGmt)
  }

}
