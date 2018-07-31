import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var _commentsScrollView: UIScrollView!
    
    var loginUser: LoginUser?
    var episodeDetails: EpisodeDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _subscribeToKeyboard()
        _getEpisodeCommentsApiCall()
        
    }
    private func _subscribeToKeyboard() -> () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    private func _getEpisodeCommentsApiCall() -> () {
        
        SVProgressHUD.show()
        
        guard
            let token = self.loginUser?.token,
            let episodeId = self.episodeDetails?.id
            else{
                return
        }
        
        let parameters: [String: String] = [
            "episodeId" : episodeId
        ]
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/comments",
                     method: .get,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[AquiredComment]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let comments):
                    self?._handleGetCommentsSuccess(comments: comments)
                    break
                case .failure(let error):
                    print("greska kod dobavljanja detalja epizode")
                    print("\(error)")
                    break
                }
        }
    }
    
    private func _handleGetCommentsSuccess(comments: [AquiredComment]) -> () {
        //dodaj komentare na table view
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
       _adjustKeyboard(Constants.InsetDirection.Upwards, notification)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        _adjustKeyboard(Constants.InsetDirection.Downwards, notification)
    }
    
    private func _adjustKeyboard(_ direction: Constants.InsetDirection, _ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrame.cgRectValue
            let inset: UIEdgeInsets
            switch direction {
            case .Upwards:
                inset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height + 10, 0);
            case .Downwards:
                inset = UIEdgeInsets.zero
            }
            _commentsScrollView.contentInset = inset
        }
    }
}
