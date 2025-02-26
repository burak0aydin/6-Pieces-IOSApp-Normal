//
//  ViewController.swift
//  Save Picture And Detail
//
//  Created by Burak Aydın on 20.08.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String] ()
    var idArray = [UUID] ()
    var selectedProductName = ""
    var selectedProductUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add button in topBar
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    //bir veri kaydettimmi bunu anlık göstermesine yarıyor
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
    }
    
    // ekleme butonuna tıklanınca verileri girmemiz için boş sayfaya gönderme işlemi
    @objc func addButtonClicked () {
        selectedProductName = ""
        performSegue(withIdentifier: "toDetaisVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray [indexPath.row]
        return cell
    }
    
    // kaydettiğimiz verileri core datadan çekme ve coredatadan array  içine atama işlemi
    @objc func fetchData () {
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let data = try context.fetch(fetchRequest)
            if data.count > 0 {
                for aData in data as! [NSManagedObject] {
                    if let name = aData.value(forKey: "name") as? String {
                        nameArray.append(name)
                    }
                    
                    if let id = aData.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    
                }
                tableView.reloadData()
            }
            
        } catch {
            print("Error occurred while capturing data")
        }
        
    }
    
    // ürün verileri verileri sayfada göstermek içi atama işlemi
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetaisVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedName = selectedProductName
            destinationVC.selectedUUID = selectedProductUUID
        }
    }
    
    // verileri arraydan çekme
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProductName = nameArray[indexPath.row]
        selectedProductUUID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetaisVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
            let uuidString = idArray[indexPath.row].uuidString
            //coredatadan çekeceğim şeyleri filtreler "id = %@"
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let data = try context.fetch(fetchRequest)
                if data.count > 0 {
                    for aData in data as! [NSManagedObject] {
                        
                        if let id = aData.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(aData)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    
                                }
                                break
                            }
                        }
                    }
                }

            } catch {
                print("Error occurred while capturing data")
            }
        }
        
    }
    
}
