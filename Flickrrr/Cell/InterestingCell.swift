//
//  InterestingCell.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit

class InterestingCell: UICollectionViewCell{
    
    
    @IBOutlet weak var interestingImageView: UIImageView!
    
    
    func setData(photo: Photo ){
        if interestingImageView.image == nil{
            interestingImageView.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_t_d.jpg" )
                
            )
        }else{
            interestingImageView.image = nil
           interestingImageView.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_t_d.jpg" ))
           
        }
   
    }
    
}
