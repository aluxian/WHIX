//
//  ProfileController.swift
//  WHIX
//
//  Created by Alexandru Rosianu on 24/02/2019.
//  Copyright © 2019 WHIX. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            // logout
            UserDefaults.standard.set(nil, forKey: "loggedInUserId")
            UserDefaults.standard.set(nil, forKey: "loggedInUsername")
            
            tabBarController!.performSegue(withIdentifier: "showLogin", sender: nil)
            tabBarController!.selectedIndex = 0
        }
    }
    
}
