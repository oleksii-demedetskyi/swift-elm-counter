import Foundation
import BrightFutures

struct RandomGif {
    
    struct State {
        var imageData: NSData?
        var requestCounter = 0
    }
    
    enum Action {
        case RequestMore, NewGif(NSData?), Error(ErrorType)
    }
    
    static func update(state: State, action: Action) -> (State, Effects<Action>) {
        var state = state
        var effects: Effects<Action> = .Nothing
        
        switch action {
        case .RequestMore:
            state.requestCounter += 1
            let task = getRandomGif().then({ (v) -> Task<NSURLSession, Action, NoError> in
                return Task<NSURLSession, Action, NoError>(execute: { _ -> Future<Action, NoError>  in
                    switch v {
                    case .Success(let data):
                        return Future<Action, NoError>(value: .NewGif(data))
                    case .Failure(let error):
                        return Future<Action, NoError>(value: .Error(error))
                    }
                })
            })
            let effect: Effects<Action> = Effects<Action>.EffectTask(task)
            effects.append(effect)
            
        case .NewGif(let data):
            state.requestCounter -= 1
            state.imageData = data
            
        case .Error:
            state.requestCounter -= 1
            // errors not handled in anyway currently
        }
        
        return (state, effects)
    }
    
    static func getRandomGif() -> Task<NSURLSession, NSData?, HTTPError> {
        let requestGifs = NSURLRequest(URL: NSURL(string: "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat")!)
        let gifsTask = HTTPTask(requestGifs).map({ (d: NSData?) -> NSURLRequest in
            guard let data = d else { fatalError("got nothing from server :(") }
            
            let serializedData = try! NSJSONSerialization.JSONObjectWithData(data, options: [.MutableContainers]) as! [String: AnyObject]
            guard let gifInfo = serializedData["data"] as? [String: String] else { fatalError("Invalid data format") }
            let gifString = gifInfo["image_url"]!
            
            return NSURLRequest(URL: NSURL(string: gifString)!)
        }).flatMap(HTTPTask)
        
        return gifsTask
    }
    
    enum HTTPError: ErrorType, TaskFailureWrap {
        case WrapError(ErrorType)
        case RequestError(ErrorType?)
        
        init(error: ErrorType) {
            self = .WrapError(error)
        }
    }
    
    static func HTTPTask(request: NSURLRequest) -> Task<NSURLSession, NSData?, HTTPError> {
        let task = Task<NSURLSession, NSData?, HTTPError> { (service) -> Future<NSData?, HTTPError> in
            let promise = Promise<NSData?, HTTPError>()
            
            service.dataTaskWithRequest(request, completionHandler: { data, response, error in
                guard let response = response as? NSHTTPURLResponse else {
                    promise.failure(.RequestError(nil))
                    return
                }
                
                if (200..<300).contains(response.statusCode) {
                    promise.success(data)
                } else {
                    promise.failure(.RequestError(error))
                }
            }).resume()
            
            return promise.future
        }
        
        return task
    }
}