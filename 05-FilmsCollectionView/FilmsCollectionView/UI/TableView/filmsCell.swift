//
//  filmsCell.swift
//  FilmsCollectionView
//
//  Created by Burak Aydın on 19.09.2023.
//

import UIKit

protocol cellProtocol {
    func addToList (indexPath : IndexPath)
}

class filmsCell: UICollectionViewCell {
    
    @IBOutlet weak var filmsImageView: UIImageView!
    @IBOutlet weak var filmsPriceTextLabe: UILabel!
    
    var cellProtocol : cellProtocol?
    var indexPath : IndexPath?
    
    @IBAction func addToListButton(_ sender: Any) {
        cellProtocol?.addToList(indexPath: indexPath!)
    }
}
