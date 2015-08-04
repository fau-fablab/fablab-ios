
import Foundation
import ObjectMapper
import SwiftyJSON

class Cart : Mappable{
    
    enum CartStatus : String{
        case SHOPPING = "SHOPPING"
        case PENDING = "PENDING"
        case PAID = "PAID"
        case CANCELLED = "CANCELLED"
        case FAILED = "FAILED"
    }

    private(set) var cartCode: String?
    private(set) var status = CartStatus.SHOPPING
    private(set) var entries = [CartEntry]()
    
    init(){
        CartStatus.SHOPPING
    }
    


    class func newInstance() -> Mappable {
        return Cart()
    }
    
    func getCount() -> Int{
        return entries.count;
    }
    
    func addEntry(entry:CartEntry) {
        entries.append(entry)
    }
    
    func getEntry(position:Int) -> CartEntry{
        return entries[position];
    }
    
    //Methods for checkout process
    func setCode(code :String){
        self.cartCode = code
    }
    
    func setStatus(status: CartStatus){
        self.status = status
    }
    
    
    func mapping(map: Map) {
        status <- map["status"]
        cartCode <- map["cartCode"]
        entries <- map["items"]
    }
    
    func toJson() -> JSON{
        var json: JSON = ["cartCode": 0, "items" : ""]
        json["cartCode"] = "23"
        return json
    }


    
}