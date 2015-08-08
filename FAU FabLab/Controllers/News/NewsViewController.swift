import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var actInd : UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!

    private let textCellIdentifier = "NewsEntryCustomCell"
    private let model = NewsModel()
    
    private let doorButtonController = DoorNavigationButtonController.sharedInstance

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
        
        model.fetchNews(
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "NewsDetailSegue" {
            let destination = segue.destinationViewController as? NewsDetailsViewController

            let news = model.getNews(tableView.indexPathForSelectedRow()!.row);
            destination!.configure(title: news.title!, desc:news.description!, imageLink: news.linkToPreviewImage, link: news.link!)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getCount();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as? NewsCustomCell
        let news = model.getNews(indexPath.row);

        cell!.configure(title: news.title!, description: news.descriptionShort!, image: news.linkToPreviewImage)

        return cell!;
    }
}

