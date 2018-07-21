import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire


class HomeViewController: UIViewController {
    
    private var _shows: [Show]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default )
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success(let show):
                    self?._shows = show
                case .failure(let error):
                    print("Api error: \(error).")
                }                
        }
        
        
    }

}
