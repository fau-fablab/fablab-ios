
import UIKit

public class PayOrCancelCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    
    func configure(cartEntry: CartEntry) {
        let separatedName = cartEntry.product.name.characters.split(1, allowEmptySlices: false, isSeparator: isSeparator).map { String($0) }
        self.title.text = separatedName[0];
        if(separatedName.count > 1) {
            self.subTitle.text = separatedName[1];
        }
        self.amount.text = "\(cartEntry.amount)"
    }
    
    
    func isSeparator(c: Character) -> Bool {
        if (c == " " || c == " " || c == ",") {
            return true
        }
        return false
    }
}
