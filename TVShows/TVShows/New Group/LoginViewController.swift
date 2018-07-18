//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 13/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class LoginViewController: UIViewController {
    
    private var rememberME: Bool = false
    
    private var _user: User? = nil
    
    private var _loginUser: LoginUser? = nil

    @IBOutlet weak var checkboxButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        _loginUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        
    }
    
    func pushHomeView() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navigationController?.pushViewController(homeViewController, animated:
            true)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            _registerUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    private func _registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let user):
                    self!._user = user
                    self!._loginUserWith(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<LoginUser>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let loginUser):
                    self!._loginUser = loginUser
                    self!.pushHomeView()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
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
