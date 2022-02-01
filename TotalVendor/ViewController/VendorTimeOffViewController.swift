//
//  VendorTimeOffViewController.swift
//  TotalVendor
//
//  Created by Darrin Brooks on 12/08/21.
//

import UIKit
import Alamofire

class VendorTimeOffViewController: UIViewController {
    var Live_BASE_URL = "https://lsp.totallanguage.com/"
    @IBOutlet weak var companyLogoIcon: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var vendorTimeOffTV: UITableView!
    var apiVendorTimeOffResponseModel : ApiVendorTimeOffResponseModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageData = (userDefaults.value(forKey: UserDeafultsString.instance.CompanyLogo) ?? "")
        let finalData = "\(Live_BASE_URL)\(imageData)"
        print("FINAL DATA IS \(finalData)")
        if imageData as! String != "" {
            self.companyLogoIcon.sd_setImage(with: URL(string: finalData), completed: nil)
        }else {
            self.companyLogoIcon.image = UIImage(named: "logo")
        }
        vendorTimeOffTV.delegate=self
        vendorTimeOffTV.dataSource=self
        userNameLbl.text = UserDefaults.standard.value(forKey: UserDeafultsString.instance.CompanyName) as? String ?? ""
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getVendorTimeOffData()
    }
    
    
    
}

extension VendorTimeOffViewController{
    func getVendorTimeOffData(){
        SwiftLoader.show(animated: true)
        let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0

        let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
        let urlString = "https://lsp.totallanguage.com/VendorManagement/VendorTimeOff/GetData?methodType=VENDORTIMEOFFDATA&VendorID=\(userID)&CompanyId=\(companyID)&UserID=\(userID)"//\(date)"
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
                        self.apiVendorTimeOffResponseModel = try jsonDecoder.decode(ApiVendorTimeOffResponseModel.self, from: daata)
                        print("Success")
                        print("getVendorTimeOffData DATA IS \(self.apiVendorTimeOffResponseModel)")
                        DispatchQueue.main.async {
                            self.vendorTimeOffTV.reloadData()
                        }
                       
                        

                    } catch{
                        print("error block forgot password " ,error)
                    }
                case .failure(_):
                    print("Respose Failure ")
                    
                }
            })
    }
    
    func convertDateAndTimeFormat(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        if let newdate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            return  dateFormatter.string(from: newdate)
        }else {
            return ""
        }
    }
    
}





extension VendorTimeOffViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apiVendorTimeOffResponseModel?.vendorTimeOffs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vendorTimeOffTV.dequeueReusableCell(withIdentifier: "VendorTimeOffDetailsCellL", for: indexPath) as! VendorTimeOffDetailsCellL
        let cellData = self.apiVendorTimeOffResponseModel?.vendorTimeOffs?[indexPath.row]
        cell.companyLbl.text = cellData?.companyName ?? ""
        cell.venodrNamelbl.text = cellData?.vendorName ?? ""
        cell.eventNameLbl.text = cellData?.eventName ?? ""
        let fromTime = self.convertDateAndTimeFormat(cellData?.fromDateTime ?? "")
        let toTime = self.convertDateAndTimeFormat(cellData?.toDateTime ?? "")
        let updateTime = self.convertDateAndTimeFormat(cellData?.updateDate ?? "")
        
        print("FROM TIME IS \(fromTime) tO time iss \(toTime) and update time is \(updateTime)")
        cell.fromDateLbl.text = fromTime
        cell.toDateLbl.text = toTime
        cell.lastUpdatedLbl.text = updateTime
        return cell
    }
}


class VendorTimeOffDetailsCellL:UITableViewCell{
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var lastUpdatedLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var venodrNamelbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    
}
