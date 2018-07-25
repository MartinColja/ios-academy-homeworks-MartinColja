import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var _botttomButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var _leftButtonConstraint: NSLayoutConstraint!
    
    @IBAction private func _didSelectBottomButton(_ sender: UIButton) {
        
        let constant = _botttomButtonConstraint.constant == 20 ? 100: 20
        _botttomButtonConstraint.constant = CGFloat(constant)
        _leftButtonConstraint.constant = CGFloat(constant)


        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            sender.layer.cornerRadius = 10
            
        }
    }
}

