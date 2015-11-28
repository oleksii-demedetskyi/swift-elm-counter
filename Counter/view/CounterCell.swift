//
//  CounterCell.swift
//  Counter
//
//  Created by Алексей Демедецкий on 28.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import UIKit

class CounterCell : UITableViewCell {
    var state : Counter.State? { didSet { render() } }
    
    override func prepareForReuse() {
        state = nil
        dispatch = nil
    }
    
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