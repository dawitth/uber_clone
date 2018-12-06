//
//  ViewController.swift
//  Uber
//
//  Created by Dawit Hunegnaw on 2018-11-30.
//  Copyright © 2018 Dawit Hunegnaw. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var riderLable: UILabel!
    @IBOutlet weak var driverLable: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    
    
    @IBOutlet weak var topButton: UIButton!
    
    
    @IBOutlet weak var bottomButtom: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    var signUpMode = true;
    
    @IBAction func topTapped(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing information", message: "You must provide both email and password")
            
        } else {
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    
                    if signUpMode {
                        // Sign UP
                        Auth.auth().createUser(withEmail: email, password: password, completion: {
                            (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                
                                if self.riderDriverSwitch.isOn{
                                    // Driver
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                     self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                    
                                } else {
                                    // RIDER
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                            }
                        })
                    } else {
                        // Login
                        Auth.auth().signIn(withEmail: email, password: password, completion: ({ (user, error) in
                            
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                
                                
                                if user?.user.displayName == "Driver" {
                                    //Drievr
                                     self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                } else {
                                    // Rider
                                   self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                                
                            }
                            
                        }))
                    }
                    
                }
            }
            
        }
    }
    
    func displayAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
           topButton.setTitle("Log in", for: .normal)
           bottomButtom.setTitle("Switch to Sign Up", for: .normal)
           riderLable.isHidden = true;
           driverLable.isHidden = true;
            riderDriverSwitch.isHidden = true;
            signUpMode = false;
            
        } else {
            topButton.setTitle("Signup", for: .normal)
            bottomButtom.setTitle("Switch to Log in", for: .normal)
            riderLable.isHidden = false;
            driverLable.isHidden = false;
            riderDriverSwitch.isHidden = false;
            signUpMode = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

