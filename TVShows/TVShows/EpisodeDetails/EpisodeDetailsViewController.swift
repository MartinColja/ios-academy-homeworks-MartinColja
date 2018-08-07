import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire
import Kingfisher

class EpisodeDetailsViewController: UIViewController {
    
    private var _episodeDetails: EpisodeDetails?

    @IBOutlet private weak var _episodeDetailsImageView: UIImageView!
    
    @IBOutlet private weak var _episodeTitleLabel: UILabel!
    
    @IBOutlet private weak var _seasonNumberEpisodeNumberLabel: UILabel!
    
    @IBOutlet private weak var _episodeDescriptionLabel: UILabel!
    
    var loginUser: LoginUser?
    var episodeId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        _getEpisodeDetailsApiCall()
    }
    
    @IBAction private func _commentsButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let commentsViewController =
            storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        commentsViewController.episodeDetails = _episodeDetails
        commentsViewController.loginUser = loginUser
        navigationController?.setViewControllers([commentsViewController], animated: true)
    }
    @IBAction private func _navigateBackButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func _getEpisodeDetailsApiCall() {
        SVProgressHUD.show()
        
        guard
            let token = self.loginUser?.token,
            let episodeId = self.episodeId
        else{
            return
        }
        
        let parameters: [String: String] = [
            "episodeId" : episodeId
        ]
        let headers = ["Authorization" : token]
        
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes/" + episodeId,
                method: .get,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<EpisodeDetails>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episodeDetails):
                    self?._episodeDetails = episodeDetails
                    self?._setDetailsToViewController()
                    break
                case .failure(let error):
                    print("greska kod dobavljanja detalja epizode")
                    print("\(error)")
                    break
                }
        }
    }
    
    private func _setDetailsToViewController() -> () {
        guard let episodeDetails = self._episodeDetails else {
            return
        }
        self._kfSetImage(episodeDetails: episodeDetails)
        self._seasonNumberEpisodeNumberLabel.text = _formatEpisode( episodeDetails: episodeDetails )
        self._episodeDescriptionLabel.text = episodeDetails.description
        self._episodeTitleLabel.text = episodeDetails.title
        
    }
    
    private func _kfSetImage(episodeDetails: EpisodeDetails) {
        let url = URL(string: "https://api.infinum.academy" + episodeDetails.imageUrl)
        
        _episodeDetailsImageView.kf.setImage(with: url) { [weak self]
            (image, error, cacheType, imageUrl) in
            if image == nil {
                self?._episodeDetailsImageView.image = UIImage(named: "image-not-available")
            }
        }
    }
    
    private func _formatEpisode(episodeDetails: EpisodeDetails) -> String {
        return "S" + episodeDetails.season + " Ep" + episodeDetails.episodeNumber
    }
    
    
}
