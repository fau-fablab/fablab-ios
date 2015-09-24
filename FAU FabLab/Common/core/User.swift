import Foundation
import ObjectMapper

class User : Mappable{
    
    private(set) var username:  String?
    private(set) var password:  String?
    private(set) var roles:     [Roles]?
    
    required init?(_ map: Map){}
    
    init(){}
    
    class func newInstance(username: String, password: String) -> User{
        let user = User()
        user.username = username
        user.password = password
        return user
    }
    
    // Mappable
    func mapping(map: Map) {
        username    <- map["username"]
        password    <- map["password"]
        roles       <- map["roles"]
    }
    
    func setUsername(username: String){
        self.username = username
    }
    
    func setPassword(password: String){
        self.password = password
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