//
//  ProductCell.swift
//  ProductApp
//
//  Created by Burak Aydın on 18.09.2023.
//

import UIKit

protocol cellProtocol {
    func addedToList (indexPath : IndexPath)
}

class ProductsCell: UITableViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var productsİmageView: UIImageView!
    @IBOutlet weak var productNameTextLabel: UILabel!
    @IBOutlet weak var productPriceTextLabel: UILabel!
    
    var cellProtocol : cellProtocol?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func addToListButton(_ sender: Any) {
        cellProtocol?.addedToList(indexPath: indexPath!)
    }

}
