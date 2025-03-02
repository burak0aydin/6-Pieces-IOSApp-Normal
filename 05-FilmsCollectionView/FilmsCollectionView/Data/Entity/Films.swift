//
//  Films.swift
//  FilmsCollectionView
//
//  Created by Burak Aydın on 19.09.2023.
//

import Foundation

class Films {
    var id : Int?
    var name : String?
    var image : String?
    var price : Int?
    
    init() {
        
    }
    
    init(id: Int, name: String, image: String, price: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
    }
}
