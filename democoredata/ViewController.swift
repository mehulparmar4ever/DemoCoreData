//
//  ViewController.swift
//  democoredata
//
//  Created by Sooryen on 1/29/18.
//

import UIKit
import CoreData
import SugarRecord

class ViewController: UIViewController {
    
    @IBOutlet weak var tblList: UITableView!
    var arrList = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get all objects using fetch query
    func getFreshData() {
        arrList = try! db.fetch(FetchRequest<Event>())
        self.tblList.reloadData()
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let eventObj = self.arrList[indexPath.row] as Event
        if eventObj.eventTitle != nil {
            cell.textLabel?.text = "Name : \(eventObj.eventTitle!)"
        }
        
        if eventObj.eventDescription != nil {
            cell.detailTextLabel?.text = "event Description : \(eventObj.eventDescription!)"
        }
        
        return cell
    }
    
    // View object
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let objSubjectListVC = mainStoryboard.instantiateViewController(withIdentifier: "AddVC") as? AddVC
//        objSubjectListVC!.selectedStudent = self.arrStudentList[indexPath.row]
//        self.navigationController?.pushViewController(objSubjectListVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            //Delete object
            let objEventTemp = self.arrList[indexPath.row] as Event
            try! db.operation { (context, save) -> Void in
                if let item = try! context.request(Event.self)
                    .filtered(with: "eventuid", equalTo: objEventTemp.eventuid ?? "").fetch()
                    .first {
                    try! context.remove(item)
                    save()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }

            tableView.beginUpdates()
            self.arrList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        //Edit object
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in//
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let objAddSubjectVC = mainStoryboard.instantiateViewController(withIdentifier: "AddVC") as? AddVC
            objAddSubjectVC!.selectedEvent = self.arrList[indexPath.row]
            self.navigationController?.pushViewController(objAddSubjectVC!, animated: true)
        }
        
        edit.backgroundColor = UIColor.black
        return [delete,edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
}


