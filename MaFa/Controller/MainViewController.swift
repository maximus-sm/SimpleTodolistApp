//
//  TableViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 21.05.2024.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var constraint:NSLayoutConstraint?;
    var expandedIndexSet:IndexSet = IndexSet();
    var timerSet = IndexSet();
    var cellHeight = 0.0;
    let borderColor = K.Task.importanceBorderColor;
    var tasks:Results<Task>?;
    var timer:Timer?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 150;
        cellHeight = self.tableView.frame.height/7;
        //self.tableView.rowHeight = 300;
        tableView.delegate = self;
        tableView.dataSource = self;
        setButtonMenu();
        
        
        
        //deleteAll()
        
        //readAllTasks();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        readAllTasks()
        setTimer();
        //print(tasks?.count)
    }
    

    func setButtonMenu() {
        let titleForTimeBt = "by time";
        let titleForImportanceBt = "by importance"
        let titleForNameBt = "by name"
        
        let actionClosure = { (action: UIAction) in
            print(action.title)
            switch action.title {
            case titleForNameBt:
                self.sortTasksBy("title")
            case titleForTimeBt:
                self.sortTasksBy("endTime")
            case titleForImportanceBt:
                self.sortTasksBy("importance")
            default:
                print("default")
            }
            
        }
    
        var menuElements:[UIMenuElement] = []
        menuElements.append(UIAction(title: titleForTimeBt, handler: actionClosure));
        menuElements.append(UIAction(title:titleForImportanceBt,handler: actionClosure));
        menuElements.append(UIAction(title:titleForNameBt,handler: actionClosure));
        sortButton.menu = UIMenu(title: "Sort:",options: .singleSelection,children: menuElements);
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        
//        let action1 = UIAction();
//        let action2 = UIAction();
       
        
        
    }
    
    
    func readAllTasks() -> Bool{
        
        do{
            let realm = try Realm();
            tasks =  realm.objects(Task.self);
        }catch{
            print("Error reading Task objects")
            return false;
        }
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
            let realm = try Realm();
            tasks = realm.objects(Task.self).sorted(byKeyPath: parameter, ascending: true)
            //tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade);
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


// MARK: - Table view data source
extension MainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasks = tasks{
            return tasks.count;
        }else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)  as! TableViewCell;
        cell.parentViewMinHeight.constant = cellHeight;
        cell.parentViewMinHeight.isActive = true;
        
        let row = indexPath.row
        let imprtncVal = tasks![row].importance
        let borderColor = UIColor.init(hexString: borderColor[imprtncVal]) ?? .white;
        cell.titleLabel.text = tasks![row].title
        cell.descriptionLabel.text = tasks![row].descrip
        cell.layer.borderColor = borderColor.cgColor
        cell.timeLabel.text = String(tasks![row].time);
        
        if(constraint == nil){
            constraint =  NSLayoutConstraint(item: cell.topView!, attribute:  NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1,  constant: cell.topView.bounds.height);
            constraint!.priority = UILayoutPriority(999);
        }
        
        if(expandedIndexSet.contains(indexPath.row)){
            
            cell.descriptionLabel.numberOfLines = 0;
            constraint!.isActive = true;
            cell.topViewHeightConstriant.isActive = false;
        }else{
            
            cell.descriptionLabel.numberOfLines = 1;
            constraint!.isActive = false;
            cell.topViewHeightConstriant.isActive = true;
        }
        
        
        return cell
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
}


extension MainViewController{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextAction = UIContextualAction(style: .destructive, title:"delete") { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        }
        
        let swipe = UISwipeActionsConfiguration.init(actions: [contextAction])

        
        return swipe;
    }
    
}


// MARK: - TablewView delegate methods
extension MainViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        }else{
            expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



