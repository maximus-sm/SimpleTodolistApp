//
//  RootTableViewDelegate.swift
//  MaFa
//
//  Created by Sundet Mukhtar on 24.07.2024.
//

import Foundation
import UIKit
import RealmSwift

class RootTableViewDelegate:UIViewController{
    
    
    var cellHeight = 0.0;
    var tasks:Results<Task>?;
    var expandedIndexSet:IndexSet = IndexSet();
    var minHeightConstraintForExpandingCell:NSLayoutConstraint?;
    let borderColors = K.Task.importanceBorderColor
    var childTableView:UITableView?
    let dateFormmater = DateFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormmater.dateFormat = "MM-dd HH:mm"
        UISearchBar.appearance().placeholder = "Search in title or in description"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    func setTableView(_ tableView:UITableView){
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 150;
        cellHeight = tableView.frame.height/7;
        tableView.delegate = self;
        tableView.dataSource = self;
        self.childTableView = tableView;
    }
    
    
    func readTasks() -> Bool{
        preconditionFailure("This method must be overridden")
    }
    
    func querryTasks(with predicate:NSPredicate) -> Bool{
        do{
            let realm = try Realm();
            if let filetredTasks = tasks?.filter(predicate){
                tasks = filetredTasks;
                childTableView?.reloadData()
                return true;
            }
        }catch{
            print("Error querrying tasks with given predicate \(predicate.predicateFormat) \(error.localizedDescription)")
        }
        return false
    }
    
    
}


extension RootTableViewDelegate:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasks = tasks{
            return tasks.count;
        }else {
            return 0;
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)  as! TableViewCell;
        
        let task = tasks![indexPath.row]
        let imprtncVal = task.importance
        let borderColor = UIColor.init(hexString: borderColors[imprtncVal]) ?? .white;
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.descrip
        cell.parentView.layer.borderColor = borderColor.cgColor
        cell.timeLabel.text = dateFormmater.string(from: Date(timeIntervalSince1970: task.endTime));
        
        cell.parentViewMinHeight.constant = cellHeight;
        cell.parentViewMinHeight.isActive = true;
        
        //WHY - ???
//        print(cell.topView.bounds.height)
//        print((cellHeight - 10)/2 )
                
        cell.topViewMinHeight.constant = (cellHeight - 10)/2 ;
        if(expandedIndexSet.contains(indexPath.row)){
            cell.topViewMinHeight.isActive = true;
            cell.topViewHeightConstriant.isActive = false;
            cell.descriptionLabel.numberOfLines = 0;
        }else{
            cell.topViewMinHeight.isActive = false
            cell.topViewHeightConstriant.isActive = true;
            cell.descriptionLabel.numberOfLines = 1;
        }
        return cell
    }
}


extension RootTableViewDelegate:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell;
        if (countLabelLines(label: cell.descriptionLabel) <= 1){
            return;
        }
        
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        }else{
            expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func countLabelLines(label: UILabel) -> Int {
//         Call self.layoutIfNeeded() if your view uses auto layout
//        "In order to work you must call it after func viewDidLayoutSubviews() was called.
//        It uses the label frame. In viewDidLoad this value is still not correct which leads to you getting incorrect values."
        let myText = label.text! as NSString

        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
}


// MARK: - UISearchBar methods implementation
extension RootTableViewDelegate:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            let predicate = NSPredicate(format:"title CONTAINS[cd] %@ || descrip CONTAINS[cd] %@" , text,text)
            querryTasks(with: predicate)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = "";
//        if let mVC = self as? MainViewController{
//            mVC.readTasks()
//        }
        readTasks();
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            //        if let mVC = self as? MainViewController{
            //            mVC.readTasks()
            //        }
            readTasks();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
