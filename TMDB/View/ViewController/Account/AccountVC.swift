//
//  AccountVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import UIKit
import Firebase

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let signinVC = storyboard?.instantiateViewController(identifier: "toSigninVC") as! SignInVC
            navigationController?.pushViewController(signinVC, animated: true)
        } catch {
            print("error")
        }
    }
    
    @IBAction func homePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func upcomingButton(_ sender: Any) {
        let upcomingVC = storyboard?.instantiateViewController(identifier: "toUpcomingVC") as! UpcomingVC
        navigationController?.pushViewController(upcomingVC, animated: false)
    }
    
}
