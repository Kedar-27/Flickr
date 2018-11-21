//
//  Photos.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



struct Query: Decodable{
    
    
    
    let query: Results
    
    enum CodingKeys: String, CodingKey {
        case query = "query"
        
        
    }
}

struct Results: Decodable{
    let results: Photos
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        
    }
 
}
struct Photos: Decodable{
   
    let photo: [PhotosData]
    
    
    enum CodingKeys: String, CodingKey {
       
        case photo = "photo"
        
    }
    
}
struct PhotosData: Decodable{
    let farm: String
    let secret: String
    let id: String
    let server: String
    
    
    enum CodingKeys: String, CodingKey {
        case farm = "farm"
          case secret = "secret"
          case id = "id"
          case server = "server"
        
    }
    
}
