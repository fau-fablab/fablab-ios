import UIKit
import AVFoundation
import RSBarcodes

class InventoryItemScanViewController: RSCodeReaderViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scan()
    }
    
    private func scan(){
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let productId = BarcodeScannerHelper.getProductIdFromBarcode(barcodes[0])
                NSNotificationCenter.defaultCenter().postNotificationName("InventoryItemScanned", object: productId)
               
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion:nil)
                }
            })
        }
        self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]
        
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview )
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion:nil )
    }
}