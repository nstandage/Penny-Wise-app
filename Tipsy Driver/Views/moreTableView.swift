//
//  moreTableView.swift
//  Tipsy Driver
//
//  Created by Nathan Standage on 11/29/17.
//  Copyright © 2017 Nathan Standage. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class moreTableViewController: UITableViewController {

    var entries: [Entry]! = nil
    var dataSource: DataSource! = nil
    var managedObjectContext: NSManagedObjectContext! = nil
    var entrySelected: Entry?
    var cellState: CellState!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateEntries()
        navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("customCell", owner: self, options: nil)?.first as! customCell
        let currentEntry = entries[indexPath.row]
        
        cell.hourlyLabel.text = Calculate.hourly(entries: [currentEntry])
        cell.hoursLabel.text = String(Calculate.hours(entries: [currentEntry]))
        cell.tipsLabel.text = String(Calculate.tips(entries: [currentEntry]))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entries[indexPath.row]
            entries.remove(at: indexPath.row)
            managedObjectContext.delete(entry)
            managedObjectContext.saveChanges()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        entrySelected = entries[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.addItem.rawValue, sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.addItem.rawValue {

            guard let newView = segue.destination as? detailViewController else {
                CalendarError.presentErrorWith(title: .segueError, message: .segue, view: self)
                return
            }
            newView.managedObjectContext = self.managedObjectContext
            newView.cellState = self.cellState
            newView.entryBeingEdited = entrySelected
            entrySelected = nil
        }
    }
    
    //MARK: - Helper Methods
    func populateEntries() {
        entries = dataSource.entriesWith(date: cellState.date)
    }
}






























