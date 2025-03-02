//
//  ViewController.swift
//  ListApp
//
//  Created by Burak Aydın on 15.08.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertController = UIAlertController()
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetch()
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: Any) {
        presentAddAlert()
    }
    
    @IBAction func didRemoveBarButtonItemTapped(_ sender: Any) {
        presentAlert(
            title: "Warning!",
            message: "Are you sure you want to delete all the elements in the list ?",
            preferredStyle: .alert,
            cancelButtonTitle: "No",
            cancelButtonStyle: .destructive,
            defaultButtonTittle: "Yes",
            defaultButtonStyle: .default)
        { _ in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            for item in self.data {
                managedObjectContext?.delete(item)
            }
            
            try? managedObjectContext?.save()
            
            self.fetch()
        }
    }
    
    
    func presentAlert (
        title : String?,
        message : String?,
        preferredStyle:UIAlertController.Style,
        cancelButtonTitle : String?,
        cancelButtonStyle : UIAlertAction.Style,
        isTextFieldAvailable : Bool = false,
        defaultButtonTittle : String? = nil,
        defaultButtonStyle : UIAlertAction.Style? = nil,
        defaultButtonHandler : ((UIAlertAction)  -> Void)? = nil) {
            
            alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle)
            
            let cancelButton = UIAlertAction(
                title: cancelButtonTitle,
                style: cancelButtonStyle)
            
            if defaultButtonTittle != nil {
                let defaultButton = UIAlertAction(
                    title: defaultButtonTittle,
                    style: defaultButtonStyle ?? .default,
                    handler: defaultButtonHandler)
                alertController.addAction(defaultButton)
            }
            
            if isTextFieldAvailable {
                alertController.addTextField ()
            }
            alertController.addAction(cancelButton)
            present(alertController,animated: true)
        }
    
    
    func presentAddAlert () {
        presentAlert(
            title: "Add new task",
            message: nil,
            preferredStyle: .alert,
            cancelButtonTitle: "Cancel",
            cancelButtonStyle: .destructive,
            isTextFieldAvailable: true, defaultButtonTittle: "Add",
            defaultButtonStyle: .default,
            defaultButtonHandler: {  _ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                    
                    let listItem = NSManagedObject(entity: entity! , insertInto: managedObjectContext)
                    
                    listItem.setValue(text, forKey: "title")
                    
                    try? managedObjectContext?.save()
                    
                    self.fetch()
                    
                }
                else {
                    self.presentWarningAlert ()
                }
            }
        )
    }
    
    
    func presentWarningAlert () {
        presentAlert(
            title: "Warning!",
            message: "List element cannot be empty",
            preferredStyle: .alert,
            cancelButtonTitle: "Cancel",
            cancelButtonStyle: .destructive)
    }
    
    func fetch(){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "ListItem")
        
        data = try! managedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
        
    }
}


extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",
                                                     for: indexPath)
            
            let listItem =  data[indexPath.row]
            cell.textLabel?.text = listItem.value(forKey: "title") as? String
            return cell
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete") { _, _, _ in
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                managedObjectContext?.delete(self.data[indexPath.row])
                
                try? managedObjectContext?.save()
                
                self.fetch()
                
            }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(
            style: .normal,
            title: "Edit") { _, _, _ in
                self.presentAlert(
                    title: "Edit post",
                    message: nil,
                    preferredStyle: .alert,
                    cancelButtonTitle: "Cancel",
                    cancelButtonStyle: .destructive,
                    isTextFieldAvailable: true, defaultButtonTittle: "Add",
                    defaultButtonStyle: .default,
                    defaultButtonHandler: {  _ in
                        let text = self.alertController.textFields?.first?.text
                        if text != "" {

                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            
                            let managedObjectContext = appDelegate?.persistentContainer.viewContext
                            
                            self.data[indexPath.row].setValue(text, forKey: "title")
                            
                            if managedObjectContext!.hasChanges {
                                try? managedObjectContext?.save()
                            }
                            
                            self.tableView.reloadData()
                            
                        }
                        else {
                            self.presentWarningAlert ()
                        }
                    }
                )
            }
        
        editAction.backgroundColor = .systemBlue
        let config = UISwipeActionsConfiguration(actions: [editAction])
        
        return config
        
    }
    
}
