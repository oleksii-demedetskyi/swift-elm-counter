import Foundation
import BrightFutures
import Result

protocol TaskFailureWrap {
    init(error: ErrorType)
}

struct Task<T, S, E: ErrorType> {
    
    let execute: T -> Future<S, E>
    
    func map<U>(f: S -> U) -> Task<T, U, E> {
        
        return Task<T, U, E> { v in
            return self.execute(v).map(f)
        }
    }
    
    func mapError<E1: ErrorType>(f: E -> E1) -> Task<T, S, E1> {
        return Task<T, S, E1> { v in
            return self.execute(v).mapError(f)
        }
    }
    
    func flatMap<U, E1: TaskFailureWrap>(f: S -> Task<T, U, E1>) -> Task<T, U, E1> {
        return Task<T, U, E1> { input in
            let promise = Promise<U, E1>()
            
            let future = self.execute(input)
            future.onComplete { (v) -> Void in
                switch v {
                case .Success(let t):
                    let task = f(t)
                    task.execute(input).onComplete {
                        switch $0 {
                        case .Success(let value):
                            promise.success(value)
                        case .Failure(let error):
                            promise.failure(error)
                        }
                    }
                case .Failure(let error):
                    promise.failure(E1(error: error))
                }
            }
            
            return promise.future
        }
    }
    
    func then<U, E1: ErrorType>(f: Result<S, E> -> Task<T, U, E1>) -> Task<T, U, E1> {
        return Task<T, U, E1> { input in
            let promise = Promise<U, E1>()
            
            let future = self.execute(input)
            future.onComplete { (v) -> Void in
                let task = f(v)
                task.execute(input).onComplete {
                    switch $0 {
                    case .Success(let value):
                        promise.success(value)
                    case .Failure(let error):
                        promise.failure(error)
                    }
                }
            }
            
            return promise.future
        }
    }
}