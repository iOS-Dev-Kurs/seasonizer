//
//  AppDelegate.swift
//  Seasonizer
//
//  Created by Nils Fischer on 19.06.15.
//  Copyright (c) 2015 Nils Fischer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let allAccessories = [
            Accessory(image: UIImage(named: "sunhat")!, title: "Sonnenhut"),
            Accessory(image: UIImage(named: "bikini")!, title: "Bikini"),
            Accessory(image: UIImage(named: "sunglasses")!, title: "Sonnenbrille"),
            Accessory(image: UIImage(named: "mustache")!, title: "Schnurrbart")
        ]
        if let canvasViewController = (window?.rootViewController as? UINavigationController)?.topViewController as? CanvasViewController {
            canvasViewController.allAccessories = allAccessories
        }
        return true
    }
    
    // MARK: State Preservation
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}
