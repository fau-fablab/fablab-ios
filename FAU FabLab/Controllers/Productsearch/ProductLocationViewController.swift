import Foundation
import UIKit

class ProductLocationViewController : UIViewController{
    var locationId: String!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: RestManager.sharedInstance.devApiUrl + "/productMap?id=" + locationId);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
    
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
   
}
