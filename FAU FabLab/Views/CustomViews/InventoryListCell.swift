
import UIKit

public class InventoryListCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    @IBOutlet weak var amount: UILabel!

    private(set) var item : InventoryItem!
    
    func configure(inventoryItem: InventoryItem) {
        self.item = inventoryItem
        if inventoryItem.productName != nil{
            self.title.text = inventoryItem.productName
        }
        if inventoryItem.userName != nil{
            self.subtitle.text = "von ".localized + inventoryItem.userName! + " @\(inventoryItem.updatedAt!)"
        }else{
            self.subtitle.text = " @\(inventoryItem.updatedAt!)"
        }
        self.amount.text = "\(inventoryItem.amount!)"
    }
}
