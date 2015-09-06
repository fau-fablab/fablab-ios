
import UIKit

public class InventoryProductSearchCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    
    private(set) var product:Product!
    

    func configure(product: Product!) {
        self.product = product
        configure(product.name!, unit: product.unit!, price: product.price!)
    }
    
    func configure(name: String, unit: String, price: Double) {
        let separatedName = split(name, maxSplit: 1, allowEmptySlices: false, isSeparator: isSeparator)
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
