//
//  NetworkManager.swift
//  Blincc
//
//  Created by Kedar Sukerkar on 23/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit
import Alamofire


let apiBaseUrl = "https://query.yahooapis.com/v1/public/yql?"

class NetworkManager{
    
    
    
    
    var delegate: recievedData?
    static var shared = NetworkManager()
    
    func performAPI(Credentials: String)  {
        
        let apiParamUrl = apiBaseUrl + Credentials
        
        print(apiParamUrl)
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let url = URL(string: apiParamUrl)else
            { return
                
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                
                guard let data  = data, response !=  nil else
                {
                    return
                }
                print(data)
                self.delegate?.ReceivedData(data: data)
            }.resume()
            
        }
    }
}

protocol recievedData {
    func ReceivedData(data: Data)
    
}




