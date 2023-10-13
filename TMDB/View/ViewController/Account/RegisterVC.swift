//
//  RegisterVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 13.10.2023.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
    }

    @IBAction func kayitOlButton(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != nil || password != nil {
            Auth.auth().createUser(withEmail: email ?? "", password: password ?? "") { authdata, error in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "")
                } else {
                    let signinVC = self.storyboard?.instantiateViewController(identifier: "toSigninVC") as! SignInVC
                    self.navigationController?.pushViewController(signinVC, animated: true)
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
    
    @IBAction func goToSinginButton(_ sender: Any) {
    }
    
}
