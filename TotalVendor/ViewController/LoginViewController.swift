//
//  LoginViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import Alamofire
import CallKit
import Foundation
import LocalAuthentication
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTxtField: UITextField!
    var apiLogoutFromWebResponseModel : ApiLogoutFromWebResponseModel?
    @IBOutlet weak var touchIdBtnOutlet: UIButton!
    
    var forLogin = false
    var err:NSError?
    var context = LAContext()
    var apiUpdateDeviceTokenResponseModel : ApiUpdateTokenResponseModel?
    @IBOutlet weak var passwordTxtField: UITextField!
    var apiLoginResponseModel : ApiLoginResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxtField.delegate=self
        passwordTxtField.delegate=self
//        userNameTxtField.text = "Leo_ven09"
//        passwordTxtField.text = "Total@user2021"
        userNameTxtField.text = "Leo_ven09"
        passwordTxtField.text = "Total@user2021"
        
//        Leo_ven09
//        Total@user2021\
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let touchID = userDefaults.value(forKey: "touchID") ?? false //keychainServices.getKeychaindata(key: "touchID")
                print("touch id after ", touchID)
                if  touchID as! Bool  {
                    print("touch id saved")
                    self.touchIdBtnOutlet.isHidden = false
                }
                else{
                    self.touchIdBtnOutlet.isHidden = true
                }
    }
    
   
    
    
    
    func bioMetricForLogin(newUserID:Int){
//        userDefaults.set(true, forKey: "touchID" )
//        userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
//        userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
//
//        self.hitUpdateTokenApi(userID: userData?.userID ?? 0)
        
        let localString = "Biometric Authentication!"
                
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
                    
                    if context.biometryType == .faceID {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS FACE ID\(localString)")
                                DispatchQueue.main.async {
                                    userDefaults.set(true, forKey: "touchID" )
                                    userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
                                    userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
                                }
                                
                        
                                self.hitUpdateTokenApi(userID: newUserID)
                                
                                
//                                DispatchQueue.main.async {
//                                    SwiftLoader.show(title: "Login...", animated: true)
//                                    self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
//                                }
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                        
                        
                    }
                    else if context.biometryType == .touchID  {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS TOUCH ID\(localString)")
                                
                                DispatchQueue.main.async {
                                    userDefaults.set(true, forKey: "touchID" )
                                    userDefaults.set(self.userNameTxtField.text, forKey: "userNameForTouchID" )
                                    userDefaults.set(self.passwordTxtField.text, forKey: "userPasswordForTouchID")
                            
                            
                                    self.hitUpdateTokenApi(userID: newUserID)
                                }
                                    
//                                DispatchQueue.main.async {
//                                    SwiftLoader.show(title: "Login..", animated: true)
//                                    self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
//                                }
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                    }
                }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func touchIDBtnTapped(_ sender: Any) {
        
        let localString = "Biometric Authentication!"
                
                if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
                    
                    if context.biometryType == .faceID {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS FACE ID\(localString)")
//                                DispatchQueue.main.async {
//                                    SwiftLoader.show(title: "Login...", animated: true)
//                                    self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
//                                }
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                        
                        
                    }
                    else if context.biometryType == .touchID  {
                        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString) { success, err in
                            if success{
                                print("SUUCESS TOUCH ID\(localString)")
//                                DispatchQueue.main.async {
//                                    SwiftLoader.show(title: "Login..", animated: true)
//                                    self.biometricAuthentication(username: CEnumClass.share.loadKeydata(keyname: "username"), pwd: CEnumClass.share.loadKeydata(keyname: "password"))
//                                }
                                
                            }else {
                                print("ERROR IS \(err?.localizedDescription)")
                            }
                        }
                    }
                }
        
        
        
        
        
        
    }
    @IBAction func ForgotBtnAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController
        vc!.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func SignInBtnAction(_ sender: Any) {
        
    if userNameTxtField.text?.isEmpty ?? true || passwordTxtField.text?.isEmpty ?? true  {
            // Alert
        }
        else
    {
            self.postLoginDetails()
//            self.doLogin()
    }
    }
    
    var iconClick = true
    
    @IBAction func iconAction(sender: AnyObject) {
        
            if(iconClick == true) {
                passwordTxtField.isSecureTextEntry = false
            } else {
                passwordTxtField.isSecureTextEntry = true
            }
            iconClick = !iconClick
        
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension LoginViewController {
    
    func doLogin(){
        var activite = NVActivityIndicatorView(frame: .zero, type: .lineScaleParty, color:.white , padding: 0)
        activite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activite)
        NSLayoutConstraint.activate([activite.widthAnchor.constraint(equalToConstant: 40),activite.heightAnchor.constraint(equalToConstant: 40),activite.centerYAnchor.constraint(equalTo: view.centerYAnchor),activite.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        activite.startAnimating()
        var userName = self.userNameTxtField.text
        var password = self.passwordTxtField.text
        let parameters = ["UserName": userName, "Password": password, "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
        NetworkLayer.shared.postRequest(url: APIs.USER_LOGIN, parameters: parameters) { response in
            print("URL REQUEST IS \(APIs.USER_LOGIN) and parameter is \(parameters)")
            print("API Response ===\(response)")
            activite.stopAnimating()
            
            var responsedata  = response as! NSDictionary
            let jsonDecoder = JSONDecoder()
                 do{
                let parsedJSON = try jsonDecoder.decode(ApiLoginResponseModel.self, from: response as! Data )
                
                let loginResponse = parsedJSON
                print("LOGIN RESPONSE IS \(loginResponse)")
                    }
            catch
                    {
                        print(error)
                    }

            /*
            var responseArray = responsedata["UserDetails"] as! NSArray
         
            if(responseArray.count > 0){
                var responseDictionary = responseArray[0] as! NSDictionary
                print(responseDictionary)
                if(responseDictionary["TokenID"] as? String == "NA" ?? ""){
                    self.view.makeToast(responseDictionary["Message"] as! String)
                }

                if(responseDictionary["Status"] != nil){
                    if(responseDictionary["Status"] == nil){
                        print("Invalid credentials")
                        
                    }
                    if(responseDictionary["Status"] as! Int == 305){
                        print(responseDictionary["Message"])
                        
                    }else{
                        print(responseDictionary["You entered wrong password for more than 5 times, please reset your password"])
                    }
                
                }
             
                if(responseDictionary["Status"] != nil){
                    if(responseDictionary["Status"] as! Int == 88){
                        
                    }
                    }else if(responseDictionary["VendorActive"] != nil && responseDictionary["UserTypeID"] != nil && responseDictionary["AdminJobApproval"] != nil){
                        if(responseDictionary["VendorActive"] as! Int == 1 && responseDictionary["AdminJobApproval"]  as! Int == 0 && responseDictionary["UserTypeID"]  as! Int == 6){
                            
                            
                            print("Waiting for Admin Approval. Please wait untill approve")
                        
                    }
                }
                 
                if(responseDictionary["VendorActive"] != nil && responseDictionary["UserTypeID"] != nil ){
                    
                    if(responseDictionary["VendorActive"] == nil || responseDictionary["UserTypeID"] == nil){
                        print("Invalid credentials")
                    }
                    if(responseDictionary["VendorActive"] as! Int == 0 && responseDictionary["UserTypeID"] as! Int  == 6){
                        
                        
                        
                        print("Please proceed through web to upload the documents (Interpreter Confidentiality Agreement, Independent Contractor Agreement, Criminal History Agreement, Business Associate Agreement, Medical Screening Form Agreement, Payroll Policy Agreement) for further registration process")
                }
                }
                if(responseDictionary["Status"] != nil){
                if(responseDictionary["UserTypeID"] as! Int ?? 0 == 6){
                    UserDefaults.standard.setValue(responseDictionary["UserID"], forKey: "userID")
                    
                    
                    let parameters = ["TokenID": UserDefaults.standard.object(forKey: "FCMToken")!, "Status": "Y", "UserID":UserDefaults.standard.object(forKey: "userID")!, "DeviceType": "I", "voipToken": UserDefaults.standard.object(forKey: "deviceID") ?? ""]
                    NetworkLayer.shared.postRequest(url: APIs.Token_API, parameters: parameters) { response in
                        
                        //print("API Response ===\(response)")
                        var responseData  = response as! NSDictionary
                        var responsearray  = responseData["Table"] as! NSArray
                        if(responsearray.count > 0){
                            var dictResponce = responsearray[0] as! NSDictionary
                            if(dictResponce["success"] as! Int == 1){
                                if(dictResponce["CurrentUserGuid"] != nil){
                                    
                                    UserDefaults.standard.setValue(dictResponce["CurrentUserGuid"], forKey: "UserGuid")
                                    let parameters = ["UserGuID":"DBCCFEE6-BB65-490E-AEFA-6B67CC30439D", "UserID":"218570"]
                                    NetworkLayer.shared.postRequest(url: APIs.Checkuser_API, parameters: parameters) { response in
                                        
                                    print("API Response ===\(response)")
                                    var getResponse  = response as! NSDictionary
                                        if(getResponse["Status"] as! Int == 1){
                                            activite.stopAnimating()
                                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashbord") as? dashbord
                                                            vc!.modalPresentationStyle = .fullScreen
                                            self.present(vc!, animated: true, completion: nil)
//                                                            self.navigationController?.pushViewController(vc!, animated: true)
                                            
                                        }
                                        
                                        
                                        
                            } failure: { error in
                                //Handle Response
                                print("API error ===\(error.localizedDescription)")
                            }
                            
                        }
                            }}
                        
                    } failure: { error in
                        //Handle Response
                        print("API error ===\(error.localizedDescription)")
                    }
            }
            }
            }
            */
            //Handle Response
        } failure: { error in
            //Handle Response
            print("API error ===\(error.localizedDescription)")
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTxtField{
            if userNameTxtField.text?.isEmpty ?? true || passwordTxtField.text?.isEmpty ?? true  {
                    // Alert
                }
                else
            {
                    self.postLoginDetails()
        //            self.doLogin()
            }
        }
        return true
    }
    
    
    
    
}


extension LoginViewController{
    
    func postLoginDetails(){
        SwiftLoader.show(animated: true)
            guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
               return
            }
        var userName = userNameTxtField.text ?? ""
        var password = passwordTxtField.text ?? ""
        let parameters = ["UserName": userName, "Password": password, "Ip": "M", "Latitude": "0", "Longitude": "0", "UserSessionId" : "", "UserLoginKey": ""]
            print("postLoginDetails--",parameters , APIs.USER_LOGIN)
            AF.request(APIs.USER_LOGIN,
                       method: .post,
                       parameters: parameters,
                       encoding: URLEncoding.default)
                .validate()
                .responseData {  [unowned self]  response in
                    switch response.result {
                    case .success(_):
                        guard let data = response.data else { return }
                        print("Success postLoginDetails Api ",data)
                        do {
                            let decoder = JSONDecoder()
                            SwiftLoader.hide()
                            self.apiLoginResponseModel = try decoder.decode(ApiLoginResponseModel.self, from: data)
                            let status : Bool = self.apiLoginResponseModel?.userDetails?.first?.status ?? false
                            if status == true{
                                print("🎖",self.apiLoginResponseModel)
                                let userData = self.apiLoginResponseModel?.userDetails?.first
                                if userData?.vendorActive==1 && userData?.userType == "6"{
                                    self.view.makeToast("Please proceed through web to upload the documents (Confidentiality Agreement, Contractor Agreement, Criminal Background Check, Hippa Policy, W9, Payroll Policy) for further registration process")
                                }
                                else if userData?.vendorActive==1 && userData?.adminJobApproval == 0 && userData?.userTypeID==6 {
                                    self.view.makeToast("Please proceed through web to upload the documents (Confidentiality Agreement, Contractor Agreement, Criminal Background Check, Hippa Policy, W9, Payroll Policy) for further registration process")
                                }else {
                                    
                                    let touchID = userDefaults.value(forKey: "touchID") ?? false
                                    if touchID as! Bool {
                                        hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                                                    
                                                                    
                                                                    
                                    //                                self.registerTwilioAccessToken(with: item)
                                                                }
                                    else {
                                        let alert = UIAlertController(title: "Do you want to save this login to use FACE ID/TOUCH ID", message: "", preferredStyle: .alert)
                                        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ cancel  in
                                            
                                            hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                            
                                            
        //                                    self.registerTwilioAccessToken(with: item)
                                        }
                                        let yes = UIAlertAction(title: "Yes", style: .destructive) { alert in
//                                            self.touchIdBtnOutlet.isHidden = false
                                            print("username and password ", self.userNameTxtField.text , self.passwordTxtField.text)
                                            self.bioMetricForLogin(newUserID: userData?.userID ?? 0)
        //                                    self.registerTwilioAccessToken(with: item)
                                        }
                                        alert.addAction(cancel)
                                        alert.addAction(yes)
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
                                    
                                    
                                    UserDefaults.standard.setValue(userData?.userTypeID, forKey: UserDeafultsString.instance.UserTypeID)
                                    UserDefaults.standard.setValue(userData?.userName, forKey: UserDeafultsString.instance.USER_USERNAME)
                                    UserDefaults.standard.setValue(userData?.firstName, forKey: UserDeafultsString.instance.FirstName)
                                    UserDefaults.standard.setValue(userData?.lastName, forKey: UserDeafultsString.instance.LastName)
                                    UserDefaults.standard.setValue(userData?.fullName, forKey: UserDeafultsString.instance.fullName)
                                    UserDefaults.standard.setValue(userData?.userTypeID, forKey: UserDeafultsString.instance.USER_TYPE)
                                    UserDefaults.standard.setValue(userData?.customerID, forKey: UserDeafultsString.instance.USER_CUSTOMER_ID)
                                    UserDefaults.standard.setValue(userData?.email, forKey: UserDeafultsString.instance.Email)
                                    UserDefaults.standard.setValue(userData?.imageData, forKey: UserDeafultsString.instance.USER_IMAGEDATA)
                                    UserDefaults.standard.setValue(userData?.companyName, forKey: UserDeafultsString.instance.CompanyName)
                                    UserDefaults.standard.setValue(userData?.companyID, forKey:
                                    UserDeafultsString.instance.CompanyID)
                                    UserDefaults.standard.setValue(userData?.companyLogo, forKey: UserDeafultsString.instance.CompanyLogo)
                                    UserDefaults.standard.setValue(userData?.usertoken, forKey: UserDeafultsString.instance.UserToken)
                                    UserDefaults.standard.setValue(userData?.timeZone, forKey: UserDeafultsString.instance.TimeZone)
                                    UserDefaults.standard.setValue(userData?.timeZone1, forKey: UserDeafultsString.instance.TimeZone1)
                                    UserDefaults.standard.setValue(userData?.userID ?? 0, forKey: UserDeafultsString.instance.UserID)
                                    UserDefaults.standard.setValue(userData?.userGuID ?? 0, forKey: UserDeafultsString.instance.userGUID)
//                                    hitUpdateTokenApi(userID: userData?.userID ?? 0)
                                }
                            } else {
                                self.view.makeToast(self.apiLoginResponseModel?.userDetails?.first?.Message ?? "", duration: 3.0, position: .center)
                            }
                        } catch let error {
                            SwiftLoader.hide()
                            self.view.makeToast("Please enter correct password.", duration: 3.0, position: .center)
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                        self.view.makeToast("Please try after sometime.", duration: 3.0, position: .center)
                    }
                }
        }
  
}
let callController = CXCallController()
extension LoginViewController{
//  func hitUpdateTokenApi(userID:Int){
        func hitUpdateTokenApi(userID:Int){
//  UserDefaults.standard.setValue(token, forKey: "FCMToken")
            let deviceToken = UserDefaults.standard.value(forKey: "FCMToken")
            let updateVoipToken = UserDefaults.standard.value(forKey: "voipToken") ?? ""
            let url =  APIs.UpdateDeviceToken
               let parameters = [
                   "voipToken": updateVoipToken,
                   "UserID": userID,
                   "TokenID": deviceToken ?? "",
                   "Status": "Y",
                   "DeviceType": "I"
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
                               self.hitlogoutFromWebApi()
                               let decoder = JSONDecoder()
                               self.apiUpdateDeviceTokenResponseModel = try decoder.decode(ApiUpdateTokenResponseModel.self, from: data)
//           isLoggedIn
                        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                            print("ApiGrumerProfileResponseModel----------Status----", self.apiUpdateDeviceTokenResponseModel?.table?.first?.success)
                            guard let status = self.apiUpdateDeviceTokenResponseModel?.table?.first?.success else{ return }
                               if status == 1{
                                   print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                                   
                                   userDefaults.set(self.apiLoginResponseModel?.userDetails?.first?.timeZone, forKey: "TimeZone")
                                   
                                   UserDefaults.standard.setValue(self.apiUpdateDeviceTokenResponseModel?.table?.first?.currentUserGuid ?? 0, forKey: UserDeafultsString.instance.userGUID)
                                   
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashbord") as? dashbord
                                    vc!.modalPresentationStyle = .fullScreen
                                self.present(vc!, animated: true, completion: nil)
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

    func hitlogoutFromWebApi(){
//  UserDefaults.standard.setValue(token, forKey: "FCMToken")
        
        let url =  APIs.logoutFromWeb
        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let currentGUID = userDefaults.string(forKey: UserDeafultsString.instance.userGUID) ?? "0"
           let parameters = [
               "UserID": userID,
               "UserGuID": currentGUID,
               
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
                           self.apiLogoutFromWebResponseModel = try decoder.decode(ApiLogoutFromWebResponseModel.self, from: data)
//           isLoggedIn
                  
                           print("apiLogoutFromWebResponseModel----------Status----", self.apiLogoutFromWebResponseModel?.status)
                        guard let status = self.apiLogoutFromWebResponseModel?.status else{ return }
                           if status == 1{
                               print("----- HITBOOKINGSLOTSSSS SUCCESSFUL----- ")
                          
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


}


public class UserDeafultsString{
     static let instance = UserDeafultsString()
    var UserTypeID = "UserTypeID"
    var USER_USERNAME = "USER_USERNAME"
    var FirstName = "FirstName"
    var UserID = "0"
    var LastName = "LastName"
    var fullName = "fullName"
    var USER_TYPE = "USER_TYPE"
    var USER_CUSTOMER_ID = "USER_CUSTOMER_ID"
    var Email = "Email"
    var USER_IMAGEDATA = "USER_IMAGEDATA"
    var CompanyID = "CompanyID"
    var CompanyName = "CompanyName"
    var CompanyLogo = "CompanyLogo"
    var UserToken = "UserToken"
    var TimeZone = "TimeZone"
    var TimeZone1 = "TimeZone1"
    var userGUID = "userGuID"
}
