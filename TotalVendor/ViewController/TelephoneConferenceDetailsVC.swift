//
//  TelephoneConferenceDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 29/12/21.
//

import UIKit
import Alamofire

class TelephoneConferenceDetailsVC: UIViewController {
    @IBOutlet weak var interpreterNameLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var specialRequestsView: UIView!
    
    @IBOutlet weak var casePatientInitialView: UIView!
    
    @IBOutlet weak var casePatientView: UIView!
    
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
    var serviceType = ""
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var venueAddressLbl: UILabel!
    @IBOutlet weak var venueNameLbl: UILabel!
    @IBOutlet weak var importantNoteLbl: UILabel!
    var apiOnsiteDetailsResponseModel : ApiOnsiteDetailsResponseModel?
    var appointmentID = 0
    var fileName = ""
    var apiAcceptByVendorRequestDataModel:ApiAcceptByVendorRequestDataModel?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomBtnView: UIStackView!
    @IBOutlet weak var importtentLblView: UIView!
    @IBOutlet weak var serviceVerificationview: UIView!
    @IBOutlet weak var AppointmentInfoLbl: UILabel!
    
    
    @IBOutlet weak var titleLblView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.specialRequestsView.visibility = .gone
        self.casePatientInitialView.visibility = .gone
        self.casePatientView.visibility = .gone
        
        
        let userId = userDefaults.string(forKey: UserDeafultsString.instance.UserID) ?? ""
        
        self.getOnsiteData(customerId: userId)
     
    }
    @IBAction func backBtnTapped(){
        self.navigationController?.popViewController(animated: true)
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
}

