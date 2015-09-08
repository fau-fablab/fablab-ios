import UIKit
import AVFoundation
import RSBarcodes
import ObjectMapper

class InventoryLoginViaScanViewController: RSCodeReaderViewController {
    
    
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
                if let scanned = Mapper<User>().map("\(barcodes[0].stringValue)"){
                    if(scanned.username != nil && scanned.password != nil){
                        NSNotificationCenter.defaultCenter().postNotificationName("InventoryUserScanned", object: scanned)
                        self.dismissViewControllerAnimated(true, completion:nil )
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        var alert = UIAlertController(title: "Achtung".localized, message: "Dies ist kein gültiger QR Code zum Login".localized,    preferredStyle: UIAlertControllerStyle.Alert)
                    
                        alert.addAction(UIAlertAction(title: "Abbrechen".localized, style: .Default, handler: { (alert) -> Void in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.dismissViewControllerAnimated(true, completion:nil)
                            }
                        }))
                    
                        alert.addAction(UIAlertAction(title: "Nochmal".localized, style: .Cancel, handler: { (alert) -> Void in
                            self.session.startRunning()
                        }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
            
        }
        
        self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        for subview in self.view.subviews {
            self.view.bringSubviewToFront(subview as! UIView)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil )
    }
}