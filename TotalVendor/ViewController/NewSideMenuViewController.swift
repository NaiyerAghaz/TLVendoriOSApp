//
//  NewSideMenuViewController.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 29/11/21.
//

import UIKit
import Alamofire

class NewSideMenuViewController: UIViewController {
    
    var callsOpen = false
    var controlsOpen = false
    var vendorDetailsOpen = false
    var apiLogoutApi : ApiUpdateTokenResponseModel?
    
    @IBOutlet weak var vendorImage: UIImageView!
    
    @IBOutlet weak var vendorImageOutet: UIImageView!
    
    @IBOutlet weak var vendorNameLbl1: UILabel!
    
    @IBOutlet weak var vendorNameLbl2: UILabel!
    
    @IBOutlet weak var dashboardView:UIView!
    @IBOutlet weak var callsView:UIView!
    @IBOutlet weak var VRICallsView:UIView!
    @IBOutlet weak var VRIAndOPILOgsView:UIView!
    @IBOutlet weak var callHistoryView:UIView!
    @IBOutlet weak var controlsView:UIView!
    @IBOutlet weak var vendorDetailsView:UIView!
    @IBOutlet weak var vendorTimeOffView:UIView!
    @IBOutlet weak var vendorTimeFinishedView:UIView!
    @IBOutlet weak var earningsView:UIView!
    @IBOutlet weak var vendorNameView:UIView!
    @IBOutlet weak var supportView:UIView!
    @IBOutlet weak var logoutView:UIView!
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    override func viewDidLoad() {
        super.viewDidLoad()
        //        CALLS VIEW
        VRICallsView.visibility = .gone
        VRIAndOPILOgsView.visibility = .gone
        callHistoryView.visibility = .gone
        
        //        CONTROLS VIEW
        vendorDetailsView.visibility = .gone
        vendorTimeOffView.visibility = .gone
        vendorTimeFinishedView.visibility = .gone
        earningsView.visibility = .gone
        
        //        VENDORNAME VIEW
        supportView.visibility = .gone
        logoutView.visibility = .gone
        
        vendorNameLbl1.text = (userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String) ?? ""
        vendorNameLbl2.text = (userDefaults.value(forKey: UserDeafultsString.instance.fullName) as? String) ?? ""
        print("IMAGE DATA IS \(userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")")
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.USER_IMAGEDATA) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.vendorImage.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.vendorImage.image = UIImage(systemName: "person.fill")
            self.vendorImage.tintColor  = .white
  
        }
        
        
        
    }
    
    @IBAction func dashboardTapped (_ sender: Any){
        
    }
    @IBAction func callsTapped (_ sender: Any){
        
        callsOpen = !callsOpen
        
        if callsOpen{
            VRICallsView.visibility = .visible
            VRIAndOPILOgsView.visibility = .visible
            callHistoryView.visibility = .visible
            
            vendorDetailsView.visibility = .gone
            vendorTimeOffView.visibility = .gone
            vendorTimeFinishedView.visibility = .gone
            earningsView.visibility = .gone
            supportView.visibility = .gone
            logoutView.visibility = .gone
            
            
            
        }else {
            VRICallsView.visibility = .gone
            VRIAndOPILOgsView.visibility = .gone
            callHistoryView.visibility = .gone
        }
        
    }
    @IBAction func vriTapped (_ sender: Any){
        
//        VRINewViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VRINewViewController") as! VRINewViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func vriOpiLogsTapped (_ sender: Any){
//        VRIAndOPILogsVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VRIAndOPILogsVC") as! VRIAndOPILogsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func callHistoryTapped (_ sender: Any){
    }
    
    @IBAction func controlsTapped (_ sender: Any){
        
        controlsOpen = !controlsOpen
        
        if controlsOpen{
            vendorDetailsView.visibility = .visible
            vendorTimeOffView.visibility = .visible
            vendorTimeFinishedView.visibility = .visible
            earningsView.visibility = .visible
            VRICallsView.visibility = .gone
            VRIAndOPILOgsView.visibility = .gone
            callHistoryView.visibility = .gone
            supportView.visibility = .gone
            logoutView.visibility = .gone
            
            
            
        }else {
            vendorDetailsView.visibility = .gone
            vendorTimeOffView.visibility = .gone
            vendorTimeFinishedView.visibility = .gone
            earningsView.visibility = .gone
        }
        
        
    }
    @IBAction func vendorDetailsTapped (_ sender: Any){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorDetailViewController") as! VendorDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func vendorTimeOffTapped (_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeOffViewController") as! VendorTimeOffViewController
        self.navigationController?.pushViewController(vc, animated: true)
            
    }
    
    
    @IBAction func vendorTimeFinishedTapped (_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeFinishedViewController") as! VendorTimeFinishedViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func earningsTapped (_ sender: Any){
        
    }
    @IBAction func vendorNameTapped (_ sender: Any){
        vendorDetailsOpen = !vendorDetailsOpen
        
        if vendorDetailsOpen{
            supportView.visibility = .visible
            logoutView.visibility = .visible
            VRICallsView.visibility = .gone
            VRIAndOPILOgsView.visibility = .gone
            callHistoryView.visibility = .gone
            vendorDetailsView.visibility = .gone
            vendorTimeOffView.visibility = .gone
            vendorTimeFinishedView.visibility = .gone
            earningsView.visibility = .gone
        }else {
            supportView.visibility = .gone
            logoutView.visibility = .gone
        }
    }
    @IBAction func supportTapped (_ sender: Any){
        
    }
    
    
    func hitLogoutApi(){
//  UserDefaults.standard.setValue(token, forKey: "FCMToken")
        let deviceToken = UserDefaults.standard.value(forKey: "FCMToken")
        let updateVoipToken = UserDefaults.standard.value(forKey: "voipToken") ?? ""
        let url =  APIs.logoutApi
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
           let parameters = [
               "UserGuid": currentGUID,
               "UserID": userID,
           ] as [String : Any]
           print("HITBOOKINGSLOTSSSS----------","\(url)",parameters)
           AF.request(url,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: nil)
               .validate()
               .responseData { (respData) in
                   switch (respData.result){
                   case .success(_):
                       guard let data = respData.data else {return}
                       print("Success HITBOOKINGSLOTSSSS-------\(data)")
                       do{
                           let decoder = JSONDecoder()
                           self.apiLogoutApi = try decoder.decode(ApiUpdateTokenResponseModel.self, from: data)
                           let status = self.apiLogoutApi?.table?.first?.success
//           isLoggedIn
                   
//                        print("ApiGrumerProfileResponseModel----------Status----", self.apiUpdateDeviceTokenResponseModel?.table?.first?.success)
//                        guard let status = self.apiUpdateDeviceTokenResponseModel?.table?.first?.success else{ return }
                           if status == 1{
                               print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                            
                               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change
                                   SwiftLoader.hide()
                                   let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                                            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                                            let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                                            navigationController.viewControllers = [rootViewController]
                                                            appDelegate.window!.rootViewController = navigationController
                                                            appDelegate.window!.makeKeyAndVisible()
                                  // Code you want to be delayed
                               }
                           }
                           
                       } catch let error {
//                               SwiftLoader.hide()
                           print(error)
                           
//         self.showAlertWithMsgNCancelBtn(withTitle: "success--error", withMessage:"Please try again Later")
                       }
                   case .failure(_):
//                           SwiftLoader.hide()
//                           self.showAlertWithMsgNCancelBtn(withTitle: "Failure", withMessage: "Please try Again later")
                       break
                   }
               }
       }
    
    @IBAction func logoutTapped (_ sender: Any){
        hitLogoutApi()
    }
    
    
    
    /*
    @IBAction func logoutTapped (_ sender: Any){
        SwiftLoader.show(animated: true)
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        print("LogOut")
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
//                vc!.modalPresentationStyle = .fullScreen
//                present(vc!, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc!, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change
            SwiftLoader.hide()
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                     let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                     let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                                     let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier:"InitialViewController") as! InitialViewController
                                     navigationController.viewControllers = [rootViewController]
                                     appDelegate.window!.rootViewController = navigationController
                                     appDelegate.window!.makeKeyAndVisible()
           // Code you want to be delayed
        }
      
        
        
    }
    
    */
    
    
}

extension NewSideMenuViewController{
    
}
