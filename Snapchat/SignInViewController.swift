//
//  SIgnInViewController.swift
//  Snapchat
//
//  Created by janusz jas on 02.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func turnUpTapped(_ sender: Any) {
       FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("We tried to sign in")
        if error != nil {
            print("hey we have an error : \(error)")
            
            FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                print("we tried to create a user")
                
                if error != nil {
                    print("we have an error")
                }else {
                    print("created user successfully!")
                    self.performSegue(withIdentifier: "signinsegue", sender: nil)
                }
            })
        }else {
            print("signed in sucesfully")
            self.performSegue(withIdentifier: "signinsegue", sender: nil)
        }
        
       })
        
    }


}

