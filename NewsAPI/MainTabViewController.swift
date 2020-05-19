//
//  MainTabViewController.swift
//  NewsAPI
//
//  Created by M'haimdat omar on 24-12-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .systemFill
        setupTabBar()
        
    }
    
    func setupTabBar() {
        
        let AccueilController = UINavigationController(rootViewController: ViewController())
        AccueilController.tabBarItem.image = UIImage(named: "accueil_glyph")
        AccueilController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        AccueilController.tabBarItem.title = "Positive News"
        
        viewControllers = [AccueilController]
        
        UITabBar.appearance().tintColor = .green
    }

}
