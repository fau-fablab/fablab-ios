import Foundation
import ObjectMapper

class Category : Mappable{
    
    private(set) var categoryId: Int?
    private(set) var name: String?
    private(set) var locationString: String?
    private(set) var locationObject: Location?
    private(set) var parentCategoryId: Int?
    private(set) var categories: [Int]?
    
    class func newInstance() -> Mappable {
        return Category()
    }
    
    // Mappable
    func mapping(map: Map) {
        categoryId <- map["categoryId"]
        name <- map["name"]
        locationString <- map["locationString"]
        locationObject <- map["location"]
        parentCategoryId <- map["parentCategoryId"]
        categories <- map["categoryChilds"]
    }
    
}