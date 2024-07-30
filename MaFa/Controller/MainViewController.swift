//
//  TableViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 21.05.2024.
//

import UIKit
import RealmSwift

class MainViewController: RootTableViewDelegate,TableViewCellDelegate {
    
    

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var timerSet = IndexSet();
    var timer:Timer?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setTableView(tableView)
        setButtonMenu();
        

        
        //deleteAll()
        
        //readAllTasks();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTasks()
        //deleteAll()
        setTimer();
        //print(tasks?.count)
    }
    
    
    func setButtonMenu() {
        let titleForTimeBt = "by time";
        let titleForImportanceBt = "by importance"
        let titleForNameBt = "by name"
        
        let actionClosure = { (action: UIAction) in
            switch action.title {
            case titleForNameBt:
                self.sortTasksBy("title")
            case titleForTimeBt:
                self.sortTasksBy("endTime")
            case titleForImportanceBt:
                self.sortTasksBy("importance")
            default:
                self.readTasks()
            }
            self.setTimer();
        }
    
        var menuElements:[UIMenuElement] = []
        menuElements.append(UIAction(title: titleForTimeBt, handler: actionClosure));
        menuElements.append(UIAction(title:titleForImportanceBt,handler: actionClosure));
        menuElements.append(UIAction(title:titleForNameBt,handler: actionClosure));
        sortButton.menu = UIMenu(title: "Sort:",options: .singleSelection,children: menuElements);
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
    
        
    }
    
    
    func readTasks() -> Bool{
        let predicate = NSPredicate(format: "isDone == false AND endTime >%@", NSNumber(floatLiteral: Date().timeIntervalSince1970))
        do{
            let realm = try Realm();
            tasks =  realm.objects(Task.self);
            if let tasks = tasks{
                self.tasks = tasks.filter(predicate);
            }
        }catch{
            print("Error reading Task objects")
            return false;
        }
        tableView.reloadData();
        return true;
    }
    
    
    func deleteAll(){
        
        do{
//            let realm = try Realm();
//            try realm.write {
//                realm.deleteAll()
//
//            }
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: configuration)
        }catch{
            print("Error while deletaing the realm file \(error.localizedDescription) ")
        }
    }
    
    
    func sortTasksBy(_ parameter:String) {

        do{
            if let tasks = tasks {
                self.tasks = tasks.sorted(byKeyPath: parameter, ascending: true)
            }
            tableView.reloadData()
        }
        catch{
            print("Error while sorting the realm file \(error.localizedDescription) ")
        }
    }
    
    
    func setTimer(){
        if(timer != nil) { timer!.invalidate() }
        
        timer = Timer(fire: .now, interval: 60, repeats: true) { timer in
            
            let indexPaths = self.tableView.indexPathsForVisibleRows;
            if let iPs = indexPaths{
                for iP in iPs {
                    let cell = self.tableView.cellForRow(at: iP) as! TableViewCell;
                    let task = self.tasks![iP.row]
                    var time =  task.endTime - Date.now.timeIntervalSince1970;
                    var hours = 0;
                    var minutes = 0;
                    if(time > 0){
                        hours = Int(time / 60 / 60)
                        minutes = Int((time/60).truncatingRemainder(dividingBy: 60))
                    }
                    cell.timeLabel.text = "\(hours):\(minutes)"
                }
            }else{
                timer.invalidate();
            }
        }
        
        RunLoop.main.add(timer!, forMode: .common);
        
    }
    
    
}


extension MainViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCell
        cell.delegate = self;
        return cell;
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextAction = UIContextualAction(style: .destructive, title:"delete") { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        }
        
        let swipe = UISwipeActionsConfiguration.init(actions: [contextAction])

        
        return swipe;
    }
    
    
    func doneButtonPressed(in cell: TableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!;
        do{
            let realm = try Realm();
            try realm.write{
                tasks![indexPath.row].isDone = true;
        }}catch{
            print("Error updating task object \(error.localizedDescription)")
        }
        //readTasks();
        cell.doneButton.isEnabled = false;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(3), execute: { () -> Void in
            self.tableView.deleteRows(at: [indexPath], with: .right)
        })
    }
    
}


protocol TableViewCellDelegate:AnyObject {
    func doneButtonPressed(in cell: TableViewCell)
    
}
