import UIKit

public class CartEntryCustomCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var unit: UILabel!
    
    @IBOutlet var expandedView: UIView!
    @IBOutlet var buttonAddToCart: UIView!
    @IBOutlet var buttonShowLocation: UIView!
    @IBOutlet var buttonReportOutOfStock: UIView!
    
    private var isObserving:Bool = false;
    
    class var defaultHeight: CGFloat {
        get { return 60 }
    }
    
    class var expandedHeight: CGFloat {
        get { return 200 }
    }
    
    func checkHeight(){
        expandedView.hidden = (frame.size.height < CartEntryCustomCell.expandedHeight)
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
    
    func configure(name: String, unit: String, price: Double) {
        let separatedName = split(name, maxSplit: 1, allowEmptySlices: false, isSeparator: isSeparator)
        self.title.text = separatedName[0];
        if(separatedName.count > 1) {
            self.subtitle.text = separatedName[1];
        }
        self.price.text = String(format: "%.2f€".localized, price);
        self.unit.text = unit;
    }
    
    
    func isSeparator(c: Character) -> Bool {
        if (c == " " || c == " " || c == ",") {
            return true
        }
        return false
    }
    
}