//
//  CounterList.swift
//  Counter
//
//  Created by Алексей Демедецкий on 28.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import Foundation

struct CounterList {
    
    typealias State = [Counter.State]
    
    enum Action {
        case UpdateCounter(index : Int, action: Counter.Action)
    }
    
    static func update(var state: State, action: Action) -> State {
        switch action {
        case let .UpdateCounter(index, act) :
            state[index] = Counter.update(state[index], action: act)
        }
        
        return state
    }
    
    typealias Dispatch = Action -> ()
}