import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class CommentsViewController: UIViewController {
    
    @IBOutlet private weak var _commentsScrollView: UIScrollView!
    
    @IBOutlet private weak var _newCommentTextField: UITextField!
    
    @IBAction func _addCommentButtonAction(_ sender: Any) {
        _postEpisodeCommentApiCall()
    }
    
    @IBOutlet weak var _commentsTableView: UITableView! {
        didSet{
            _commentsTableView.dataSource = self
            _commentsTableView.delegate = self
            _commentsTableView.estimatedRowHeight = 44
        }
    }
    
    var loginUser: LoginUser?
    var episodeDetails: EpisodeDetails?
    
    private var _commentsList: [AquiredComment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _subscribeToKeyboard()
        _getEpisodeCommentsApiCall()
        _configViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func _subscribeToKeyboard() -> () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }

    private func _getEpisodeCommentsApiCall() -> () {
        
        SVProgressHUD.show()
        
        guard
            let episodeId = episodeDetails?.id,
            let token = loginUser?.token
        else {
            return
        }
        
        let parameters: [String: String] = [
            "episodeId" : episodeId
        ]
        
        let headers = ["Authorization" : token]
        
        let urlString = "https://api.infinum.academy/api/episodes/" + episodeId + "/comments"
        Alamofire
            .request(urlString,
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
                    print("greskica")
                    print("\(error)")
                    break
                }
        }
    }
    
    private func _handleGetCommentsSuccess(comments: [AquiredComment]) -> () {
        self._commentsList = comments
        self._commentsTableView.reloadData()
        print("reload-ah data")
        dump(_commentsList)
    }
    
    private func _postEpisodeCommentApiCall() -> () {
        
        SVProgressHUD.show()
        
        guard
            let token = self.loginUser?.token,
            let episodeId = self.episodeDetails?.id,
            let text: String = self._newCommentTextField.text
            else{
                return
        }
        
        let parameters: [String: String] = [
            "text": text,
            "episodeId" : episodeId
        ]
        let headers = ["Authorization" : token]
        
        Alamofire
            .request( "https://api.infinum.academy/api/comments",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<PostedComment>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success:
                    self?._commentsTableView.reloadData()
                    self?._getEpisodeCommentsApiCall()
                    break
                case .failure(let error):
                    print("greska kod dobavljanja detalja epizode")
                    print("\(error)")
                    break
                }
        }
    }
    
    private func _configViewController() -> () {
        let logoutItem = UIBarButtonItem.init(title: "",
                                              style: .plain,
                                              target: self,
                                              action: #selector(_navigateBackActionHandler))
        
        logoutItem.image = UIImage(named: "ic-navigate-back")?.withRenderingMode(.alwaysOriginal)
    
        
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    @objc private func _navigateBackActionHandler() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let episodeDetailsViewController =
            storyboard.instantiateViewController(withIdentifier: "EpisodeDetailsViewController") as! EpisodeDetailsViewController
        
        navigationController?.setViewControllers([episodeDetailsViewController], animated: true)
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

extension CommentsViewController: UITableViewDelegate {
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let commentsList = _commentsList else {
            return 0 //odustajem od one preview ideje zasad, prebrzo se loada a čak mi i ljepše izgleda bez ičega tako da nevidim smisao.
        }
        return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commentCell = _commentsTableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        
        guard let commentsList = self._commentsList else {
            return commentCell
        }
        let comment = commentsList[indexPath.row].text
        let userMail = commentsList[indexPath.row].userEmail
        commentCell.config(username: userMail, comment: comment)
        return commentCell
    }
    
}

