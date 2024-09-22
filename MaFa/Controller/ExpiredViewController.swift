//
//  ExpiredViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 25.07.2024.
//

import UIKit
import RealmSwift
class ExpiredViewController: RootTableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView(tableView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTasks();
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCell;
        cell.doneButton.setImage(cell.expiredImage, for: .disabled);
        cell.doneButton.isEnabled = false;
        return cell;

    }
    
    
    override func readTasks() -> Bool{
        let predicate = NSPredicate(format: "isDone == false AND endTime <= %@", NSNumber(floatLiteral: Date().timeIntervalSince1970))
        do{
            let realm = try Realm()
            tasks = realm.objects(Task.self);
            if let tasks = tasks{
                super.tasks = tasks.filter(predicate);
            }else{
                return false
            }
            
        }catch{
            print("Error while reading expired Tasks \(error.localizedDescription)");
            return false;
        }
        tableView.reloadData();
        return true;
    }
    
}
