//
//  CounterListViewController.swift
//  Counter
//
//  Created by Алексей Демедецкий on 28.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import UIKit

class CounterListViewController : UITableViewController {
    var state : CounterList.State? { didSet { render() } }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    func render() {
        self.tableView.reloadData()
    }
    
    var dispatch : CounterList.Dispatch?
}

class CounterCell : UITableViewCell {
    var state : Counter.State? { didSet { render() } }
    
    @IBOutlet var value : UILabel!
    
    func render() {
        value.text = state.map { String($0) } ?? "#"
    }
    
    var dispatch : Counter.Dispatch?
    
    @IBAction func increment() {
        dispatch?(.Increment)
    }
    
    @IBAction func decrement() {
        dispatch?(.Decrement)
    }
}

extension CounterListViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("counter cell") as! CounterCell
        
        cell.state = state?[indexPath.row]
        cell.dispatch = { act in
            self.dispatch?(.UpdateCounter(index: indexPath.row, action: act))
        }
        
        return cell
    }
}