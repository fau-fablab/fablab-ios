
import UIKit

public class InventoryListCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    @IBOutlet weak var amount: UILabel!

    private(set) var item : InventoryItem!
    
    func configure(inventoryItem: InventoryItem) {
        self.item = inventoryItem
        self.title.text = inventoryItem.productName
        self.subtitle.text = inventoryItem.productId
        self.amount.text = "\(inventoryItem.amount!)"
    }
}
