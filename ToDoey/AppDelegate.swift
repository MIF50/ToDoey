//
//  AppDelegate.swift
//  ToDoey
//
//  Created by BeInMedia on 6/25/19.
//  Copyright © 2019 MIF50. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        
        do {
            try Realm().write {
                
            }
        } catch {
            print("Error initalize realm ")
        }
        
        return true
    }
}

