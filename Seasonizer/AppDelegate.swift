//
//  AppDelegate.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit
import Evergreen

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Evergreen.log("Hello World!")
        if let canvasViewController = (window?.rootViewController as? UINavigationController)?.topViewController as? CanvasViewController {
            canvasViewController.allAccessories = [ Accessory(image: UIImage(named: "sunhat")!, title: "Sonnenhut"), Accessory(image: UIImage(named: "bikini")!, title: "Bikini"), Accessory(image: UIImage(named: "sunglasses")!, title: "Sonnenbrille"), Accessory(image: UIImage(named: "mustache")!, title: "Schnurrbart") ]
        }
        return true
    }
    
    // MARK: State Preservation
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

