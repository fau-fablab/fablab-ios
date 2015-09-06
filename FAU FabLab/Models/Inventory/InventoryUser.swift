import UIKit
import Foundation
import ObjectMapper


class InventoryUser: Mappable {
    
    private(set) var username: String?;
    private(set) var password: String?
    
    class func newInstance() -> Mappable {
        return InventoryUser()
    }
    
    func setUsername(username: String){
        self.username = username
    }
    
    func setPassword(password: String){
        self.password = password
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
    }
}