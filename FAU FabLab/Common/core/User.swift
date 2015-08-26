import Foundation
import ObjectMapper

class User : Mappable{
    
    private(set) var username: String?
    private(set) var password: String?
    private(set) var roles: [Roles]?
    
    class func newInstance() -> Mappable {
        return User()
    }
    
    // Mappable
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
        roles <- map["roles"]
    }
    
    func hasRole(role : Roles) -> Bool{
        if let roles = roles{
            for tmp in roles{
                if tmp == role{
                    return true
                }
            }
        }
        return false
    }
    
    func addRole(role : Roles){
        roles?.append(role)
    }
}