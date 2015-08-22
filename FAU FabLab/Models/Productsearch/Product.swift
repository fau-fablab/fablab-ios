import Foundation
import ObjectMapper

class Product : NSObject, Mappable{
    
    private(set) var productId: String?
    private(set) var name: String?
    private(set) var desc: String?
    private(set) var unit: String?
    private(set) var price: Double?
    private(set) var locationString: String?
    private(set) var category: Category?
    private(set) var categoryString: String?
    private(set) var uom: Uom?

    class func newInstance() -> Mappable {
        return Product()
    }
    
    override init(){}

    var hasLocation: Bool{
        return locationString != "unknown location"
    }

    var getLocation: String{
        return locationString!.stringByReplacingOccurrencesOfString(" / ", withString: "/")
            .stringByReplacingOccurrencesOfString(" ", withString: "_")

    }
    
    func setId(id: String){
        productId = id
    }
    
    // Mappable
    func mapping(map: Map) {
        category <- map["category"]
        productId <- map["productId"]
        name <- map["name"]
        desc <- map["description"]
        unit <- map["unit"]
        price <- map["price"]
        categoryString <- map["categoryString"]
        locationString <- map["location"]
        uom <- map["uom"]
    }

}