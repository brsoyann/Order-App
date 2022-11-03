//
//  SceneDelegate.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 26.10.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var orderTapBarItem: UITabBarItem!

    @objc
    func updateOrderBadge() {
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTapBarItem.badgeValue = nil
        case let count:
            orderTapBarItem.badgeValue = String(count)
        }
    }

    var window: UIWindow?

    // MARK: - LifeCycle
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard (scene as? UIWindowScene) != nil else { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateOrderBadge),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )

        orderTapBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
