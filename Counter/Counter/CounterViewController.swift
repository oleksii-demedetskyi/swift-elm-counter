//
//  ViewController.swift
//  Counter
//
//  Created by Алексей Демедецкий on 20.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var state : Counter.State? { didSet { render() } }
    
    func render() {
        if let state = state {
            renderState(state)
        } else {
            renderNoState()
        }
    }
    
    func renderState(state: Counter.State) {
        value?.text = String(state)
    }
    
    func renderNoState() {
        value?.text = "#"
    }
    
    
    @IBOutlet var value : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    var dispatch : Counter.Dispatch?
    
    @IBAction func increment() {
        dispatch?(.Increment)
    }
    
    @IBAction func decrement() {
        dispatch?(.Decrement)
    }
    
}

