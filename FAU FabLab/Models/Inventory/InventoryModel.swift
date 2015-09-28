
import Foundation

class InventoryModel : NSObject{
    
    private var currentItem = InventoryItem()
    private var user = User()
    
    override init(){
        super.init()
        self.currentItem.setUUID(NSUUID().UUIDString)
    }

    func setUser(user: User){
        self.user = user
    }
    
    func getUser() -> User{
        return self.user
    }
    
    func setCurrentItem(item : InventoryItem){
        self.currentItem = item
    }
    
    func getCurrentItem() -> InventoryItem{
        return self.currentItem
    }
}