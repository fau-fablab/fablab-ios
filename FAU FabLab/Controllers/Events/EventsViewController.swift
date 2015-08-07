
import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var actInd : UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    private let model = EventModel()
    
    private let textCellIdentifier = "EventsEntryCustomCell"
    
    private let doorButtonController = DoorNavigationButtonController()

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
        
        doorButtonController.updateButtons(self)
    }
        
    func showText() {
        doorButtonController.showText(self)
    }
    
    func showButton() {
        doorButtonController.showButton(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            
            destination!.configure(title: event.summery!, start: event.startDateString, end: event.endDateString, location: event.location, description: event.description)
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
                time = "ganztägig"
            } else {
                time = event.startTimeString + " - " + event.endTimeString + " Uhr"
            }
        } else {
            if event.allday == true {
                time = "ganztägig bis " + event.endDayString + ". " + event.endMonthString
            } else {
                time = event.startTimeString + " - "
                    + event.endDayString + ". " + event.endMonthString + ", "
                    + event.endTimeString + " Uhr"
            }
        }
        
        // configure cell
        cell!.configure(today: event.isToday, day: event.startDayString, month: event.startMonthString, title: event.summery!, time: time, place: event.location);
        
        return cell!;
    }
    


}

