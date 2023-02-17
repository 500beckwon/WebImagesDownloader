//
//  AppDelegate.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/02/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ImageDownloadViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

