//
//  TableViewController.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 21.05.2024.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var constraint:NSLayoutConstraint?;
    var expandedIndexSet:IndexSet = IndexSet();
    var cellHeight = 0.0;
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func setButtonMenu() {
        
        let actionClosure = { (action: UIAction) in
            print(action.title)
            switch action.title {
            case "time":
                //self.sortButton.titleLabel?.text = "Sorted by: Time"
                //action.title = "Sort by:Time"
                print("action");
            default:
                print("default")
            }
            
        }
        
        
        
    
        var menuElements:[UIMenuElement] = []
        menuElements.append(UIAction(title: "by time", handler: actionClosure));
        menuElements.append(UIAction(title:"by importance",handler: actionClosure));
        menuElements.append(UIAction(title:"by name",handler: actionClosure));
        sortButton.menu = UIMenu(title: "Sort:",options: .singleSelection,children: menuElements);
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
        
//        let action1 = UIAction();
//        let action2 = UIAction();
       
        
        
    }
    
    
    // MARK: Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        }else{
            expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}


// MARK: - Table view data source
extension MainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)  as! TableViewCell;
        cell.parentViewMinHeight.constant = cellHeight;
        cell.parentViewMinHeight.isActive = true;
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



