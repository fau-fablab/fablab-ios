import Foundation


class InventoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var tableViewCellIdentifier = "InventoryListCell"
    var items : [InventoryItem] = []
    let inventoryApi = InventoryApi()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        spinner.startAnimating()
        
        inventoryApi.getAll({
            items, err in
            if(err != nil){
                print(err)
            }else{
                self.items = items!
                self.tableView.reloadData()
            }
            self.spinner.stopAnimating()
        })

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        spinner.stopAnimating()
    }
    
    
    
    @IBAction func deleteListButtonTouched(sender: AnyObject) {
        let alert = UIAlertController(title: "Löschen?".localized, message: "Möchtest du die gesamte Liste löschen?".localized, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ja".localized, style: .Default, handler: { (action: UIAlertAction) in
            self.spinner.startAnimating()
            
            let login = InventoryLoginModel()
            self.inventoryApi.deleteAll(login.getUser(), onCompletion:{
                items, err in
                if(err != nil){
                    print(err)
                }else{
                    self.items = []
                    self.tableView.reloadData()
                }
                self.spinner.stopAnimating()
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Doch nicht".localized, style: .Default, handler: { (action: UIAlertAction) in
        }))
        
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! InventoryListCell
        cell.configure(items[indexPath.row])
        return cell
    
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Inventur".localized
    }

}