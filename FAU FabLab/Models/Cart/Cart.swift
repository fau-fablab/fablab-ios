
import Foundation
import ObjectMapper

class Cart : Mappable{
    
    enum CartStatus{
        case SHOPPING, PENDING, PAID, CANCELLED, FAILED
    }

    private(set) var cartCode: String?
    private(set) var status = CartStatus.SHOPPING
    private(set) var entries = [CartEntry]()
    
    init(){
        
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
        entries <- map["cart"]
    }
}