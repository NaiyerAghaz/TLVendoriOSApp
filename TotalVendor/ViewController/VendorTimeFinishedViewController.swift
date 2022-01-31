//
//  VendorTimeFinishedViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import Alamofire

class vendortimeofftableViewCell:UITableViewCell {
    
    @IBOutlet weak var uploadDocumentCell: MIBadgeButton!
    
    @IBOutlet weak var processBtn: UIButton!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var appointmentDateLbl: UILabel!
    @IBOutlet weak var jobTypeLbl: UILabel!
    @IBOutlet weak var languageNameLbl: UILabel!
    @IBOutlet var statusOfAppointmentLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var authCodeLbl: UILabel!
}
class VendorTimeFinishedViewController: UIViewController  {
    
    
    
    
    @IBOutlet weak var companyLogoImage: UIImageView!
    
    @IBOutlet weak var topViewOutlet: UIView!
    
    @IBOutlet weak var nodataLbl: UILabel!
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    
    @IBOutlet weak var companyNameLbl: UILabel!
    
//    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var vendorTimeOffTV: UITableView!
    var miDate = Calendar.current.date(byAdding: .year, value: -50, to: Date())
    var apiScheduleAppointmentResponseModel : ApiCalendarDataResponseModel?
    var apiVendorTimeFinishResponseModel:ApiVendorTimeFinishResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.CompanyLogo) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.companyLogoImage.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.companyLogoImage.image = UIImage(named: "logo")
        }
 
       
        
        companyNameLbl.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
//        topViewOutlet.addBottomShadow()
        vendorTimeOffTV.delegate = self
        vendorTimeOffTV.dataSource = self
        let abc = Date()
       
        let startDate =   abc.dateString("MM/dd/yyyy")
        let endDate =   abc.dateString("MM/dd/yyyy")
        startDateTF.text = startDate
        endDateTF.text = startDate
        getTimeFinishData(startDate: startDate, endDate: endDate)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSearch(_ sender: UIButton) {
        if self.startDateTF.text == "" {
            self.view.makeToast("Please fill Start Date.")
            return
        }else if self.endDateTF.text == "" {
            self.view.makeToast("Please fill End Date.")
            return
        }else {
            let startDate = startDateTF.text ?? ""
            let endDate = endDateTF.text ?? ""
            getTimeFinishData(startDate: startDate, endDate: endDate)
        }
        
    }
    @IBAction func selectStartDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.startDateTF.text = selectedDate.dateString("MM/dd/YYYY")
                         
                    })
        
    }
    @IBAction func selectEndDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date & Time", cancelText: "Cancel", datePickerMode: .date, minDate: miDate, maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
                        // TODO: Your implementation for date
                        self?.endDateTF.text = selectedDate.dateString("MM/dd/YYYY")
                         
                    })
    }
    func getTimeFinishData(startDate: String , endDate : String ){
        SwiftLoader.show(animated: true)
        self.apiVendorTimeFinishResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
        //01/07/2021  MM/dd/yyyy
        let urlString = "https://lsp.totallanguage.com/VendorManagement/VendorTimeFinished/GetCommonData?methodType=GETNEWTIMEFINISHEDLIST&CompanyID=\(companyID)&VendorId=\(userId)&UserType=Vendor&UserID=\(userId)&TimeFinished=BOOKEDANDTIME&FilterCount=1000&StartDateTime=\(startDate)&EndDateTime=\(endDate)&RowNumber=0&Filter_RowNumber=1000"
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
                                self.apiVendorTimeFinishResponseModel = try jsonDecoder.decode(ApiVendorTimeFinishResponseModel.self, from: daata)
                               print("Success apiGetVendorDetail Model \(self.apiVendorTimeFinishResponseModel)")
                                
                                DispatchQueue.main.async {
                                    self.vendorTimeOffTV.reloadData()
                                }
                                
                            } catch{
                                
                                print("error block apiGetVendorDetail Data  " ,error)
                            }
                        case .failure(_):
                            print("Respose Failure apiGetVendorDetail")
                           
                        }
                })
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

//MARK: - Table Work
extension VendorTimeFinishedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let count = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?.count ?? 0
        if count == 0 {
            self.nodataLbl.text = "No Record Found"
            self.nodataLbl.isHidden = false
            self.vendorTimeOffTV.isHidden = true
        }else {
            self.nodataLbl.isHidden = true
            self.vendorTimeOffTV.isHidden = false
        }
        print("connt " , count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vendortimeofftableViewCell") as! vendortimeofftableViewCell
        let indx = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[indexPath.row]
        cell.customerNameLbl.text = indx?.customerName ?? ""
        cell.authCodeLbl.text = indx?.authCode ?? ""
        cell.jobTypeLbl.text = indx?.appointmentType ?? ""
        cell.languageNameLbl.text = indx?.languageName ?? ""
        print("APPOINTMENT ID FOR INDEX \(indexPath.row + 1) and Appointment ID is \(indx?.appointmentID ?? 0)")
        //let appointmentDate = indx
        cell.statusOfAppointmentLbl.text = " \(indx?.appointmentStatusType ?? "N/A") "
        cell.appointmentDateLbl.text = convertDateFormater(indx?.startDateTime ?? "")
        let startTime = indx?.startDateTime ?? ""
        let endTime = indx?.endDateTime ?? ""
        cell.startTimeLbl.text = convertTimeFormater(startTime)
        cell.endTimeLbl.text = convertTimeFormater(endTime)
        if indx?.vendorFilecounts ?? 0>0{
            
            cell.uploadDocumentCell.isHidden=false
            cell.uploadDocumentCell.badgeString = "\(indx?.vendorFilecounts ?? 0)"
        }else {
            cell.uploadDocumentCell.isHidden=true
        }
        cell.processBtn.tag = indexPath.row
        cell.processBtn.addTarget(self, action: #selector(openProcessScreen(sender:)), for: .touchUpInside)
        cell.uploadDocumentCell.tag = indexPath.row
        cell.uploadDocumentCell.addTarget(self, action: #selector(uploadDocumentsTapped(sender:)), for: .touchUpInside)
        
        ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ statusDetail in
            if statusDetail.code == indx?.appointmentStatusType {
                //cell.statusOuterView.backgroundColor = UIColor(hexString: statusDetail.color!)
                cell.statusOfAppointmentLbl.backgroundColor = UIColor(hexString: statusDetail.color!)
            }
        })
        return cell
    }
    
    @objc func uploadDocumentsTapped(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadedDocumentsVC") as! UploadedDocumentsVC
        vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
        vc.isModalInPresentation = true
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func openProcessScreen(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VendorTimeFinishDetailsVC") as! VendorTimeFinishDetailsVC
        vc.modalPresentationStyle = .fullScreen
        vc.appointmentID = self.apiVendorTimeFinishResponseModel?.gETNEWTIMEFINISHEDLIST?[sender.tag].appointmentID ?? 0
        self.present(vc, animated: true, completion: nil)
    }

    
    
    func convertDateFormater(_ date: String) -> String
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




extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    func changeDateString(_ format: String = "MM/dd/YYYY hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
     
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIView {
func addBottomShadow() {
    layer.masksToBounds = false
    layer.shadowRadius = 4
    layer.shadowOpacity = 1
    layer.shadowColor = UIColor.red.cgColor
    layer.shadowOffset = CGSize(width: 0 , height: 0.5)
    layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: bounds.maxY - layer.shadowRadius,
                                                 width: bounds.width,
                                                 height: layer.shadowRadius)).cgPath
}
}

