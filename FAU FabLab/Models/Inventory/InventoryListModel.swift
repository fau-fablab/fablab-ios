import Foundation

class InventoryListModel{
    private(set)  var items : [InventoryItem] = []
    
    func setItems(items: [InventoryItem]){
        self.items = items
    }
    
    func removeAllItems(){
        self.items = []
    }
}