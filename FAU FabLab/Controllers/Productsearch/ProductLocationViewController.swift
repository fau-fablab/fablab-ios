import Foundation
import UIKit

class ProductLocationViewController : UIViewController {
    
    var locationId: String?
    var productName: String?
    
    @IBOutlet weak var webView: UIWebView!
    
    func configure(#id: String, name: String){
        println(locationId)
        locationId = "\(id)"
        productName = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = productName
        
        let url = NSURL (string: RestManager.sharedInstance.devApiUrl + "/productMap/productMap.html?id=" + locationId!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
   
}
