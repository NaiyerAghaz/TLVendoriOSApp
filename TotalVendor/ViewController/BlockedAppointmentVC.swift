//
//  BookedAppointmentVC.swift
//  TotalVendor
//
//  Created by Shivansh SMIT on 27/01/22.
//

import UIKit

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

    @IBOutlet weak var appointmentListTV: UITableView!
 
    var collapseStatus = [false,false,false,false,false,false,false,false,false,false]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        appointmentListTV.delegate=self
        appointmentListTV.dataSource=self
        
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
