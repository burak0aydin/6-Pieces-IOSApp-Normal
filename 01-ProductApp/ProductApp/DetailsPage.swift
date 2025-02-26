//
//  DetailsPage.swift
//  ProductApp
//
//  Created by Burak Aydın on 18.09.2023.
//

import UIKit

class DetailsPage: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceTextLabel: UILabel!
    
    var products : Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = products {
            self.navigationItem.title = product.name
            priceTextLabel.text =  "\(product.price!) ₺"
            productImageView.image = UIImage(named: product.image!)
        }
    }
    
    @IBAction func addToListButton(_ sender: Any) {
        if let product = products {
            print("\(product.name!) added to list ")
        }
    }
    
    

}
