//
//  FirstViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate = self
        
        if UserDefaults.standard.string(forKey: "loggedInUserId") == nil {
            print("not logged in, showing login segue")
            performSegue(withIdentifier: "showLogin", sender: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "NEW" {
            performSegue(withIdentifier: "showCamView", sender: nil)
            return false
        }
        
        return true
    }

}

