import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

protocol AddEpisodeDelegate {
    func shouldReloadView() -> Void
}

class AddEpisodeViewController: UIViewController {

    var loginUser: LoginUser?
    var showDetails: ShowDetails?
    var addEpisodeDelegate: AddEpisodeDelegate?
    
    @IBOutlet private weak var _episodeTitleTextField: UITextField!
    
    @IBOutlet private weak var _seasonNumberTextField: UITextField!
    
    @IBOutlet private weak var _episodeNumberTextField: UITextField!
    
    @IBOutlet private weak var _episodeDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                         style: .plain,
                                         target: self,
                                         action: #selector(didSelectCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didSelectAddShow))
        
        let pink = UIColor(red: 255/255,
                       green: 117/255,
                       blue: 140/255,
                       alpha: 1.0)
        
        navigationItem.leftBarButtonItem?.tintColor = pink
        navigationItem.rightBarButtonItem?.tintColor = pink
        navigationItem.title = "Add episode"
    }
    
    @objc func didSelectCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddShow(){
        guard let token = loginUser?.token else { return }
        guard let showId = showDetails?.id else { return }
        _postEpisodeToApi(showId: showId, token: token)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func _postEpisodeToApi(showId: String, token: String ){
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId" : showId,
            "mediaId": "",
            "title" : self._episodeTitleTextField.text!,
            "description": self._episodeDescriptionTextField.text!,
            "episodeNumber": self._episodeNumberTextField.text!,
            "season" : self._seasonNumberTextField.text!
        ]
        
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<EpisodeDetails>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success:
                    self?.addEpisodeDelegate?.shouldReloadView()
                    self?.dismiss(animated: true, completion: nil)
                    break
                case .failure(let error):
                    
                    let message = error.localizedDescription

                    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    
                    let action1 = UIAlertAction(title: "OK", style: .default)
                    
                    alertController.addAction(action1)
                    
                    self?.present(alertController, animated: true, completion: nil)
                    print("greska kod postavljanja epizode")
                    print("\(error)")
                    break
                }
        }
    }
    
    
    
}
