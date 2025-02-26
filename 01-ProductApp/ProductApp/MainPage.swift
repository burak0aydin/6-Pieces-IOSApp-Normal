//
//  ViewController.swift
//  ProductApp
//
//  Created by Burak Aydın on 18.09.2023.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    
    var productsList = [Products] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.delegate = self
        productTableView.dataSource = self
        
        let p1 = Products(id: 1, name: "Macbook Pro 14", image: "computer", price: 43000)
        let p2 = Products(id: 2, name: "Rayban Club Master", image: "glasses", price: 2500)
        let p3 = Products(id: 3, name: "Sony ZX Series", image: "headphone", price: 40000)
        let p4 = Products(id: 4, name: "Gio Armani", image: "perfume", price: 2000)
        let p5 = Products(id: 5, name: "Casio X Series", image: "watch", price: 8000)
        let p6 = Products(id: 6, name: "Dyson V8", image: "vacuumCleaner", price: 18000)
        let p7 = Products(id: 7, name: "IPhone 13", image: "phone", price: 32000)

        productsList.append(p1)
        productsList.append(p2)
        productsList.append(p3)
        productsList.append(p4)
        productsList.append(p5)
        productsList.append(p6)
        productsList.append(p7)
    
        productTableView.separatorColor = UIColor(white: 0.95, alpha: 1)

    }

}

extension MainPage : UITableViewDelegate, UITableViewDataSource, cellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = productsList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell") as! ProductsCell
        
        cell.productsİmageView.image = UIImage(named: product.image!)
        cell.productNameTextLabel.text = product.name!
        cell.productPriceTextLabel.text = "\(product.price!) ₺"
        
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.layer.cornerRadius = 15
        cell.viewCell.layer.cornerRadius = 15
        
        cell.cellProtocol = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = productsList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualaction, view, bool in
            print("\(product.name!) deleted")
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = productsList[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualaction, view, bool in
            print("\(product.name!) edited")
        }
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = productsList[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: product)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            if let product = sender as? Products {
                let toVC = segue.destination as! DetailsPage
                toVC.products = product
            }
        }
    }
    
    func addedToList(indexPath: IndexPath) {
        let product = productsList[indexPath.row]
        print("\(product.name!) added to list")

    }
    
}

