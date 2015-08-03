import UIKit
import Foundation

class CheckoutViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func checkoutCodeScanned(notification:NSNotification) {
        println("Got Notification from Scanner, code: \(notification.object)")
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        return cell;
    }
}