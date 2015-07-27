
import UIKit
import AVFoundation
import RSBarcodes

class BarcodeViewController: RSCodeReaderViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Optional: Mark the found place
        self.focusMarkLayer.strokeColor = UIColor.greenColor().CGColor
        self.cornersLayer.strokeColor = UIColor.greenColor().CGColor
        
        
        //Barcode found, deal with it
        self.barcodesHandler = { barcodes in
            self.session.stopRunning()
            
            //show UI Alert
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let popupMessageView = UIAlertView(
                    title: "Barcode gescannt!",
                    message: "Barcode typ: " + barcodes[0].type + "  Wert: " + barcodes[0].stringValue,
                    delegate: nil,
                    cancelButtonTitle: "Toll")
                popupMessageView.show()
            })
        
        }
        
        //VALID BARCODE TYPES:  (Bin mir nicht sicher welche wir alles bruachen...)
        
        //Ignore some
        
        //let types = NSMutableArray(array: self.output.availableMetadataObjectTypes)
        //types.removeObject(AVMetadataObjectTypeQRCode)
        //self.output.metadataObjectTypes = NSArray(array: types) as [AnyObject]
        
        //OR  just add the needed once
        self.output.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode]
        
        
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
}