//
//  AppDelegate.swift
//  Todoey
//
//  Created by Taiwo on 22/01/2018.
//  Copyright © 2018 Taiwo. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
        } catch {
            print ("An error occurred initialising realm: \(error)")
        }

        return true
    }
}

