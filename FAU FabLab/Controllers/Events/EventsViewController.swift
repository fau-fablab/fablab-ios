
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier)
        if segue.identifier == "EventsDetailSegue" {
            let destination = segue.destinationViewController as? EventsDetailsViewController
            
            let event = model.getEvent(tableView.indexPathForSelectedRow()!.row);
            
            let start = getDateStringFromDate(event.getStartAsDate())
            let end = getDateStringFromDate(event.getEndAsDate())
            
            destination!.configure(title: event.summery!, start: start, end: end, location: event.location, description: event.description)
        }
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCount() 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as? EventsCustomCell
        let event = model.getEvent(indexPath.row);
        
        let startDate = event.getStartAsDate()
        let day = getDayFromDate(startDate)
        let month = getMonthFromDate(startDate)
        
        var today = false
        if sameDay(startDate, date2: NSDate()) {
            today = true
        }
        
        let endDate = event.getEndAsDate()
        var time = ""
        if sameDay(startDate, date2: endDate) {
            time = getTimeFromDate(startDate) + " - " + getTimeFromDate(event.getEndAsDate()) + " Uhr"
        } else {
            time = getTimeFromDate(startDate) + " - "
                + getDayFromDate(endDate) + ". " + getMonthFromDate(endDate) + ", "
                + getTimeFromDate(event.getEndAsDate()) + " Uhr"
        }
        
        // configure cell
        cell!.configure(today: today, day: day, month: month, title: event.summery!, time: time, place: event.location);
        
        return cell!;
    }

    func getDateFormatter(format: String) -> NSDateFormatter {
        var dateFmt = NSDateFormatter()
        //dateFmt.timeZone = NSTimeZone.systemTimeZone()
        dateFmt.timeZone = NSTimeZone(name: "UTC+2")
        dateFmt.dateFormat = format
        return dateFmt
    }
    
    func getDayFromDate(date: NSDate) -> String {
        return getDateFormatter("dd").stringFromDate(date)
    }
    
    func getMonthFromDate(date: NSDate) -> String {
        return getDateFormatter("MMM").stringFromDate(date)
    }
    
    func getYearFromDate(date: NSDate) -> String {
        return getDateFormatter("yyyy").stringFromDate(date)
    }
    
    func getTimeFromDate(date: NSDate) -> String {
        return getDateFormatter("HH:mm").stringFromDate(date)
    }
    
    func getDateStringFromDate(date: NSDate) -> String {
        return getDateFormatter("dd.MM.yyy - HH:mm").stringFromDate(date)
    }
    
    func sameDay(date1: NSDate, date2: NSDate) -> Bool {
        if (getDayFromDate(date1) == getDayFromDate(date2))
            && (getMonthFromDate(date1) == getMonthFromDate(date2))
            && (getYearFromDate(date1) == getYearFromDate(date2)) {
            return true
        } else {
            return false
        }
    }

}

