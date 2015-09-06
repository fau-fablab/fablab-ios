
import UIKit

public class InventoryProductSearchCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    

    func configure(product: Product!) {
        let separatedName = split(product.name!, maxSplit: 1, allowEmptySlices: false, isSeparator: isSeparator)
        self.title.text = separatedName[0];
        if(separatedName.count > 1) {
            self.subtitle.text = separatedName[1];
        }
    }
    
    func isSeparator(c: Character) -> Bool {
        if (c == " " || c == " " || c == ",") {
            return true
        }
        return false
    }
    
  }
