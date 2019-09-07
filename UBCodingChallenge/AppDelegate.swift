//
//  AppDelegate.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let searchPhotos = SearchPhotosRouter.createSearchPhotosModule(apiService: FlickrApiService())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = searchPhotos
        window?.makeKeyAndVisible()
        return true
    }
}

