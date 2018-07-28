import UIKit

class GridViewController: UIViewController {
 
    @IBOutlet private weak var _showsCollectionView: UICollectionView!
    
    var shows: [Show]?
    
    var loginUser: LoginUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _showsCollectionView.delegate = self
        _showsCollectionView.dataSource = self
    }
    
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let showList = self.shows else {
            return 1
        }
        return showList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _showsCollectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
        
        if let showList = self.shows {
            let item = showList[indexPath.row]
            cell.configure(with: item)
        }
        return cell
    }
}
