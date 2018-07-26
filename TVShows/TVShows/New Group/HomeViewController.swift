import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire


class HomeViewController: UIViewController {
    
    private var _shows: [Show]?
    
    var loginUser: LoginUser?
    
    @IBOutlet private weak var _TVShowTableView: UITableView! {
        didSet {
            _TVShowTableView.dataSource = self
            _TVShowTableView.delegate = self
            _TVShowTableView.estimatedRowHeight = 44
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self?._TVShowTableView.reloadData()
                case .failure(let error):
                    print("Api error: \(error).")
                }
                
        }
        
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction  = UITableViewRowAction(style: .default, title: "\u{2718}\n Delete") { (rowAction, indexPath) in

            self._shows?.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginUser = self.loginUser
        guard let show = self._shows?[indexPath.row] else {
            return
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let showDetailsViewController =
            storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        
        showDetailsViewController.loginUser = loginUser
        showDetailsViewController.show = show
        
        navigationController?.setViewControllers([showDetailsViewController], animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let showList = self._shows else {
            return 1 //jer planiram stavit label empty ak alamofire nije uspio pa je referenca nula ili neki drugi slucaj di se to dogadja ak postoji
        }
        return showList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = _TVShowTableView.dequeueReusableCell(withIdentifier: "TVShowTableViewCell", for: indexPath) as! TVShowTableViewCell
        
        if let showList = self._shows {
            let item = showList[indexPath.row]
            cell.configure(with: item)
        } else {
            let item = Show(id: "empty", title: "empty 😕", likesCount: 0)
            cell.configure(with: item)
        }
        
        return cell
    }
    
    
}

