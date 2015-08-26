import Foundation
import ObjectMapper

class InventoryItem : Mappable{

    private(set) var userName: String?
    private(set) var UUID: String?
    private(set) var productId: String?
    private(set) var productName: String?
    private(set) var amount: Double?
    private(set) var updatedAt: NSDate?

    class func newInstance() -> Mappable {
        return InventoryItem()
    }

    func mapping(map: Map) {
        userName <- map["userName"]
        UUID <- map["UUID"]
        productId <- map["productId"]
        productName <- map["productName"]
        amount <- map["amount"]
        updatedAt <- map["updated_at"]
    }
}

