//
//  AppDelegate.swift
//  QantasMoneyChallenge
//
//  Created by Micah Napier on 14/12/19.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	private lazy var coordinator: AccountCoordinator = {
		let coordinator = AccountCoordinator()
		return coordinator
	}()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		window.rootViewController = coordinator.navigationController
		window.makeKeyAndVisible()
		return true
	}

}

