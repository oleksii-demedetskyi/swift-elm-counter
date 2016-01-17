import Foundation
import BrightFutures

class Store<State, Action> {
    
    private var state: State
    private var update: (State, Action) -> (State, Effects<Action>)
    
    private var urlSession = NSURLSession.sharedSession()
    
    init(initialState: State, effects: Effects<Action> = .Nothing, update: (State, Action) -> (State, Effects<Action>)) {
        dump(initialState)
        dump(effects)
        print("\n===================\n")
        
        state = initialState
        self.update = update
        
        dispatchEffects(effects)
    }
    
    private let queue = dispatch_queue_create("com.Store", DISPATCH_QUEUE_SERIAL)
    
    private func dispatch(action: Action) {
        dispatch_async(queue) {
            let (state, effects) = self.update(self.state, action)
            
            self.state = state
            
            dump(action)
            dump(self.state)
            dump(effects)
            print("\n===================\n")
            
            self.dispatchEffects(effects)
        }
    }
    
    private func dispatchEffects(effects: Effects<Action>) {
        dispatch_async(queue) {
            switch effects {
                
            case .Nothing: break
                
            case .EffectTask(let task):
                switch task {
                case let t as Task<(), Action, NoError>: t.map(self.dispatch).execute()
                case let t as Task<NSURLSession, Action, NoError>: t.map(self.dispatch).execute(self.urlSession)
                default: fatalError("Can't handle task")
                }
                
            case .Batch(let effects):
                effects.forEach(self.dispatchEffects)
            }
        }
    }
}