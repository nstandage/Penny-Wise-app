//
//  detailViewController.swift
//  Tipsy Driver
//
//  Created by Nathan Standage on 11/22/17.
//  Copyright © 2017 Nathan Standage. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class detailViewController: UIViewController {

    @IBOutlet weak var tipsTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    var managedObjectContext = CoreDataStack().managedObjectContext
    var calendarView: JTAppleCalendarView!
    var cellState: CellState!
    var dateString: String!
    var viewController: ViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = dateString
        tipsTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancel(_ sender: Any) {
        viewController.resetCalendar()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let hourly = hoursTextField.text, let tips = tipsTextField.text else {
            //#ERROR
            return
        }
        
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as? Entry else {
            //#ERROR
            return
        }

        entry.date = cellState.date
        entry.hours = Double(hourly)!
        entry.tips = Double(tips)!
        
        managedObjectContext.saveChanges()
        viewController.resetCalendar()
        dismiss(animated: true, completion: nil)
    }
}





































