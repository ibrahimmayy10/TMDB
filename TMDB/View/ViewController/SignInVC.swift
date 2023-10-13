//
//  SignInVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func vcButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "toViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
