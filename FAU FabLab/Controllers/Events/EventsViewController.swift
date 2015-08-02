//
//  EventsViewController.swift
//  FAU FabLab
//
//  Created by Max Jalowski on 09.07.15.
//  Copyright (c) 2015 FAU MAD FabLab. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var tableView: UITableView!
    private let model = EventModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        model.fetchEvents(onCompletion: { error in
            if(error != nil){
                println("Error!");
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let event = model.getEvent(indexPath.row)
    
        cell.textLabel?.text = event.summery
        cell.detailTextLabel?.text = event.url
        
        return cell
    }



}

