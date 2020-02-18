//
//  RecentCell.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



class RecentCell : UICollectionViewCell {
    
    
    @IBOutlet weak var indexPathLabel: UILabel!
    
    @IBOutlet weak var recentImageView: UIImageView!
    
    
    func setData(photo: Photo){
        
        if recentImageView.image == nil{
        recentImageView.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_t_d.jpg" )
            
        )
        }else{
            recentImageView.image = nil
                    recentImageView.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_t_d.jpg" ))
         
        }
       // print(photo.id)
        
    }
    
    
    
    
    
    
}   



