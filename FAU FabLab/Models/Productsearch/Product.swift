import Foundation
import ObjectMapper

class Product : Mappable{
    
    private(set) var productId: String?
    private(set) var name: String?
    private(set) var description: String?
    private(set) var unit: String?
    private(set) var price: Double?
    private(set) var itemsAvailable: Int?
    private(set) var location: Location?
    private(set) var locationId: Int64?
    private(set) var locationString: String?
    private(set) var category: Category?
    private(set) var categoryId: Int64?
    private(set) var categoryString: String?
    
    class func newInstance() -> Mappable {
        return Product()
    }
    
    // Mappable
    func mapping(map: Map) {
        productId <- map["product_id"]
        name <- map["name"]
        description <- map["description"]
        unit <- map["unit"]
        category <- map["category_object"]
        categoryId <- map["category_id"]
        categoryString <- map["category_string"]
        price <- map["price"]
        location <- map["location_object"]
        locationId <- map["location_id"]
        locationString <- map["location"]
        itemsAvailable <- map["available"]
    }

}