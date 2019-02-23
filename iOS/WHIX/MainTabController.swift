//
//  FirstViewController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 23/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    var loggedIn: Bool = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        if !loggedIn {
            loggedIn = true
            print("showing login segue")
            performSegue(withIdentifier: "showLogin", sender: nil)
        }
    }

}

