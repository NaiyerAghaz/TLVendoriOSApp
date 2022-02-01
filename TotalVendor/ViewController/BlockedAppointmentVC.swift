//
//  BookedAppointmentVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/01/22.
//

import UIKit
import Alamofire

class BlockedAppointmentTVC:UITableViewCell{
    
    @IBOutlet weak var collapseBtnOutlet: UIButton!
    @IBOutlet weak var appointmentDetailsUIView: UIView!
    @IBOutlet weak var appointmentNumberView: UIView!
    @IBOutlet weak var appointmentLbl: UILabel!
    @IBOutlet weak var arrowOutlet: UIImageView!
    
    override  func awakeFromNib() {
         self.appointmentDetailsUIView.visibility = .gone
     }
}


class BlockedAppointmentVC: UIViewController {
    var apiGetCustomerDetailResponseModel : [ApiGetCustomerDetailResponseModel]?
    @IBOutlet weak var appointmentListTV: UITableView!
 var appointmentID = 0
    var collapseStatus = [false,false,false,false,false,false,false,false,false,false]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAppointmentDetailsApi()
        appointmentListTV.delegate=self
        appointmentListTV.dataSource=self
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension BlockedAppointmentVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTV.dequeueReusableCell(withIdentifier: "BlockedAppointmentTVC", for: indexPath) as! BlockedAppointmentTVC
//            cell.appointmentDetailsUIView.visibility = .gone
        cell.collapseBtnOutlet.tag = indexPath.row
        cell.collapseBtnOutlet.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
        return cell
    }
    
   @objc func btnAction(_ sender: UIButton)
    {

           let cell = appointmentListTV.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! BlockedAppointmentTVC
           self.collapseStatus[sender.tag] = !self.collapseStatus[sender.tag]
        
           if self.collapseStatus[sender.tag] {
               cell.appointmentDetailsUIView.visibility = .visible
               cell.arrowOutlet.image = UIImage(systemName: "chevron.up")
           }else {
               cell.appointmentDetailsUIView.visibility = .gone
               cell.arrowOutlet.image = UIImage(systemName: "chevron.down")
           }
           DispatchQueue.main.asyncAfter(deadline: .now()) {
               self.appointmentListTV.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
           }
        }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension BlockedAppointmentVC{
    func getAppointmentDetailsApi(){
            SwiftLoader.show(animated: true)
            let urlString = APIs.GetBlockedAppointmentDetails
            let companyID = userDefaults.value(forKey: UserDeafultsString.instance.CompanyID) ?? 0
  
            let userID = userDefaults.value(forKey: UserDeafultsString.instance.UserID) ?? 0
            let userTypeId = userDefaults.value(forKey: UserDeafultsString.instance.UserTypeID) ?? 0//GetPublicData.sharedInstance.userTypeID
            let searchString = "<INFO><UserID>\(userID)</UserID><AppointmentID>\(appointmentID)</AppointmentID><Companyid>\(companyID)</Companyid><USERTYPEID>\(userTypeId)</USERTYPEID></INFO>"
            let parameter = [
                "strSearchString" : searchString
            ] as [String : String]
            print("url and parameter for customer Detail are ", urlString, parameter)
            AF.request(urlString, method: .post , parameters: parameter, encoding: JSONEncoding.default, headers: nil)
                .validate()
                .responseData(completionHandler: { [self] (response) in
                    SwiftLoader.hide()
                    switch(response.result){
                        
                    case .success(_):
                        print("Respose Success getCustomerDetail ")
                        guard let daata = response.data else { return }
                        do {
                            let jsonDecoder = JSONDecoder()
                            self.apiGetCustomerDetailResponseModel = try jsonDecoder.decode([ApiGetCustomerDetailResponseModel].self, from: daata)
                            print("Success getCustomerDetail Model ",self.apiGetCustomerDetailResponseModel?.first?.result ?? "")
                            let str = self.apiGetCustomerDetailResponseModel?.first?.result ?? ""
                            let data = str.data(using: .utf8)!
                            do {
    //
                                print("DATAAA ISSS \(data)")
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                                {

                                    let newjson = jsonArray.first
                                    let userInfo = newjson?["BlockedAppList"] as? [[String:Any]]
                                    //let statusInfo = newjson?["StatusInfo"] as? [[String:Any]] // use the json here
                                    let userIfo = userInfo?.first
                                    print("USER INFO NEW DATA IS \(userIfo)")
                                    let customerUserName = userIfo?["CustomerUserName"] as? String
                                    let customerEmail = userIfo?["Email"] as? String
                                    let customerFullName = userIfo?["CustomerFullName"] as? String
                                    let customerID = userIfo?["CustomerID"] as? Int
                                   
                                    
                                    
                                    //    updateUI(customerName: customerFullName ?? "", subcustomerName: "Select Subcustomer Name")
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        } catch{
                            
                            print("error block getCustomerDetail " ,error)
                        }
                    case .failure(_):
                        print("Respose getCustomerDetail ")
                        
                    }
                })
        }
}




struct ApiGetCustomerDetailResponseModel : Codable {
    let result : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(String.self, forKey: .result)
    }

}
