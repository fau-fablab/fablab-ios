import UIKit
import AVFoundation
import RSBarcodes

class CheckoutCodeScannerViewController: RSCodeReaderViewController {
    
   
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
                
                let checkoutCode = barcodes[0].stringValue
                let prefix = (checkoutCode as NSString).substringToIndex(3)
                if prefix == "FAU" {
                    self.dismissViewControllerAnimated(true, completion:nil )
                    NSNotificationCenter.defaultCenter().postNotificationName("CheckoutScannerNotification", object: checkoutCode)
                }else{
                    let alert = UIAlertController(title: "Fehler".localized, message: "Kein gültiger Code!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.session.startRunning()
                }
              
                
            })
            
        }
        
        self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview)
        }

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil )
    }
}
