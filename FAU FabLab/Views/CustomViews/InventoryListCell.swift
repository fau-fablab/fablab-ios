
import UIKit

public class InventoryListCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    
    func configure(inventoryItem: InventoryItem!) {
        self.title.text = inventoryItem.productName
        self.subtitle.text = inventoryItem.productId
        self.amount.text = "\(inventoryItem.amount)"
    }
    
    
}
