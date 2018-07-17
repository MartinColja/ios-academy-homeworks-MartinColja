//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 13/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var rememberME: Bool = false
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
    
    override func viewDidLayoutSubviews() {
        underlineUsernameTextField()
        underlinePasswordTextField()
    }
    
    func underlineUsernameTextField() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: usernameTextField.frame.size.height - width + 1, width: usernameTextField.frame.size.width, height: usernameTextField.frame.size.height)
        
        border.borderWidth = width
        usernameTextField.layer.addSublayer(border)
        usernameTextField.layer.masksToBounds = true
    }
    
    func underlinePasswordTextField() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - width + 1, width: passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        
        border.borderWidth = width
        passwordTextField.layer.addSublayer(border)
        passwordTextField.layer.masksToBounds = true
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
