//
//  News.swift
//  newsApp
//
//  Created by Burak Aydın on 9.09.2023.
//

import Foundation
//Encodable tam tersi post
//Decodable internetten gelen verileri okunabilir bir dönüşüm gerçekleştirir get

struct News : Decodable {
    
    let title : String
    let story : String
}
