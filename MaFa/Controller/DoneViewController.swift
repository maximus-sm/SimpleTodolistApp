//
//  DoneViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 25.07.2024.
//

import UIKit
import RealmSwift


class DoneViewController: RootTableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView(tableView)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        readTasks()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCell;
        //cell.doneButton.isSelected = true;
        cell.setSelected(true, animated: true)
        cell.isSelected = true;
        cell.doneButton.isEnabled = false;
        cell.doneButton.setImage(cell.doneImage, for: .disabled);
        return cell;

    }
    
    
    func readTasks() {
        let predicate = NSPredicate(format: "isDone == true");
        do{
            let realm = try Realm();
            tasks = realm.objects(Task.self)
            if let tasks = tasks{
                self.tasks = tasks.filter(predicate);
            }
        }catch{
            print("Error reading tasks in DoneVC \(error.localizedDescription)")
        }
        tableView.reloadData();
    }
}
