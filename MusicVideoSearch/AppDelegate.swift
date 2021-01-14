//
//  AppDelegate.swift
//  MusicVideoSearch
//
//  Created by 윤새결 on 2021/01/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if let navigation = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UINavigationController,
       let viewController = navigation.topViewController as? ViewController {
      let apiClient = APIClient.shared
      let searchService = SearchService(client: apiClient)
      let reactor = ViewControllerReactor(service: searchService)
      viewController.reactor = reactor
      self.window?.rootViewController = navigation
      self.window?.makeKeyAndVisible()
    }
    return true
  }
}

