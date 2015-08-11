
import UIKit

public class ProductCustomCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var unit: UILabel!
    
    @IBOutlet var expandedView: UIView!
    @IBOutlet var buttonAddToCart: UIView!
    @IBOutlet var buttonShowLocation: UIView!
    @IBOutlet var buttonReportOutOfStock: UIView!
    
    private var isObserving:Bool = false;
    private(set) var product:Product!

    class var defaultHeight: CGFloat {
        get { return 60 }
    }
    
    class var expandedHeight: CGFloat {
        get { return 200 }
    }
    
    func checkHeight(){
        expandedView.hidden = (frame.size.height < ProductCustomCell.expandedHeight)
    }
    
    func watchFrameChanges(){
        if(!isObserving){
            addObserver(self, forKeyPath: "frame", options: .New | .Old, context: nil)
            isObserving = true;
            checkHeight()
        }
    }
    
    func ignoreFrameChanges(){
        if(isObserving){
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "frame"){
            checkHeight()
        }
    }

    func configure(product:Product!) {
        self.product = product
        let separatedName = split(product.name!, maxSplit: 1, allowEmptySlices: false, isSeparator: {$0 == " " || $0 == "," })
        self.title.text = separatedName[0];
        if(separatedName.count > 1) {
            self.subtitle.text = separatedName[1];
        }
        self.price.text = String(format: "%.2f€", product.price!);
        self.unit.text = product.unit;
        
    }
    
}
