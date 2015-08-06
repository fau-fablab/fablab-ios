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
    private(set) var uom: Uom?
    private(set) var uom_id: Int64?
    
    class func newInstance() -> Mappable {
        return Product()
    }
    
    init(){}
    
    func setId(id: String){
        productId = id
    }
    
    // Mappable
    func mapping(map: Map) {
        productId <- map["productId"]
        name <- map["name"]
        description <- map["description"]
        unit <- map["unit"]
        category <- map["category"]
        categoryId <- map["categoryId"]
        categoryString <- map["categoryString"]
        price <- map["price"]
        location <- map["locationObject"]
        locationId <- map["location_id"]
        locationString <- map["location"]
        itemsAvailable <- map["itemsAvailable"]
        uom <- map["uom"]
        uom_id <- map["uom_id"]
    }

}