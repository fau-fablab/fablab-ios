
import UIKit

public class ProductCustomCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var unit: UILabel!
    
    public func configure(name: String, price: Double, unit: String) {
        
        let separatedName = split(name, maxSplit: 1, allowEmptySlices: false, isSeparator: {$0 == " " || $0 == "," })
        self.title.text = separatedName[0];
        if(separatedName.count > 1) {
            self.subtitle.text = separatedName[1];
        }
        self.price.text = String(format: "%.2f€", price);
        self.unit.text = unit;
        
    }
    
}
