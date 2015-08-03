
import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var actInd : UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    private let model = EventModel()
    
    private let textCellIdentifier = "EventsEntryCustomCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        model.fetchEvents(
            onCompletion:{ error in
                if(error != nil){
                    println("Error!");
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.actInd.stopAnimating();
                })
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCount() 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as? EventsCustomCell
        let event = model.getEvent(indexPath.row);
        
        // todo day, month, time
        cell!.configure(day: "04", month: "Aug", title: event.summery!, time: "10:00 - 12:00 Uhr", place: event.location);
        
        return cell!;
    }



}

