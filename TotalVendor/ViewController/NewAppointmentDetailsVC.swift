//
//  NewAppointmentDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/12/21.
//

import UIKit
import Alamofire

class NewAppointmentDetailsVC: UIViewController {

    @IBOutlet weak var venueNameView: UIView!
    @IBOutlet weak var specialRequestsView: UIView!
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var specialityView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var casePatientInitialView: UIView!
    @IBOutlet weak var casePatientView: UIView!
    @IBOutlet weak var interpreterNameView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var servicetypeView: UIView!
    @IBOutlet weak var authenticationCodeView: UIView!
    
    @IBOutlet weak var importtentLblView: UIView!
    @IBOutlet weak var interpreterNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var authenticationCodelbl: UILabel!
    
    @IBOutlet weak var serviceTypeLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var specialRequestsLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var patientInitialLbl: UILabel!
    @IBOutlet weak var patientLbl: UILabel!
    @IBOutlet weak var specialityLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomBtnView: UIStackView!
    @IBOutlet weak var importantNoteLbl: UILabel!
    var companyName = ""
    var appointmentID = 0
    var serviceType = ""
    var apiOnsiteDetailsResponseModel : ApiOnsiteDetailsResponseModel?
    var appointmentType = ""
    var fileName = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    @IBOutlet weak var serviceVerificationview: UIView!
    @IBOutlet weak var AppointmentInfoLbl: UILabel!
    
    
    @IBOutlet weak var venueAddressViewOutlet: UIView!
    @IBOutlet weak var titleLblView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.departmentView.visibility = .gone
        self.casePatientView.visibility = .gone
        self.casePatientInitialView.visibility = .gone
        self.casePatientInitialView.visibility = .gone
        self.contactView.visibility = .gone
        self.specialRequestsView.visibility = .gone
        self.venueNameView.visibility = .gone
        
        
      //  GetPublicData.sharedInstance.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyName = (UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String) ?? ""
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        self.getOnsiteData(customerId: userId)
       // importantNoteLbl.text = "*** Important: Please note that an interpreter cannot cancel/return an appointment without speaking to someone at '\(companyName)' directly. Not via email nor voicemail. All returns are to be discussed with '\(companyName)'"
    }

    @IBAction func actionAvilableRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        acceptRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
    }
    @IBAction func actionDeclineRequest(_ sender: UIButton) {
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        declineRequestApi(notificationID: "0", appointmentID: "\(appointmentID)", userID: userId)
    }
    @IBAction func actionShowDoc(_ sender: UIButton) {
        let filename = self.fileName.replacingOccurrences(of: " ", with: "%20")
        previewFiles(fileName: filename, serviceType: "TempServiceFile") { (completion, fileName) in
            print("file name is ", fileName ?? "")
            let vc = self.storyboard?.instantiateViewController(identifier: "ServiceVerificationURLViewController") as! ServiceVerificationURLViewController
            vc.serviceURL = fileName ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
        
    }
    func previewFiles(fileName : String ,serviceType:String , completionHandler : @escaping(Bool? , String?) -> ()){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/PreviewFiles/Previewawsfiles?filename=\(fileName)&type=\(serviceType)"
       
        //\(date)"
        print("url to get previewFiles\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    print(String(data: daata, encoding: .utf8)!)
                    let fileURL = String(data: daata, encoding: .utf8)!
                    print("file path  is ",fileURL)
                    completionHandler(true , fileURL)
                    
                case .failure(_):
                    print("Respose Failure ")
                    completionHandler(false , nil)
                }
            })
    }
    func changeTitleLabel(appointmentType : String , AcceptAndDeclineStatus : Bool , isAssigned : Bool , IsExpired: Bool,companyName : String ){
        var  appointmentColor = ""
        var apiData = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first
        print("Total public count ", GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.count ?? 0 )
        GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (AppointmentStatusData) in
            
            if AppointmentStatusData.value == appointmentType {
                appointmentColor = AppointmentStatusData.color ?? ""
                self.statusLbl.textColor = UIColor(hexString: appointmentColor)
            }
        })
        print("appointment Type and color ", appointmentType , appointmentColor)
        if appointmentType == "Booked" {
//            self.venueNameView.visibility = .gone
//            self.venueAddressViewOutlet.visibility = .gone
//            self.departmentView.visibility = .gone
//            self.contactView.visibility = .gone
//            self.specialRequestsView.visibility = .gone
//            self.venueAddressLbl.text = "\(apiData?.address ?? "") \(apiData?.city ?? "") \(apiData?.stateName ?? "") \(apiData?.zipcode ?? "")"
//            self.serviceVerificationview.visibility = .visible
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = true
            
            if !(AcceptAndDeclineStatus) && !(isAssigned) {
                self.statusLbl.text = "Un-Available Appointment (Declined by you)"
                self.bottomBtnView.visibility = .gone
                self.titleLbl.text = "Un-Available Appointment"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
                
            }else if AcceptAndDeclineStatus && !(isAssigned) {
                self.titleLbl.text = "Un-Available Appointment"
                self.bottomBtnView.visibility = .gone
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
                self.statusLbl.text = "Un-Available Appointment (Appointment is no longer available)"
            }else if AcceptAndDeclineStatus && isAssigned {
                
                self.titleLbl.text = "Booked Appointment"
                self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
                self.bottomBtnView.visibility = .gone
                self.venueAddressLbl.text = "\(apiData?.address ?? "") \(apiData?.city ?? "") \(apiData?.stateName ?? "") \(apiData?.zipcode ?? "")"
                self.venueAddressLbl.removeEmptyString()
                self.departmentView.visibility = .visible
                self.casePatientView.visibility = .visible
                self.casePatientInitialView.visibility = .visible
                self.casePatientInitialView.visibility = .visible
                self.contactView.visibility = .visible
                self.specialRequestsView.visibility = .visible
                self.venueNameView.visibility = .visible
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
                
            }else if IsExpired && !(isAssigned) {
                
                self.titleLbl.text = "Un-Available Appointment"
                self.bottomBtnView.visibility = .gone
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
                self.statusLbl.text = "Un-Available Appointment (Appointment is no longer available)"
            }else if !(IsExpired) && isAssigned {
                self.titleLbl.text = "Booked Appointment"
                self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
                self.departmentView.visibility = .visible
                self.casePatientView.visibility = .visible
                self.casePatientInitialView.visibility = .visible
                self.casePatientInitialView.visibility = .visible
                self.contactView.visibility = .visible
                self.specialRequestsView.visibility = .visible
                self.venueNameView.visibility = .visible
                self.venueAddressLbl.text = "\(apiData?.address ?? "") \(apiData?.city ?? "") \(apiData?.stateName ?? "") \(apiData?.zipcode ?? "")"
                self.venueAddressLbl.removeEmptyString()
            }else if !(IsExpired) && !(isAssigned) {
                self.titleLbl.text = "Un-Available Appointment"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
                self.statusLbl.text = "Un-Available Appointment (Appointment is no longer available)"
                self.bottomBtnView.visibility = .gone
            }
            else {
                self.importantNoteLbl.text = ""
                self.titleLbl.text = "Booked Appointment"
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
            }
        } else if
            
            appointmentType == "Not Booked" {
//            self.bottomBtnView.isHidden = false
//            self.venueNameView.visibility = .gone
//
//            self.departmentView.visibility = .gone
//            self.contactView.visibility = .gone
//            self.specialRequestsView.visibility = .gone
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .visible
            self.AppointmentInfoLbl.text = "\(companyName)has sent you INQUIRY. Please check your availability and select the option below to indicate if you are available or have to decline the work."
            self.importantNoteLbl.text = "Note: Before you click that you are available, it is expected that  you will have checked your personal schedule and will be committed to provide the service.  Giving back an appointment once you have been Booked costs time and money and can lead to Botched appointments for the client and a possible termination for the interpreter. Please be sure you have no other scheduling conflicts."
            if AcceptAndDeclineStatus {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
                self.bottomBtnView.isHidden = false
                
                
            }else {
                self.statusLbl.text = "Declined"
                self.bottomBtnView.isHidden = true
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }
            
        }
        else if appointmentType == "InProcess" {
//            self.venueNameView.visibility = .visible
//            self.departmentView.visibility = .visible
//            self.contactView.visibility = .visible
//            self.specialRequestsView.visibility = .visible
//            self.serviceVerificationview.vis  ibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
//            self.bottomBtnView.isHidden = false
            
            if AcceptAndDeclineStatus && isAssigned {
                self.bottomBtnView.isHidden = true
                self.titleLbl.text = "Notice of change"
                self.statusLbl.text = "Inprocess (Waiting for approval)"
                self.titleLblView.backgroundColor = UIColor(hexString: "#3FAEFF")
            }else if AcceptAndDeclineStatus && !(isAssigned) {
                self.statusLbl.text = "Inprocess (Waiting for approval)"
                self.bottomBtnView.isHidden = true
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }else if !(AcceptAndDeclineStatus) {
                self.bottomBtnView.isHidden = true
                self.statusLbl.text = "Declined"
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }else {
                self.bottomBtnView.isHidden = false
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = "Note: Before you click that you are available, it is expected that  you will have checked your personal schedule and will be committed to provide the service.  Giving back an appointment once you have been Booked costs time and money and can lead to Botched appointments for the client and a possible termination for the interpreter. Please be sure you have no other scheduling conflicts."
            }
        }else if
            appointmentType == "Invoice Processing" {
            
            
            
            
            
            
//
//            self.venueNameView.visibility = .visible
//            self.departmentView.visibility = .visible
//            self.contactView.visibility = .visible
//            self.specialRequestsView.visibility = .visible
////            self.serviceVerificationview.visibility = .visible
//            self.AppointmentInfoLbl.visibility = .gone
            
            if apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.serviceVerificationName == nil || apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.serviceVerificationName == ""{
                
            }else {
                
            }
            
//            self.bottomBtnView.isHidden = true
//            self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
            if AcceptAndDeclineStatus {
                self.AppointmentInfoLbl.text = "Appointment Information"
                self.titleLbl.text = "Un-Available Appointment"
                self.statusLbl.text = "Un-Available Appointment(Appointment is no longer available)"
                self.titleLblView.backgroundColor = UIColor.white
                self.bottomBtnView.isHidden = true
            }else
            { self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
                self.bottomBtnView.isHidden = true
                self.venueAddressLbl.text = "\(apiData?.address ?? "") \(apiData?.city ?? "") \(apiData?.stateName ?? "") \(apiData?.zipcode ?? "")"
                
                
                self.titleLbl.text = "Booked Appointment"
                self.titleLblView.backgroundColor = UIColor.white
//                self.titleLblView.backgroundColor = UIColor.clear
                //UIColor(hexString: "#3FAEFF")
            }
        }else if appointmentType == "Late Cancelled" {
            
            
//            self.venueNameView.visibility = .visible
//            self.departmentView.visibility = .visible
//            self.contactView.visibility = .visible
//            self.specialRequestsView.visibility = .visible
            self.bottomBtnView.isHidden = true
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            if AcceptAndDeclineStatus && !(isAssigned) {
                self.titleLbl.text = "Late Cancelled"
                self.statusLbl.text = "Unavailable Appointment(Appointment is no longer available"
                self.titleLblView.backgroundColor = UIColor.white
            }else if !(AcceptAndDeclineStatus) && !(isAssigned){
                self.titleLbl.text = "Declined"
                self.titleLblView.backgroundColor = UIColor.white
            }else {
                self.titleLbl.text = "Late Cancelled"
                self.titleLblView.backgroundColor = UIColor.white
            }
        }else if appointmentType == "Invoiced" {
            self.departmentView.visibility = .visible
            self.casePatientView.visibility = .visible
            self.casePatientInitialView.visibility = .visible
            self.casePatientInitialView.visibility = .visible
            self.contactView.visibility = .visible
            self.specialRequestsView.visibility = .visible
            self.venueNameView.visibility = .visible
            self.venueAddressLbl.text = "\(apiData?.address ?? "") \(apiData?.city ?? "") \(apiData?.stateName ?? "") \(apiData?.zipcode ?? "")"
            self.bottomBtnView.isHidden = true
            self.venueAddressLbl.removeEmptyString()
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.titleLblView.backgroundColor = UIColor.white
            self.titleLbl.text = "Booked Appointment"
            self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
            
            if apiData?.myrequest == "IsUpdated"{
                self.statusLbl.text = "Invoiced"
                self.bottomBtnView.isHidden = true
                self.titleLblView.backgroundColor = UIColor.white
                self.titleLbl.text = "Booked Appointment"
            }else {
                self.statusLbl.text = "Unavailable Appointment(Appointment is no longer available)"
                self.titleLbl.text = "Booked Appointment"
                self.bottomBtnView.isHidden = true
            }
            
            
        }else if appointmentType == "Botched" {
//            self.venueNameView.visibility = .visible
//            self.departmentView.visibility = .visible
//            self.contactView.visibility = .visible
//            self.specialRequestsView.visibility = .visible
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = true
            self.titleLblView.backgroundColor = UIColor.white
            self.titleLbl.text = "Botched Appointment"
            self.importantNoteLbl.text = ""
        }else if appointmentType == "Cancelled" {
            
            if !(AcceptAndDeclineStatus) {
                self.statusLbl.text = "Declined"
                self.bottomBtnView.isHidden = true
                self.titleLbl.text = "Appointment Cancelled"
                
            } else if (AcceptAndDeclineStatus) {
                self.statusLbl.text = "Declined"
                self.bottomBtnView.isHidden = true
                self.statusLbl.text = "Unavailable Appointment(Appointment is no longer aviailable)"
                self.titleLbl.text = "Appointment Cancelled"
                
            }
            
            
            
//            self.venueNameView.visibility = .visible
//            self.departmentView.visibility = .visible
//            self.contactView.visibility = .visible
//            self.specialRequestsView.visibility = .visible
//            self.titleLbl.text = "Appointment Cancelled"
            self.titleLblView.backgroundColor = UIColor.white
          
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.importantNoteLbl.text = ""
        }else{
            
            self.titleLbl.text = "Appointment Details"
            self.titleLblView.backgroundColor = UIColor.white
            self.bottomBtnView.isHidden = true
//            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.importantNoteLbl.text = ""
        }
    }
    
    func declineRequestApi(notificationID : String , appointmentID : String , userID : String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=VendorAcceptAndDeclineStatus&NotoficationId=\(notificationID)&type=0&AppointmentID=\(appointmentID)&UserId=\(userID)&IsUpdated=&smsflog=3"
       
        //\(date)"
        print("url to get schedule declineRequestApi\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAcceptByVendorRequestDataModel = try jsonDecoder.decode(ApiAcceptByVendorRequestDataModel.self, from: daata)
                        print("Success")
                        print("ApiAcceptByVendorRequestDataModel DATA IS \(self.apiAcceptByVendorRequestDataModel)")
                        let showMessage = self.apiAcceptByVendorRequestDataModel?.vendorAcceptAndDeclineStatus?.first?.message ?? ""
                        let alert = UIAlertController(title: "Confirmation", message: showMessage, preferredStyle: .alert)
                            
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                             })
                             alert.addAction(ok)
                             DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                        })
                    }
                    catch
                    {
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    func acceptRequestApi(notificationID : String , appointmentID : String , userID : String ){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=VendorAcceptAndDeclineStatus&NotoficationId=\(notificationID)&type=1&AppointmentID=\(appointmentID)&UserId=\(userID)&IsUpdated=&smsflog=3"
       
        //\(date)"
        print("url to get schedule getOnsiteData\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiAcceptByVendorRequestDataModel = try jsonDecoder.decode(ApiAcceptByVendorRequestDataModel.self, from: daata)
                        print("Success")
                        print("ApiAcceptByVendorRequestDataModel DATA IS \(self.apiAcceptByVendorRequestDataModel)")
                        let showMessage = self.apiAcceptByVendorRequestDataModel?.vendorAcceptAndDeclineStatus?.first?.message ?? ""
                        let alert = UIAlertController(title: "Confirmation", message: showMessage, preferredStyle: .alert)
                            
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.popViewController(animated: true)
                             })
                             alert.addAction(ok)
                             DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                        })
                    }
                    catch
                    {
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
}

