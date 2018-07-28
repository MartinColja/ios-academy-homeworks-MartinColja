import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire


class ListViewController: UIViewController {
    
    var shows: [Show]?
    
    var loginUser: LoginUser?
    
    @IBOutlet private weak var _TVShowTableView: UITableView! {
        didSet {
            _TVShowTableView.dataSource = self
            _TVShowTableView.delegate = self
            _TVShowTableView.estimatedRowHeight = 44
        }
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return _createDeleteAction(tableView, editActionsForRowAt: indexPath)
        
    }
    
    private func _createDeleteAction(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .default, title: "\u{2718}\n Delete") { (rowAction, indexPath) in
            
            self.shows?.remove(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginUser = self.loginUser
        guard let show = self.shows?[indexPath.row] else {
            return
        }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let showDetailsViewController =
            storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        
        showDetailsViewController.loginUser = loginUser
        showDetailsViewController.show = show
        
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let showList = self.shows else {
            return 1 //jer planiram stavit label empty ak alamofire nije uspio pa je referenca nula ili neki drugi slucaj di se to dogadja ak postoji
        }
        return showList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = _TVShowTableView.dequeueReusableCell(withIdentifier: "TVShowTableViewCell", for: indexPath) as! TVShowTableViewCell
        
        if let showList = self.shows {
            let item = showList[indexPath.row]
            cell.configure(with: item)
        }
        
        return cell
    }
    
    
}

