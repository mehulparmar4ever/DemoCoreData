//
//  AddVC.swift
//  democoredata
//
//  Created by Sooryen on 1/29/18.
//

import UIKit
import SugarRecord
import DatePickerDialog

class AddVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtVenue: UITextField!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var btnSelectSave: UIButton!
    
    var selectedDate = Date()
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //if you have already data then fill it.
        if selectedEvent != nil {
            self.btnSelectSave.setTitle("Update", for: .normal)
            self.txtName.text = selectedEvent?.eventTitle
            self.txtDesc.text = selectedEvent?.eventDescription
            self.txtVenue.text = selectedEvent?.eventVenue
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.btnSelectDate.setTitle(formatter.string(from: selectedEvent!.eventDateTime! as Date), for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Button events
    @IBAction func btnSelectDateClicked(_ sender: UIButton) {
        print("btnSelectDateClicked")
        DatePickerDialog().show("Please select date..", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.selectedDate = dt
                self.btnSelectDate.setTitle(formatter.string(from: dt), for: .normal)
            }
        }
    }

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        print("btnSelectDateClicked")

        //Check validation
        if isValidate() {
            
            //Update object
            if selectedEvent != nil {
                try! db.operation { (context, save) -> Void in
                    
                    if let item = try! context.request(Event.self)
                        .filtered(with: "eventuid", equalTo: self.selectedEvent!.eventuid ?? "").fetch()
                        .first {
                        item.eventTitle = self.txtName.text!
                        item.eventDescription = self.txtDesc.text!
                        item.eventVenue = self.txtVenue.text!
                        item.eventDateTime = self.selectedDate as NSDate
                        item.eventuid = self.Timestamp
                        save()
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                //Add new object
                try! db.operation { (context, save) -> Void in
                    let event: Event = try context.new()
                    event.eventTitle = self.txtName.text!
                    event.eventDescription = self.txtDesc.text!
                    event.eventVenue = self.txtVenue.text!
                    event.eventDateTime = self.selectedDate as NSDate
                    event.eventuid = self.Timestamp
                    try! context.insert(event)
                    save()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            print("Please enter proper details")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    //Check validation of textfield to prevent empty entries..
    func isValidate() -> Bool {
        if txtName.text!.isEmpty {
            return false
        }
        else if txtDesc.text!.isEmpty {
            return false
        }
        else if txtVenue.text!.isEmpty {
            return false
        }
        else if (btnSelectDate.title(for: .normal) == "Select date") {
            return false
        }
        else {
            return true
        }
    }

}
