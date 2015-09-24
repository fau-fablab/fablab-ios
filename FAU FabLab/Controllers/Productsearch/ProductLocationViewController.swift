import Foundation
import UIKit

class ProductLocationViewController : UIViewController {
    
    var locationId: String?
    var productName: String?
    
    let model = ProductLocationModel.sharedInstance
    
    @IBOutlet weak var webView: UIWebView!
    
    func configure(id id: String, name: String){
        print(locationId)
        locationId = "\(id)"
        productName = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = productName
        
        let url = model.getLocalFileUrl(locationId!)
        
        if(url != nil){
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
        }else{
            AlertView.showInfoView("Error", message: "Fehler beim Laden der Karte aufgetreten")
        }
    }
}
