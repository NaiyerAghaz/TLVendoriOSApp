//
//  ServiceVerificationURLViewController.swift
//  TotalVendor
//
//  Created by SMIT 005 on 04/01/22.
//

import UIKit
import WebKit
class ServiceVerificationURLViewController: UIViewController {
    var serviceURL = ""
    
    @IBOutlet weak var serviceWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("service URL ", serviceURL)
        let url = URL (string: self.serviceURL)
              let requestObj = URLRequest(url: url!)
        serviceWebView.load(requestObj)
        
    }
    
    @IBAction func actionBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDownload(_ sender: UIButton) {
        
    }
    

}
