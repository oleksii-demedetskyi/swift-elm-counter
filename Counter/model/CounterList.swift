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
        case Add
        case Delete(index: Int)
    }
    
    static func update(var state: State, action: Action) -> State {
        switch action {
            
        case let .UpdateCounter(index, act) :
            state[index] = Counter.update(state[index], action: act)
            
        case .Add :
            state.append(Counter.State(0))
            
        case .Delete(let index) :
            state.removeAtIndex(index)
            
        }
        
        return state
    }
    
    typealias Dispatch = Action -> ()
}