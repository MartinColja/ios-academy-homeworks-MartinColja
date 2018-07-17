//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 13/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    private var rememberME: Bool = false

    @IBOutlet weak var checkboxButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")

        navigationController?.pushViewController(homeViewController, animated:
            true)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navigationController?.pushViewController(homeViewController, animated:
            true)
        
    }
    
    @IBAction func checkboxButtonToggle(_ sender: Any) {
        
        rememberME = !rememberME
        if ( rememberME ) {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
