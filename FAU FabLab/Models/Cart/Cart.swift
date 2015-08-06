
import Foundation
import ObjectMapper
import SwiftyJSON

// INFO TO ALL: Check Cart Status before doing anything. 
//              --> ONLY IF STATUS == Shopping -> ADD/CHANGE.... -> OTHERWISE there is a checkout process running!

class Cart : NSObject{
    
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
    
    override init(){
        CartStatus.SHOPPING
        super.init()
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
    
    /*                      Checkout process            */
    
    
    func setCode(code :String){
        self.cartCode = code
    }
    
    func setStatus(status: CartStatus){
        self.status = status
    }
    
    
    
    
    func serialize() -> NSDictionary{
        var items = [NSDictionary]()
        for item in entries{
            items.append(item.serialize())
        }
        
        let cart = [
            "cartCode": cartCode as String!,
            "items": items,
            "status": status.rawValue
        ]
        return cart
    }
    
    
}