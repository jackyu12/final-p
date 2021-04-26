//
//  ViewController.swift
//  uber
//
//  Created by Jack Yu on 4/25/21.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var driverL: UILabel!
    @IBOutlet weak var riderL: UILabel!
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rdswitch: UISwitch!
    @IBOutlet weak var topB: UIButton!
    @IBOutlet weak var buttomB: UIButton!
    var signUpmode = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func topTapped(_ sender: Any) {
        if emailtext.text == "" || password.text==""{
            displayAlert(title: "Missing info", message: "You must provide email and password")
        } else {
            if let email = emailtext.text{
                if let password1 = password.text{
                    if signUpmode {
                        
                        Auth.auth().createUser(withEmail: email, password: password1, completion: {(user,error) in
                            if error != nil{
                                self.displayAlert(title: "error", message: error!.localizedDescription)
                            }else{
                                print("sign up success")
                                
                                if self.rdswitch.isOn{
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Driver"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverseg", sender: nil)
                                }else{
                                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                                    req?.displayName = "Rider"
                                    req?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                            }
                        })
                    }else{
                        //log in
                        Auth.auth().signIn(withEmail: email, password: password1, completion: { (user,error) in
                            if error != nil{
                                self.displayAlert(title: "error", message: error!.localizedDescription)
                            }else{
                            
                                
                                self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                            
                        })
                        
                    }
                }
            }
            
        }
    }
    func displayAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttomTap(_ sender: Any) {
        if signUpmode {
            topB.setTitle("Log in", for: .normal)
            buttomB.setTitle("switch to sign up", for: .normal)
            riderL.isHidden = true
            driverL.isHidden = true
            rdswitch.isHidden = true
            signUpmode = false
        } else {
            topB.setTitle("Log in", for: .normal)
            buttomB.setTitle("switch to sign up", for: .normal)
            riderL.isHidden = false
            driverL.isHidden = false
            rdswitch.isHidden = false
            signUpmode = true
            
        }
    }
}

