import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire


class HomeViewController: UIViewController {
    
    var loginUser: LoginUser?
    var listViewController: ListViewController?
    var gridViewController: GridViewController?
    
    @IBOutlet private weak var _childViewController: UIView!

    private var _listViewActive = true
    private var _shows: [Show]?
    
    
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
        self.gridViewController = (storyboard.instantiateViewController(withIdentifier: "GridViewController") as! GridViewController)
    }
    
    private func _configViewController() -> () {
        let logoutItem = UIBarButtonItem.init(title: "",
                                        style: .plain,
                                        target: self,
                                        action: #selector(_logoutActionHandler))
        
        let toggleItem = UIBarButtonItem.init(title: "",
                                              style: .plain,
                                              target: self,
                                              action: #selector(_toggleActionHandler))
        
        //bez ovog mi se ne pojavljuje slika već samo plavi krug
        //google kaže neš s alfom i renderanjem
        logoutItem.image = UIImage(named: "ic-logout")?.withRenderingMode(.alwaysOriginal)

        toggleItem.image = UIImage(named: "ic-gridview")?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = logoutItem
        navigationItem.rightBarButtonItem = toggleItem
    }
    
    @objc private func _toggleActionHandler() {
        _listViewActive = !_listViewActive
        _toggleImage()
        _toggleViewController()
    }
    
    private func _toggleImage() -> () {
        let imageName = _listViewActive ? "ic-gridview" : "ic-listview"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = image
    }
    
    private func _toggleViewController() -> () {
        if _listViewActive {
            _removeGridViewController()
            _pushListViewController()
        } else {
            _removeListViewController()
            _pushGridViewController()
        }
    }
    
    private func _removeGridViewController() -> () {
        gridViewController?.willMove(toParentViewController: nil)
        gridViewController?.view.removeFromSuperview()
        gridViewController?.removeFromParentViewController()
    }
    
    private func _removeListViewController() -> () {
        self._shows = listViewController?.shows
        listViewController?.willMove(toParentViewController: nil)
        listViewController?.view.removeFromSuperview()
        listViewController?.removeFromParentViewController()
    }
    
    private func _pushListViewController() -> () {
        addChildViewController(self.listViewController!)
        _childViewController.addSubview((listViewController?.view)!)
        listViewController?.shows = self._shows
        listViewController?.loginUser = self.loginUser
        listViewController?.didMove(toParentViewController: self)
    }
    
    private func _pushGridViewController() -> () {
        addChildViewController(self.gridViewController!)
        _childViewController.addSubview((gridViewController?.view)!)
        gridViewController?.shows = self._shows
        gridViewController?.loginUser = self.loginUser
        gridViewController?.didMove(toParentViewController: self)
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
                    self?._pushListViewController()
                case .failure(let error):
                    print("Api error: \(error).")
                }
        }
    }
    
}
