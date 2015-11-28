//
//  Couter.swift
//  Counter
//
//  Created by Алексей Демедецкий on 20.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import Foundation

struct Counter {
    
    typealias State = Int
    
    enum Action {
        case Increment, Decrement
    }
    
    static func update(state: State, action: Action) -> State {
        switch action {
        case .Increment : return state + 1
        case .Decrement : return state - 1
        }
    }
    
    typealias Dispatch = Action -> ()
    
 }