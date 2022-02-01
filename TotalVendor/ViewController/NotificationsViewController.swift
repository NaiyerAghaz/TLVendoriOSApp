//
//  NotificationViewController.swift
//  TLClientApp
//
//  Created by Mac on 12/10/21.
//




import UIKit
import Alamofire
import SwiftDate
class NotificationTableViewCell:UITableViewCell{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var notificationWebview: UIWebView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var notificationLbl: UILabel!
    @IBOutlet var notificationTV: UITableView!
    override func awakeFromNib() {
        self.notificationWebview.scrollView.isScrollEnabled = false
        self.mainView.addShadowGrey()
    }
}
class NotificationViewController: UIViewController {
    @IBOutlet weak var filterTV: UITableView!
    @IBOutlet weak var filterView: UIView!
    var filterSearch = [FilterSearch]()
     var statusFilterSearch = ""

    @IBOutlet var notificationTV: UITableView!
    @IBOutlet var countLbl: UILabel!
    var apiNotificationDetailResponseModel:ApiNotificationResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.notificationTV.delegate = self
        self.notificationTV.dataSource = self
        getNotificatioDetail()
    }
    
   
    @IBAction func actionBackButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getNotificatioDetail(){
        SwiftLoader.show(animated: true)
        self.apiNotificationDetailResponseModel = nil
        let userId = UserDefaults.standard.value(forKey: UserDeafultsString.instance.UserID) ?? "0"
        let companyID = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyID) ?? "0"
      
        let urlString = "https://lsp.totallanguage.com/Home/GetData?methodType=NotificationsByUsername&UserID=\(userId)&CompanyID=\(companyID)&SortOrder=Desc&RowNumber=0&AppID=0"
        print("url to get notificationDetail  \(urlString)")
                AF.request(urlString, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil)
                    .validate()
                    .responseData(completionHandler: { [self] (response) in
                        SwiftLoader.hide()
                        switch(response.result){
                        case .success(_):
                            print("Respose Success Notification Data ")
                            guard let daata = response.data else { return }
                            do {
                                let jsonDecoder = JSONDecoder()
                                self.apiNotificationDetailResponseModel = try jsonDecoder.decode(ApiNotificationResponseModel.self, from: daata)
                               print("Success notification Model \(self.apiNotificationDetailResponseModel)")
                                let count = self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
                                self.countLbl.text = "No. of Record \(count)"
                                DispatchQueue.main.async {
                                    self.notificationTV.reloadData()
                                }
                            } catch{
                                
                                print("error block notification Data  " ,error)
                            }
                            
                        case .failure(_):
                            print("Respose Failure ")
                           
                        }
                })
     }
    
    func conertDateString(time :Double ) -> String{
        print("MILI SECONDS IS \(time)")
      //        let milisecond = 1479714427
              let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(time)/1000)
              let dateFormatter = DateFormatter()
              dateFormatter.locale = Locale(identifier: "en_US")
              dateFormatter.dateFormat = "dd-MM-yyyy"
              print(dateFormatter.string(from: dateVar))
              let timeConverted = (dateFormatter.string(from: dateVar))
              return timeConverted
    }

    

}
extension NotificationViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("APII NOTIFICATION DATA COUNT IS \(self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0)")
        return self.apiNotificationDetailResponseModel?.notificationsByUsername?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
       //self.apiPrivacyPolicyResponseModel?.term_payload?.text?.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Muli", size: 16), csscolor: "white", lineheight: 5, csstextalign: "left")
        let indx = self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row]
        let abcDate = indx?.createDate?.digits
        let dateString = self.getTimefromTimeStamp(timeStamp: abcDate ?? "")
        print("date ms is \(indx?.createDate)")
        //let actualDate = conertDateString(time: Double(date) ?? 0)
              // "Apr 16, 2015, 2:40 AM"
        print("Converted Time \(dateString)")
        cell.dateLbl.text = dateString //actualDate
        cell.dateLbl.textColor = UIColor.gray
        let appStatus = indx?.appStatus ?? ""
        ColourResponse.sharedInstance.apiCalendarDataResponseModel?.appointmentStatus?.forEach({ (appointmentStatus) in
                        if  appointmentStatus.code == appStatus {
                            cell.notificationLbl.text = appStatus
                            let color = appointmentStatus.color ?? ""
                            cell.notificationLbl.textColor = UIColor(hexString: color)
                        }
                    })
        /*
        let subStatus = indx?.subStatus ?? ""
        let notificationStringa = indx?.notification ?? ""
        var arr = notificationStringa.components(separatedBy: ",")
        print("array count is \(arr.count)")
        if arr.count == 9 {
            arr.remove(at: 3)
            arr.remove(at: 4)
            arr.remove(at: 4)
        }
        if arr.count == 13 {
            arr.remove(at: 3)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
            arr.remove(at: 4)
        }
        let newString = arr.joined(separator: ",")
        print("newString \(newString)")
        let prefix = "<style>table,th,td{border:1px solid black;}table{width:100%}</style><body>"
        //let a1 = prefix +  notificationStringa.replacingOccurrences(of: "#: <b>Job Type:", with: "<table><tr><th>Job Type</th><td>")
        let a1 = prefix +  newString.replacingOccurrences(of: "#: <b>Job Type:", with: "<table><tr><th>Job Type</th><td>")
       
        let a2 = a1.replacingOccurrences(of: ", AuthCode:", with: "</td></tr><tr><th>AuthCode</th><td>")
        let a3 = a2.replacingOccurrences(of: ", Start Time:", with: "</td></tr><tr><th>Start Time</th><td>")
        let a4 = a3.replacingOccurrences(of: ", EndTime:", with: "")
        let a5 = a4.replacingOccurrences(of: ", Venue:", with: "</td></tr><tr><th>Venue</th><td>")
        let a6 = a5.replacingOccurrences(of: " Department:", with: "")
        let a7 = a6.replacingOccurrences(of: ", Provider:", with: "")
        let a8 = a7.replacingOccurrences(of: ", Language:", with: "</td></tr><tr><th>Language</th><td>")
        let a9 = a8.replacingOccurrences(of: ", InterPreter:", with: "</td></tr><tr><th>Interpreter</th><td>")
        let a10 = a9.replacingOccurrences(of: "</b>.", with: "</td></tr></table></body>")
        print("Index \(indexPath.row) and new string is \(a10)")
        */
        let abcString = indx?.notification ?? ""
        var notif4 = abcString.replacingOccurrences(of: "#: <b>", with: "<table border=1 style=font-size:6vw;border-collapse:collapse; ><tr><td><b>")
        var notif5 = notif4.replacingOccurrences(of: ": ", with: "</b></td><td>")
        var notif6 = notif5.replacingOccurrences(of: ",", with: "</td></tr><tr><td><b>")
        var notif7 = notif6.replacingOccurrences(of: "</b>.", with: "</b></td></tr></table>")
        cell.notificationWebview.loadHTMLString(notif7, baseURL: nil)
       // let notificationString = a10.convertHtmlToAttributedStringWithCSS(font: UIFont.systemFont(ofSize: 16) , csscolor: "Black", lineheight: 5, csstextalign: "left")
        cell.notificationLbl.text = indx?.appStatus ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "BookingDetailViewController") as! BookingDetailViewController
        
        vc.appointmentID = self.apiNotificationDetailResponseModel?.notificationsByUsername?[indexPath.row].appointmentID ?? 0
        vc.isComeFromBooking = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func getTimefromTimeStamp(timeStamp: String ) -> String {
            let t = Int(timeStamp) ?? 0/1000
            let unixTimestamp = "\(t)"
            print("unixTimestamp",unixTimestamp , t )
           //"\(1622138536)"   1638360102567
            let epochTime = TimeInterval(t) / 1000
           // let date6 = Date(timeIntervalSince1970: epochTime)
            let ddate = Date(timeIntervalSince1970: epochTime)
            print("date from timestamp is ",ddate )
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatterGet.string(from: ddate)
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
            dateFormatterPrint.dateFormat = "MM/dd/yyyy hh:mm a"
            let date: NSDate? = dateFormatterGet.date(from: dateString) as NSDate?
             let currentdate = dateFormatterPrint.string(from: date! as Date)
            
                print("date converted is ", currentdate)
            return currentdate
        }
}

class StatusFilterTableViewCell : UITableViewCell{
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var titleImg: UIImageView!
}



class TestNav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIView{
    func addShadowGrey(){
            self.layer.borderWidth = 0.0
            self.layer.masksToBounds = false
            self.layer.shadowRadius = 4.0
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowOpacity = 0.4
            self.layer.cornerRadius = 10
        }
}

extension String{
    var digits: String {
                return components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
            }
}

struct FilterSearch{
    var name: String = ""
    var searchSelect : Bool = false
}





//let urlString = "https://lsp.smsionline.com/Home/GetData?methodType=NotificationsByUsername&UserID=\(userId)&CompanyID=\(companyID)&SortOrder=Desc&RowNumber=0&AppID=0"