extension NewAppointmentDetailsVC{
    func getOnsiteData(customerId:String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(customerId)&UserType=Vendor&Userid=\(customerId)"
       
        //\(date)"
        print("url to get schedule getOnsiteData\(urlString)")
        AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseData(completionHandler: { [self] (response) in
                SwiftLoader.hide()
                switch(response.result){
                    
                case .success(_):
                    print("Respose Success ")
                    guard let daata = response.data else { return }
                    do {
                        let jsonDecoder = JSONDecoder()
                        self.apiOnsiteDetailsResponseModel = try jsonDecoder.decode(ApiOnsiteDetailsResponseModel.self, from: daata)
                        print("Success")
                        print("ApiGetVRIScheduleDataResponseMdel DATA IS \(self.apiOnsiteDetailsResponseModel)")
                        let apiData = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first
                        print("apiGetVRIScheduleDataResponseMdel \(self.apiOnsiteDetailsResponseModel)")
                        if apiData?.serviceVerificationName == nil || apiData?.serviceVerificationName == ""{
                            serviceVerificationview.visibility = .gone
                        }
                        else {
                            serviceVerificationview.visibility = .visible
                        }
                        self.languageLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.languageName ?? "N/A"
                        self.fileName = apiData?.serviceVerificationName ?? ""
                        self.interpreterNameLbl.text = apiData?.interpretorName ?? "N/A"
                        //self.customerNameLbl.text = apiData?.customerName ?? "N/A"
                        self.authenticationCodelbl.text = apiData?.authCode ?? "N/A"
                        self.serviceTypeLbl.text = apiData?.appointmentType ?? "N/A"
                        self.venueNameLbl.text = apiData?.venueName ?? "N/A"
                        self.venueAddressLbl.text = "\(apiData?.city ?? "") \(apiData?.stateName ?? "")"
                        self.venueAddressLbl.removeEmptyString()
                        if apiData?.appointmentType != "Onsite Interpretation"{
                            self.venueAddressLbl.text = "N/A"
                        }
                        self.departmentLbl.text = apiData?.departmentName ?? "N/A"
                        self.contactLbl.text = apiData?.providerName ?? "N/A"
                        self.specialityLbl.text = apiData?.specialityName ?? "N/A"
//                        self.patientLbl.text = apiData?.caseNumber ?? "N/A"
                        if apiData?.caseNumber != nil && apiData?.caseNumber != "" {
                            self.patientLbl.text = apiData?.caseNumber
                        } else {
                            self.patientLbl.text = "N/A"
                        }
                        
                        
//                        self.patientInitialLbl.text = apiData?.cPIntials ?? "N/A"
                        if apiData?.cPIntials != nil && apiData?.cPIntials != "" {
                            self.patientInitialLbl.text = apiData?.cPIntials
                        } else {
                            self.patientInitialLbl.text = "N/A"
                        }
                        
                        
                        
                        
                        
//                        if apiData?.cPIntials != nil && apiData?.cPIntials != "" {
//                            self.patientInitialLbl.text = apiData?.cPIntials
//                        } else {
//                            self.patientInitialLbl.text = "N/A"
//                        }
                        
                        
                        if apiData?.aptDetails != nil && apiData?.aptDetails != "" {
                            self.descriptionLbl.text = apiData?.aptDetails
                        } else {
                            self.descriptionLbl.text = "N/A"
                        }
                        
                        
                        
//                        self.descriptionLbl.text = apiData?.aptDetails ?? "N/A"
                        changeTitleLabel(appointmentType: apiData?.appointmentStatusType ?? "", AcceptAndDeclineStatus: apiData?.acceptAndDeclineStatus ?? false ,isAssigned : apiData?.isAssigned ?? false , IsExpired: apiData?.isExpired ?? false , companyName: apiData?.companyName ?? "")
                        self.timeView.visibility = .gone
                        self.dateLbl.text = "\(self.convertTimeFormaterOnlyDate(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? "")) \(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? ""))-\(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.endDateTime ?? ""))"
                        
                        self.timeLbl.text = "\(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? ""))-\(self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.endDateTime ?? ""))"
                        
//                        self.specialRequestsLbl.text = apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.text ?? "N/A"
                        
                        if apiData?.text != nil && apiData?.text != "" {
                            self.specialRequestsLbl.text = apiData?.text
                        } else {
                            self.specialRequestsLbl.text = "N/A"
                        }
                        
                        
                        self.statusLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.appointmentStatusType ?? "N/A"
                    }
                    catch
                    {
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
}

extension NewAppointmentDetailsVC{
    func convertDateAndTimeFormat(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    
    func convertTimeFormaterOnlyDate(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
     
    
}



extension UILabel {
    
    func removeEmptyString(){
        
        if self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == nil{
            self.text = "N/A"
        }
        
    }
    
    
}
