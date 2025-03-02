//
//  ListViewController.swift
//  mapApp
//
//  Created by Burak Aydın on 4.09.2023.
//

import UIKit
import CoreData // verileri çekmek için importladık

//tableview için UITableViewDelegate, UITableViewDataSource classlarını ekledik
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String] ()
    var idArray = [UUID] ()
    var selectedLocationName = ""
    var selectedLocationId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate ve datasource kısmını ListViewControllera eşitledik
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    // konumları kaydettikden sonra anlık tableviewda gözükmesi için yaptığımız 2. son işlem 
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("createdTheNewLocation"), object: nil)
    }
    
    // core data dan veri çekme
    @objc func getData () {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                nameArray.removeAll(keepingCapacity: false)
                idArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "name") as? String {
                        nameArray.append(name)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                }
                tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    // table viewda kaç sıra olacak
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    // table viewda her sıra içinde ne yazacak
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    // haritalar sayfasına gönderir bizi
    @IBAction func addBarButton(_ sender: Any) {
        selectedLocationName = ""
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    // Table viewda herhangi bir rowa tıklanınca bu class içindeki atma işlemlerini yapar ve hedef yeri belirler
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocationName = nameArray[indexPath.row]
        selectedLocationId = idArray[indexPath.row]
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    // Table viewda tıklandıktan sonra diğer clasdaki,sayfadaki değerlere bu clalassdan atama yapar
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "toMapsVC" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.selectedName = selectedLocationName
            destinationVC.selectedId = selectedLocationId
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
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
