import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class ShowDetailsViewController: UIViewController {

    var show: Show?
    var loginUser: LoginUser?
    private var _showDetails: ShowDetails?
    private var _episodesList: [Episode]?
    
    @IBAction private func _addEpisodeButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let addImageViewController =
            storyboard.instantiateViewController(withIdentifier: "AddEpisodeViewController") as! AddEpisodeViewController
        
        addImageViewController.addEpisodeDelegate = self
        addImageViewController.showDetails = self._showDetails
        addImageViewController.loginUser = self.loginUser
        
        let navigationController = UINavigationController.init(rootViewController:
            addImageViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func _popViewControllerButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet private weak var _showDetailsTableView: UITableView! {
        didSet {
            _showDetailsTableView.dataSource = self
            _showDetailsTableView.delegate = self
            _showDetailsTableView.estimatedRowHeight = 44
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _getShowDetails(showId: show!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //communicates with show details user api
    private func _getShowDetails(showId: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId" : showId
        ]
        
        guard let token = loginUser?.token else {
            return
        }
        
        let headers = ["Authorization" : token]
        
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)",
                     method: .get,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<ShowDetails>) in
                
                switch dataResponse.result {
                case .success(let showDetails):
                    self?._showDetails = showDetails
                    self?._getShowEpisodes(showId: showId)
                    break
                case .failure(let error):
                    print("API error in _getShowDetails:\n\n\(error)")
                    break
                }
        }
    }
    
    private func _getShowEpisodes(showId: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId" : showId
        ]
        
        guard let token = loginUser?.token else {
            return
        }
        let headers = ["Authorization" : token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)/episodes",
                     method: .get,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episodesList):
                    self?._episodesList = episodesList
                    self?._showDetailsTableView.reloadData()
                    break
                case .failure(let error):
                    print("greska kod dobavljanja liste epizoda")
                    print("\(error)")
                    break
                }
        }
    }
}
extension ShowDetailsViewController: AddEpisodeDelegate {
    func shouldReloadView() {
        self._getShowEpisodes(showId: show!.id)
        self._showDetailsTableView.reloadData()
    }
    
}

extension ShowDetailsViewController: UITableViewDelegate {  }

extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let episodesList = self._episodesList else {
            return 2 //jer planiram stavit praznu sliku i no description ak alamofire nije uspio pa je referenca nula ili neki drugi slucaj di se to dogadja ak postoji
        }
        return episodesList.count + 2 // za sliku i opis
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            
        case 0:
            
            let imageCell = _showDetailsTableView.dequeueReusableCell(withIdentifier: "ShowImageTableViewCell", for: indexPath) as! ShowImageTableViewCell
            
            if let showDetails = self._showDetails {
                imageCell.configure(imageUrl: showDetails.imageUrl, showId: showDetails.id)
            }
            
            imageCell.configure(imageUrl: "", showId: "")
            return imageCell
            
        case 1:
            let descriptionCell = _showDetailsTableView.dequeueReusableCell(withIdentifier: "ShowDescriptionTableViewCell", for: indexPath) as! ShowDescriptionTableViewCell
            
            if let showDetails = self._showDetails {
                if let episodesList = self._episodesList {
                    descriptionCell.configure(showDescription: showDetails.description, showTitle: showDetails.title, numberOfEpisodes: episodesList.count)
                    return descriptionCell
                }
            }
            
            descriptionCell.configure(showDescription: "", showTitle: "No shows available 😕" , numberOfEpisodes: 0)
            return descriptionCell
            
        default:
            let episodeCell = _showDetailsTableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
            
            if let episodesList = self._episodesList {
                let index = indexPath.row - 2
                let episodeNumber = episodesList[index].episodeNumber
                let episodeTitle = episodesList[index].title
                let season = episodesList[index].season
                episodeCell.configure(with: episodeTitle, for: season, and: episodeNumber)
                return episodeCell
            }
            return episodeCell
            
        }
        
    }


}

