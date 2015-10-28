import Foundation
import ObjectMapper

class InventoryItem : Mappable{

    private(set) var userName:      String?
    private(set) var UUID:          String?
    private(set) var productId:     String?
    private(set) var productName:   String?
    private(set) var amount:        Double?
    private(set) var updatedAt:     NSDate?

    required init?(_ map: Map){}
    
    init(){}
    
    func mapping(map: Map) {
        userName    <-  map["userName"]
        UUID        <-  map["uuid"]
        productId   <-  map["productId"]
        productName <-  map["productName"]
        amount      <-  map["amount"]
        updatedAt   <- (map["updated_at"], DateTransform())
    }
    
    func setUser(userName: String){
        self.userName = userName
    }
    
    func setUUID(UUID: String){
        self.UUID = UUID
    }
    
    func setProductId(productId: String){
        self.productId = productId
    }
    
    func setProductName(productName: String){
        self.productName = productName
    }
    
    func setAmount(amount: Double){
        self.amount = amount
    }
    
    func setUpdatedAt(time: NSDate){
        self.updatedAt = time
    }

    private class DateTransform : DateFormatterTransform {
        init() {
            //TODO this conversion might be wrong! has to be checked but works so far
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'+0000'"
            
            super.init(dateFormatter: formatter)
        }
    }
}

