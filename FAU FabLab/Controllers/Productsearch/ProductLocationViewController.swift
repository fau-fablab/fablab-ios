import Foundation
import UIKit

class ProductLocationViewController : UIViewController{
    var locationId: String!
    var productName: String!
    
    
    @IBOutlet weak var headline: UINavigationItem!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headline.title = productName
        let url = NSURL (string: RestManager.sharedInstance.devApiUrl + "/productMap/productMap.html?id=" + locationId);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
    
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
   
}
