//
//  AppDelegate.swift
//  Counter
//
//  Created by Алексей Демедецкий on 20.11.15.
//  Copyright © 2015 DAloG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let nvc = window?.rootViewController as! UINavigationController
        let vc = nvc.topViewController as! CounterListViewController
        
        vc.state = []
        vc.dispatch = { [unowned vc] action in
            vc.state = CounterList.update(vc.state!, action: action)
        }
        
        return true
    }
}

