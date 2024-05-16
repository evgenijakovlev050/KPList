//
//  AppDelegate.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 13.03.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = AppCoordinator.createTabBarController()
//        //StorageManager.shared.deleteAllData("Film")
//        if let bundleID = Bundle.main.bundleIdentifier {
//            //UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
        //UserDefaults.standard.setValue(false, forKey: "wasAnyStatusChanged")
    }
}
