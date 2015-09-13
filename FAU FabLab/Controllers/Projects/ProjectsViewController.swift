import Foundation
import UIKit

class ProjectsViewController: UITableViewController {
    
    let cartHistoryModel = CartHistoryModel.sharedInstance
    let cartCustomCellIdentifier = "CartCustomCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cartCustomCellIdentifier) as? CartCustomCell
            let cart = cartHistoryModel.getCart(indexPath.row)
            cell!.configure(cart.date, count: cart.getCount(), status: cart.cartStatus)
            return cell!
        }
        return UITableViewCell()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return cartHistoryModel.getCount()
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Warenkörbe".localized
        }
        return nil
    }
    
}
