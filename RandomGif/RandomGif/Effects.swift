import Foundation
import BrightFutures

enum Effects<A> {
    typealias Action = A
    
    case Nothing
    case EffectTask(Task<Any, Action, NoError>)
    case Batch([Effects<Action>])
}

extension Effects {
    
    func append(effects: Effects<Action>) -> Effects<Action> {
        switch (self, effects) {
        case (.Nothing, _): return effects
        case (_, .Nothing): return self
        case (.EffectTask, .EffectTask): return .Batch([self, effects])
        case (.EffectTask, .Batch(let effectsArray)): return .Batch([self] + effectsArray)
        case (.Batch(let effectsArray), .EffectTask): return .Batch(effectsArray + [effects])
        case (.Batch(let effs1), .Batch(let effs2)): return .Batch(effs1 + effs2)
        default: fatalError("unhandled case")
        }
    }
    
    func map<U>(f: Action -> U) -> Effects<U> {
        switch self {
        case .Nothing: return .Nothing
        case .EffectTask(let task): return .EffectTask(task.map(f))
        case .Batch(let effects): return .Batch(effects.map { $0.map(f) })
        }
    }
}