//
//  VendorTimeFinishDetailsVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 20/01/22.
//

import UIKit
import Alamofire
import AASignatureView
import UIView_draggable

class VendorTimeFinishDetailsVC: UIViewController {

    @IBOutlet weak var maneSVSuperView: UIView!
    
    @IBOutlet weak var signatureView: AASignatureView!
    
    @IBOutlet weak var selectedImgImgView: UIImageView!
    
    @IBOutlet weak var signatureViewImgView: UIImageView!
    
    
    
    
    @IBOutlet weak var startTimeTF: UITextField!
    
    @IBOutlet weak var endTimeTF: UITextField!
    
    @IBOutlet weak var bookingStatusLbl: UILabel!
    @IBOutlet weak var authCodeLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    var apiGetVendorTimeFinishedDetailsApiResponseModel : ApiGetVendorTimeFinishedDetailsApiResponseModel?
    var appointmentID = 0
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var patientInitialLbl: UILabel!
    @IBOutlet weak var documentsTV: UITableView!
    
    
    @IBOutlet weak var signatureSuperView2: UIView!
    
    override func viewDidLoad() {
        self.signatureViewImgView.enableDragging()
        self.selectedImgImgView.contentMode = .scaleAspectFill
        self.maneSVSuperView.isHidden=true
        super.viewDidLoad()
        documentsTV.delegate=self
        documentsTV.dataSource=self
        self.startTimeTF.visibility = .gone
        self.endTimeTF.visibility = .gone
        self.getTimeFinishedDetailsApiData()
    }
    
    @IBAction func startTimeBtnTapped(_ sender: Any) {
        self.startTimeTF.visibility = .visible
    }
    
    @IBAction func endTimeBtnTapped(_ sender: Any) {
        self.endTimeTF.visibility = .visible
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if let image = signatureView.signature {
        // captured image of signature view
            signatureViewImgView.image = image
            self.signatureSuperView2.isHidden = true
        }
        
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        signatureView.clear()
    }
    
    
    @IBAction func uploadBtnTapped(_ sender: Any) {
        DispatchQueue.main.async {
            CameraHandler.shared.showActionSheet(vc: self)
            CameraHandler.shared.imagePickedBlock = { (image) in
                /* get your image here */
                self.selectedImgImgView.image = image
                self.maneSVSuperView.isHidden = false
            }
        }
        
     
    }
    
    
    
    
}

extension VendorTimeFinishDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTV.dequeueReusableCell(withIdentifier: "VendorFinishDetailDocumentCell", for: indexPath) as! VendorFinishDetailDocumentCell
        return cell
    }
    
 
}

extension VendorTimeFinishDetailsVC{
    
    func decimalHoursConv (hours : Double) -> (_hrs:String, mins:String) {
        let remainder = hours.truncatingRemainder(dividingBy: 1) * 60
        let mins = (String(format: "%.0f", remainder))

        let hours = hours.rounded(.towardZero)
        let hrs = (String(format: "%.0f", hours))
        return (hrs, mins)
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
}

extension VendorTimeFinishDetailsVC{
    
    func getTimeFinishedDetailsApiData(){
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
              //01/07/2021  MM/dd/yyyy  SwiftLoader.show(animated: true)
      
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=AppointmentInterpreterData&NotoficationId=0&AppointmentID=\(appointmentID)&Interpreterid=\(userId)&UserType=Vendor&Userid=\(userId)"
        print("url to get apiGetVendorDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        
                        case .success(_):
                            print("Respose Success apiGetVendorDetail Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiGetVendorTimeFinishedDetailsApiResponseModel = try jsonDecoder.decode(ApiGetVendorTimeFinishedDetailsApiResponseModel.self, from: daata)
                                let apiData = self.apiGetVendorTimeFinishedDetailsApiResponseModel?.appointmentInterpreterData?.first
                                self.authCodeLbl.text = apiData?.authCode ?? "N/A"
                                self.customerNameLbl.text = apiData?.customerName ?? "N/A"
                                self.startTimeLbl.text = self.convertTimeFormater(apiData?.startDateTime ?? "")
                                self.endTimeLbl.text = self.convertTimeFormater(apiData?.endDateTime  ?? "N/A")
                                self.nameLbl.text = (apiData?.venueName ?? "N/A")
                                self.addressLbl.text = (apiData?.address ?? "N/A")
                                self.cityLbl.text = apiData?.city ?? "N/A"
                                self.stateLbl.text = apiData?.stateName ?? "N/A"
                                self.zipCodeLbl.text = apiData?.zipcode ?? "N/A"
                                let abc = self.decimalHoursConv(hours: apiData?.duration ?? 0.00)
                                
                                self.durationLbl.text = "\(abc._hrs)Hrs : \(abc.mins)Mins"
                                self.departmentLbl.text = apiData?.departmentName ?? "N/A"
                                self.rateLbl.text = apiData?.oSPerHourFee ?? "0"
                                self.contactLbl.text = apiData?.contactName ?? "N/A"
                                self.languageLbl.text = apiData?.languageName ?? "N/A"
                                self.patientInitialLbl.text = apiData?.clientInitial ?? "N/A"
                                
                               print("Success apiGetVendorDetail Model \(self.apiGetVendorTimeFinishedDetailsApiResponseModel)")
                            } catch{
                                
                                print("error block apiGetVendorDetail Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure apiGetVendorDetail")
                        }
                })
     }
    
}

class VendorFinishDetailDocumentCell:UITableViewCell{
    
    @IBOutlet weak var documentImgView: UIImageView!
    @IBOutlet weak var documentNameLbl: UILabel!

    
}
