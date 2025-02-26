//
//  Product.swift
//  ProductApp
//
//  Created by Burak Aydın on 18.09.2023.
//

import Foundation

class Products {
    var id : Int?
    var name : String?
    var image : String?
    var price : Int?
    
    init() {
        
    }
    
    init(id: Int , name: String , image: String, price: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
    }
    
}
