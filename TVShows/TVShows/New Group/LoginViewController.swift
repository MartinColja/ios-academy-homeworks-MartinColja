import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import UIView_Shake
import Locksmith

class LoginViewController: UIViewController {

    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet private var _outerView: UIView!
    
    private var _rememberME: Bool = false
    private var _user: User?
    private var _loginUser: LoginUser?
    private var _defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _loginUserFromMemory()
    }
    
    //happens on "log in" button click
    @IBAction func loginButtonPressed(_ sender: Any) {
        _loginUserWith(email: emailTextField.text!, password: passwordTextField.text!, fromMemory: false)
    }
    
    //happens on "create account" button click
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            _registerUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    //happens on "remember me" button click
    @IBAction func checkboxButtonToggle(_ sender: Any) {
        
        _rememberME = !_rememberME
        let imageName = _rememberME == true ? "ic-checkbox-filled" : "ic-checkbox-empty"
        checkboxButton.setImage(UIImage(named: imageName), for: .normal)
        
    }
    
    private func _loginUserFromMemory() -> () {
        let rememberMe = _defaults.bool(forKey: "remember-me")
        if rememberMe {
            guard let email = _defaults.string(forKey: "last-user") else {
                print("nema saveanog mejla")
                return
            }
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: email)
            let password = dictionary!["password"] as! String
            _loginUserWith(email: email, password: password, fromMemory: true)
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
                    self?._user = user
                    self?._loginUserWith(email: email, password: password, fromMemory: false)
                    break
                case .failure(let error):
                    self?._handleError(withDataResponse: dataResponse, andError: error)
                    break
                }
        }
    }
    
    //communicates with login user api
    private func _loginUserWith(email: String, password: String, fromMemory: Bool) {
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
                    self?._loginUser = loginUser
                    self?._pushHomeView()
                    if !fromMemory {
                        self?._storeUserSettings()
                    }
                    dump(loginUser)
                    break
                case .failure(let error):
                    self?._handleError(withDataResponse: dataResponse, andError: error)                    
                    break
                }
        }
    }
    
    private func _storeUserSettings() -> () {
        let username = emailTextField.text! // ! , pretpostavljam jer znam da je tu
        let password = passwordTextField.text!
        _defaults.set(_rememberME, forKey: "remember-me")
        _defaults.set(username, forKey: "last-user")
        
        do{
            try Locksmith.saveData(data: ["password" : password], forUserAccount: username)
        } catch(let error) {
            print("imas neki error u catch bloku") //pretpostavljam duplić
            print(error)
        }
    }
    
    private func _handleError<K> (withDataResponse: DataResponse<K>, andError: Error){
        let message : String
        if let httpStatusCode = withDataResponse.response?.statusCode {
            switch(httpStatusCode) {
            case 400:
                message = "Correct email or password not provided."
            case 401:
                message = "Incorrect email or password."
            case 422:
                message = "Correct email or password not provided."
            default:
                message = andError.localizedDescription
            }
        } else {
            message = andError.localizedDescription
        }
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(action1)
        self._outerView.shake(8, withDelta: 4, speed: 0.03, shakeDirection: .rotation){[weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //connects this controller to HomeViewController
    private func _pushHomeView() {
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let homeViewController =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        homeViewController.loginUser = _loginUser
        
        navigationController?.setViewControllers([homeViewController], animated: true)
    }
}
