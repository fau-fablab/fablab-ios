import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view!.frame)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view?.addSubview(self.tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        newsMgr.getNews({
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = newsMgr.getCount();
        return count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "NewsEntryCell"

        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell

        if(nil == cell){
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        cell!.textLabel?.text = newsMgr.news[indexPath.row].title
        cell!.detailTextLabel?.text = newsMgr.news[indexPath.row].description

        return cell!;
    }
}

