//
//  SignInVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 13.10.2023.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            let vc = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func signinButton(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != nil || password != nil {
            Auth.auth().signIn(withEmail: email ?? "", password: password ?? "") { authdata, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "")
                } else {
                    let vc = self.storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            makeAlert(messageInput: "Email veya şifre boş olamaz")
        }
    }
    
    func makeAlert (messageInput: String) {
        let alert = UIAlertController(title: "", message: messageInput, preferredStyle: .alert)
        let okButton = alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToRegisterButton(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(identifier: "toRegisterVC") as! RegisterVC
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
}
