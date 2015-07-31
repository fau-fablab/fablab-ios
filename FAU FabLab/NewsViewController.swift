import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var actInd : UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!

    let textCellIdentifier = "NewsEntryCustomCell"

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
        newsMgr.getNews(
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            },
            onCompletion:{
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let row = indexPath.row;
        println("Clicked ! ")
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier)
        if segue.identifier == "NewsDetailSegue" {
            let destination = segue.destinationViewController as? NewsDetailsViewController
            let selectedRow = tableView.indexPathForSelectedRow()!.row

            let title = newsMgr.news[selectedRow].title;
            let description = newsMgr.news[selectedRow].description;
            let image = newsMgr.news[selectedRow].imageLink;

            destination!.configure(title, desc:description, imageLink: image)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsMgr.getCount();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as? NewsCustomCell
        let row = indexPath.row
        cell!.configure(newsMgr.news[row].title, description:newsMgr.news[row].description, image:newsMgr.news[row].imageLink)
        //cell!.detailTextLabel?.text = newsMgr.news[row].description
        return cell!;
    }
}

