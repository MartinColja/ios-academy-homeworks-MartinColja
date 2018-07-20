import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

class LoginViewController: UIViewController {
    
    private var rememberME: Bool = false
    
    private var _user: User? = nil
    
    private var _loginUser: LoginUser? = nil

    @IBOutlet weak var checkboxButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //happens on "log in" button click
    @IBAction func loginButtonPressed(_ sender: Any) {
        _loginUserWith(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    //happens on "create account" button click
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            _registerUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    //communicates with register user api
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
                    break
                case .failure(let error):
                    
                    
                    let message : String
                    if let httpStatusCode = dataResponse.response?.statusCode {
                        switch(httpStatusCode) {
                        case 400:
                            message = "Correct email or password not provided."
                        case 401:
                            message = "Incorrect email or password."
                        case 422:
                            message = "Correct email or password not provided."
                        default:
                            message = error.localizedDescription
                        }
                    } else {
                        message = error.localizedDescription
                    }
                    
                    print("API failure: \(error.localizedDescription)")
                    SVProgressHUD.showInfo(withStatus: message)
                    break
                }
        }
    }
    
    //communicates with login user api
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
                    self!._pushHomeView()
                    break
                case .failure(let error):
                    let message : String
                    if let httpStatusCode = dataResponse.response?.statusCode {
                        switch(httpStatusCode) {
                        case 400:
                            message = "Correct email or password not provided."
                        case 401:
                            message = "Incorrect email or password."
                        case 422:
                            message = "Correct email or password not provided."
                        default:
                            message = error.localizedDescription
                        }
                    } else {
                        message = error.localizedDescription
                    }
                    
                    print("API failure: \(error.localizedDescription)")
                    SVProgressHUD.showInfo(withStatus: message)
                    break
                }
        }
    }
    
    //connects this controller to HomeViewController
    private func _pushHomeView() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        navigationController?.pushViewController(homeViewController, animated:
            true)
    }
    
    //happens on "remember me" button click
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
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
