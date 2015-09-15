
import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var actInd : UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    private let model = EventModel()
    
    private let textCellIdentifier = "EventsEntryCustomCell"
    
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.fabLabBlueSeperator()
        
        actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleWidth |
            UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleBottomMargin
        actInd.startAnimating()
        view.addSubview(actInd)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doorButtonController.setViewController(self)
        cartButtonController.setViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        model.fetchEvents(
            onCompletion:{ error in
                if(error != nil){
                    Debug.instance.log("Error!");
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.actInd.stopAnimating();
                })
            }
        )
        
        // needed to remove past events
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "EventsDetailSegue" {
            let destination = segue.destinationViewController as? EventsDetailsViewController
            
            let event = model.getEvent(tableView.indexPathForSelectedRow()!.row);
            
            destination!.configure(event)
        }
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCount() 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as? EventsCustomCell
        let event = model.getEvent(indexPath.row);

        var time = ""
        if event.isOneDay {
            if event.allday == true {
                time = "ganztägig".localized
            } else {
                if event.startTimeString == event.endTimeString {
                    time = "ab".localized + " " + event.startTimeString + " " + "Uhr".localized
                } else {
                    time = event.startTimeString + " - " + event.endTimeString + " " + "Uhr".localized
                }
            }
        } else {
            if event.allday == true {
                time = "ganztägig bis".localized + " " + event.endDayString + ". " + event.endMonthString
            } else {
                time = event.startTimeString + " - "
                    + event.endDayString + ". " + event.endMonthString + ", "
                    + event.endTimeString + " " + "Uhr".localized
            }
        }
        
        // configure cell
        cell!.configure(today: event.isToday, now: event.isNow, day: event.startDayString, month: event.startMonthString, title: event.summery!, time: time, place: event.location, dateColor: event.getCustomColor);
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

