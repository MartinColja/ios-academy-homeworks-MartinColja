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
    
    @IBOutlet weak var _episodeImageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _configViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        _chooseImageFromPhone()
    }
    
    private func _configViewController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(_didSelectCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(_didSelectAddShow))

        let pink = UIColor(red: 255/255, green: 117/255, blue: 140/255, alpha: 1.0)
        
        navigationItem.leftBarButtonItem?.tintColor = pink
        navigationItem.rightBarButtonItem?.tintColor = pink
        navigationItem.title = "Add episode"
    }
    
    @objc func _didSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func _didSelectAddShow() {
        guard
            let token = loginUser?.token
        else {
            return
        }
        _postImageToApi(token: token)
    }
    
    private func _chooseImageFromPhone() -> () {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default) { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func _postImageToApi(token: String) {
        let headers = ["Authorization": token]
        guard let image = _episodeImageVIew.image else {
            return
        }
        let imageByteData = UIImagePNGRepresentation(image)!
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers) { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?._processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
                
        }
    }
    
    private func _processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { [weak self] (response:
                DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                    self?._postEpisodeToApi(mediaId: media.id)
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
        }
    }
    
    private func _postEpisodeToApi(mediaId: String ) {
        
        guard
            let token = self.loginUser?.token,
            let showId = self.showDetails?.id
        else {
            return
        }
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId" : showId,
            "mediaId": mediaId,
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

extension AddEpisodeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        _episodeImageVIew.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddEpisodeViewController: UINavigationControllerDelegate {
        
}
