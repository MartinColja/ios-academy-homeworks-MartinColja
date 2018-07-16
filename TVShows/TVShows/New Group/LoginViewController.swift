//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 08/07/2018.
//  Copyright © 2018 Sifon.co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var numberOfTaps:Int = 0

    override func viewDidLoad() {
        label.text="\(numberOfTaps)"
        spinner.hidesWhenStopped = true
        spinnerButton.backgroundColor = UIColor.red
        spinnerButton.isEnabled = false
        spinnerButton.setTitle("Loading", for: .disabled)
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.spinner.stopAnimating()
            self.spinnerButton.isEnabled = true
            self.spinnerButton.backgroundColor = UIColor.green
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnButtonClick(_ sender: Any) {
        numberOfTaps+=1
        label.text="\(numberOfTaps)"
    }
    
    
    @IBOutlet weak var spinnerButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func toggleSpinner(_ sender: UIButton) {
        
        let currentTitle: String? = spinnerButton.currentTitle
        
        if (currentTitle == "Start"){
            spinnerButton.backgroundColor = UIColor.red
            spinnerButton.setTitle("Stop", for: .normal)
            spinner.startAnimating()
        } else {
            spinnerButton.backgroundColor = UIColor.green
            spinnerButton.setTitle("Start", for: .normal)
            spinner.stopAnimating()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
