//
//  DetailsPage.swift
//  FilmsCollectionView
//
//  Created by Burak Aydın on 19.09.2023.
//

import UIKit

class DetailsPage: UIViewController {
    @IBOutlet weak var filmNameTextLabel: UILabel!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmPriceTextLabel: UILabel!
    
    var film : Films?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let f = film {
            filmNameTextLabel.text = f.name
            filmImageView.image = UIImage(named: f.image!)
            filmPriceTextLabel.text = "\(f.price!) ₺"
            
        }

    }


}
