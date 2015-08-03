import UIKit
import AVFoundation
import RSBarcodes

class ProductsearchCodeScannerViewController: RSCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let productId = self.getProductIdFromBarcode(barcodes[0])
                self.tabBarController?.selectedIndex = 2
                NSNotificationCenter.defaultCenter().postNotificationName("ProductScannerNotification", object: productId)
            })
        
        }
        self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]
        
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    private func getProductIdFromBarcode(barcode: AVMetadataMachineReadableCodeObject) -> String{
        if (barcode.type == AVMetadataObjectTypeEAN13Code) {
            let productId = barcode.stringValue as NSString
            return productId.substringWithRange(NSRange(location: 8, length: 4))
        } else {
            let productId = barcode.stringValue as NSString
            return productId.substringWithRange(NSRange(location: 3, length: 4))
        }
    }
}