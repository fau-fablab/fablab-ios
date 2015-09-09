import Foundation


class InventoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var tableViewCellIdentifier = "InventoryListCell"
    var items : [InventoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        spinner.startAnimating()
        let api = InventoryApi()
        api.getAll({
            items, err in
            if(err != nil){
                println(err)
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
        var alert = UIAlertController(title: "Löschen?", message: "Möchtest du die gesamte Liste löschen?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: { (action: UIAlertAction!) in
            self.spinner.startAnimating()
            
            var login = InventoryLogin()
            let api = InventoryApi()
            api.deleteAll(login.getUser(), onCompletion:{
                items, err in
                if(err != nil){
                    println(err)
                }else{
                    self.items = []
                    self.tableView.reloadData()
                }
                self.spinner.stopAnimating()
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Doch nicht", style: .Default, handler: { (action: UIAlertAction!) in
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
       
        var cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! InventoryListCell
        cell.configure(items[indexPath.row])
        return cell
    
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Inventur".localized
    }

}