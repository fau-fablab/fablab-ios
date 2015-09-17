import Foundation
import ObjectMapper

class Category : Mappable{
    
    private(set) var categoryId: Int64?
    private(set) var name: String?
    private(set) var locationString: String?
    private(set) var locationObject: Location?
    private(set) var parentCategoryId: Int64?
    private(set) var categories: [Int64]?
    
    class func newInstance() -> Mappable {
        return Category()
    }
    
    // Mappable
    func mapping(map: Map) {
        categoryId <- (map["categoryId"], TransformOf<Int64, NSNumber>(fromJSON: { $0?.longLongValue }, toJSON: { $0.map { NSNumber(longLong: $0) } }))
        name <- map["name"]
        locationString <- map["locationString"]
        locationObject <- map["location"]
        parentCategoryId <- (map["parentCategoryId"], TransformOf<Int64, NSNumber>(fromJSON: { $0?.longLongValue }, toJSON: { $0.map { NSNumber(longLong: $0) } }))
        categories <- (map["categoryChilds"], TransformOf<Int64, NSNumber>(fromJSON: { $0?.longLongValue }, toJSON: { $0.map { NSNumber(longLong: $0) } }))
    }
    
}