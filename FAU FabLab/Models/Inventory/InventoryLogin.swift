
import Foundation

class InventoryLogin : NSObject{
    
    private var user = User()

    override init(){
        super.init()
        user.setUsername(NSUserDefaults.standardUserDefaults().stringForKey("inventoryUserUsername")!)
        user.setPassword(NSUserDefaults.standardUserDefaults().stringForKey("inventoryUserPassword")!)
    }
    func getUser()-> User{
        return user
    }

    func saveUser(user: User){
        NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "inventoryUserUsername")
        NSUserDefaults.standardUserDefaults().setObject(user.password, forKey: "inventoryUserPassword")
    }
    
    func deleteUser(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inventoryUserUsername")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inventoryUserPassword")
    }
    
}