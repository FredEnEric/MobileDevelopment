//
//  AppDelegate.swift
//  OmnomTracker
//
//  Created by Student on 03/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ShinobiCharts.trialKey = "dHNg-eFQM-VgAA-O3R1-ZS5f-B1dT" // <- Enter trial key here.

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeTab")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        //let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //print(urls[urls.count-1] as URL);
        
        //sqlite file:
        //sinasi: Users/sinasiyilmaz/Library/Developer/CoreSimulator/Devices/1A5AE22D-AB0D-4678-8DCD-09A8F3CC76AB/data/Containers/Data/Application/DA9BC3C2-8ECC-4091-91CE-F07040229EF8/
        // frederic: /Users/student/Library/Developer/CoreSimulator/Devices/8F7F6A22-9A79-412B-A6A6-9BA4CE1DD341/data/Containers/Data/Application/5F701644-A60E-48E3-BE8D-424DEEA9A1B4/
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DatabaseController.saveContext()
    }
}