extension TelephoneConferenceDetailsVC{
    func getOnsiteData(customerId:String){
        SwiftLoader.show(animated: true)
        let urlString =   "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(customerId)&UserType=Vendor&Userid=\(customerId)"
       
        //\(date)"
        print("url to get schedule \(urlString)")
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
                        
                        self.languageLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.languageName ?? "N/A"
                       
                        self.interpreterNameLbl.text = apiData?.interpretorName ?? "N/A"
                        //self.customerNameLbl.text = apiData?.customerName ?? "N/A"
                        self.authenticationCodelbl.text = apiData?.authCode ?? "N/A"
                        self.serviceTypeLbl.text = apiData?.appointmentType ?? "N/A"
//                        self.venueNameLbl.text = apiData?.venueName ?? "N/A"
//                        self.venueAddressLbl.text = apiData?.vendorAddress ?? "N/A"
//                        self.departmentLbl.text = apiData?.departmentName ?? "N/A"
                        self.contactLbl.text = apiData?.contactName ?? "N/A"
                        self.specialityLbl.text = apiData?.specialityName ?? "N/A"
                        self.patientLbl.text = apiData?.caseNumber ?? "N/A"
                        self.patientInitialLbl.text = apiData?.cPIntials ?? "N/A"
                        self.descriptionLbl.text = apiData?.aptDetails ?? "N/A"
                        self.dateLbl.text = self.convertTimeFormaterOnlyDate(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? "")
                        
                        self.timeLbl.text = self.convertTimeFormater(apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.startDateTime ?? "")
                        
                        self.specialRequestsLbl.text = apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.text ?? "N/A"
                        self.statusLbl.text = self.apiOnsiteDetailsResponseModel?.appointmentInterpreterData?.first?.appointmentStatusType ?? "N/A"
                        
                        changeTitleLabel(appointmentType: apiData?.appointmentStatusType ?? "", AcceptAndDeclineStatus: apiData?.acceptAndDeclineStatus ?? false ,isAssigned : apiData?.isAssigned ?? false , IsExpired: apiData?.isExpired ?? false , companyName: apiData?.companyName ?? "")
                        
                        
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
    
    func changeTitleLabel(appointmentType : String , AcceptAndDeclineStatus : Bool , isAssigned : Bool , IsExpired: Bool,companyName : String ){
        var  appointmentColor = ""
        print("Total public count ", GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.count ?? 0 )
        GetPublicData.sharedInstance.apiGetSpecialityDataModel?.appointmentStatus?.forEach({ (AppointmentStatusData) in
            
            if AppointmentStatusData.value == appointmentType {
                appointmentColor = AppointmentStatusData.color ?? ""
                self.statusLbl.textColor = UIColor(hexString: appointmentColor)
            }
        })
        print("appointment Type and color ", appointmentType , appointmentColor)
        if appointmentType == "Booked" {
            self.serviceVerificationview.visibility = .visible
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = true
            if !(AcceptAndDeclineStatus) && !(isAssigned) {
                self.titleLbl.text = "Un-Avialable Appointment"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
                
            }else if AcceptAndDeclineStatus && !(isAssigned) {
                self.titleLbl.text = "Un-Avialable Appointment"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
            }else if AcceptAndDeclineStatus && isAssigned {
                self.titleLbl.text = "Booked Appointment"
                self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
            }else if IsExpired && !(isAssigned) {
                self.titleLbl.text = "Un-Avialable Appointment"
                self.titleLblView.backgroundColor = UIColor.white
                self.importantNoteLbl.text = ""
            }else if !(IsExpired) && isAssigned {
                self.titleLbl.text = "Booked Appointment"
                self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
            }else {
                self.importantNoteLbl.text = ""
                self.titleLbl.text = "Booked Appointment"
                self.titleLblView.backgroundColor = UIColor(hexString: appointmentColor)
            }
        }else if appointmentType == "Not Booked" {
            self.bottomBtnView.isHidden = false
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .visible
            self.AppointmentInfoLbl.text = "\(companyName)has sent you INQUIRY. Please check your availability and select the option below to indicate if you are available or have to decline the work."
            self.importantNoteLbl.text = "Note: Before you click that you are available, it is expected that  you will have checked your personal schedule and will be committed to provide the service.  Giving back an appointment once you have been Booked costs time and money and can lead to Botched appointments for the client and a possible termination for the interpreter. Please be sure you have no other scheduling conflicts."
            if AcceptAndDeclineStatus {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
                
            }else {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }
        }else if appointmentType == "InProcess" {
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = false
            self.importantNoteLbl.text = "Note: Before you click that you are available, it is expected that  you will have checked your personal schedule and will be committed to provide the service.  Giving back an appointment once you have been Booked costs time and money and can lead to Botched appointments for the client and a possible termination for the interpreter. Please be sure you have no other scheduling conflicts."
            if AcceptAndDeclineStatus && isAssigned {
                self.titleLbl.text = "Notice of change"
                self.titleLblView.backgroundColor = UIColor(hexString: "#3FAEFF")
            }else if AcceptAndDeclineStatus && !(isAssigned) {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }else if !(AcceptAndDeclineStatus) {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }else {
                self.titleLbl.text = "Availability Inquiry"
                self.titleLblView.backgroundColor = UIColor.white
            }
        }else if appointmentType == "Invoice Processing" {
            self.serviceVerificationview.visibility = .visible
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = true
            self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
            if AcceptAndDeclineStatus {
                self.AppointmentInfoLbl.text = "Appointment Information"
                self.titleLbl.text = "Un-Avialable Appointment"
                self.titleLblView.backgroundColor = UIColor(hexString: "#3FAEFF")
            }else {
                self.titleLbl.text = "Booked Appointment"
                self.titleLblView.backgroundColor = UIColor(hexString: "#3FAEFF")
            }
        }else if appointmentType == "Late Cancelled" {
            self.bottomBtnView.isHidden = true
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            if AcceptAndDeclineStatus && !(isAssigned) {
                self.titleLbl.text = "Late Cancelled"
                self.titleLblView.backgroundColor = UIColor.white
            }else {
                self.titleLbl.text = "LateCancelled Appointment"
                self.titleLblView.backgroundColor = UIColor.white
            }
        }else if appointmentType == "Invoiced" {
            self.bottomBtnView.isHidden = true
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.titleLblView.backgroundColor = UIColor.white
            self.titleLbl.text = "LateCancelled Appointment"
            self.importantNoteLbl.text = "*** Important:  Please note that an interpreter cannot cancel/return an appointment without speaking to someone at \(companyName) directly.  Not via email nor voicemail.  All returns are to be discussed with \(companyName) Scheduling staff. ***"
        }else if appointmentType == "Botched" {
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.bottomBtnView.isHidden = true
            self.titleLblView.backgroundColor = UIColor.white
            self.titleLbl.text = "Botched Appointment"
            self.importantNoteLbl.text = ""
        }else if appointmentType == "Cancelled" {
            self.titleLbl.text = "Cancelled Appointment"
            self.titleLblView.backgroundColor = UIColor.white
            self.bottomBtnView.isHidden = true
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.importantNoteLbl.text = ""
        }else{
            self.titleLbl.text = "Appointment Details"
            self.titleLblView.backgroundColor = UIColor.white
            self.bottomBtnView.isHidden = true
            self.serviceVerificationview.visibility = .gone
            self.AppointmentInfoLbl.visibility = .gone
            self.importantNoteLbl.text = ""
        }
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
                        let alert = UIAlertController(title: "Total Language", message: showMessage, preferredStyle: .alert)
                            
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
                        let alert = UIAlertController(title: "Total Language", message: showMessage, preferredStyle: .alert)
                            
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

extension TelephoneConferenceDetailsVC{
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
