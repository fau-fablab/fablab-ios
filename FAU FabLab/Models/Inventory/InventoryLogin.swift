
import Foundation

class InventoryLogin : NSObject{

    private(set) var username = NSUserDefaults.standardUserDefaults().stringForKey("inventoryUserUsername")
    private(set) var password = NSUserDefaults.standardUserDefaults().stringForKey("inventoryUserPassword")
    

    func saveUser(username: String, password: String){
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "inventoryUserUsername")
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "inventoryUserPassword")
    }
    
    func deleteUser(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inventoryUserUsername")
         NSUserDefaults.standardUserDefaults().removeObjectForKey("inventoryUserPassword")
    }
    
}