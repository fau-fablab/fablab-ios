import Foundation
import ObjectMapper

class Category : Mappable{
    
    private(set) var name: String?
    private(set) var categoryId: Int64?
    private(set) var parentCategoryId: Int64?
    private(set) var locationId: Int64?
    private(set) var locationString: String?
    private(set) var locationObject: Location?
    private(set) var categories: [Int64]?
    
    class func newInstance() -> Mappable {
        return Category()
    }
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        categoryId <- map["categoryId"]
        parentCategoryId <- map["parentCategoryId"]
        locationId <- map["location_id"]
        locationString <- map["locationString"]
        locationObject <- map["location"]
        categories <- map["categoryChilds"]
    }
    
}