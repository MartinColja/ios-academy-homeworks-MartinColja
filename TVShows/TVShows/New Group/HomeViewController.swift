import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire


class HomeViewController: UIViewController {
    
    private var _shows: [Show]?
    
    var loginUser: LoginUser?
    
    var listViewController: ListViewController?
    var gridViewController: UIViewController?
    
    @IBOutlet private weak var _childViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setViewControllers()
        _getShowsApiCall()
        _configViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func _setViewControllers() -> () {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        self.listViewController =
            (storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController)
    }
    
    private func _configViewController() -> () {
        let logoutItem = UIBarButtonItem.init(title: "",
                                        style: .plain,
                                        target: self,
                                        action: #selector(_logoutActionHandler))
        //bez ovog mi se ne pojavljuje slika već samo plavi krug
        //google kaže neš s alfom i renderanjem
        logoutItem.image = UIImage(named: "ic-logout")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    @objc private func _logoutActionHandler() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let loginViewController =
            storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        //clears user defaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        navigationController?.setViewControllers([loginViewController],animated: true)
    }
    
    private func _getShowsApiCall() ->() {
        guard let token = loginUser?.token else {
            return
        }
        
        SVProgressHUD.show()
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let show):
                    self?._shows = show
                    self?._pushChildViewController()
                case .failure(let error):
                    print("Api error: \(error).")
                }
        }
    }
    
    private func _pushChildViewController() -> () {
        addChildViewController(self.listViewController!)
        _childViewController.addSubview((listViewController?.view)!)
        listViewController?.shows = self._shows
        listViewController?.loginUser = self.loginUser
        listViewController?.didMove(toParentViewController: self)
    }
    
}
