//
//  ReusablePopupVC.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 01/08/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



class ReusablePopupVC: UIViewController{
    
    
    
    @IBOutlet weak var popupImage: UIImageView!
    
    
    var photo: PhotosData?
    
    
    
   // var imageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        popupImage.image = nil
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    //    self.popupImage.image = nil
  
        if let photo = photo{
            self.popupImage.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg" ))
            }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        popupImage.isUserInteractionEnabled = true
        popupImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        popupImage.image = nil
//    }
//
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    self.dismiss(animated: false, completion: {})
    //dismiss(animated: true)
    // Your action
}
    
  
    
//    func setImage(photo: PhotosData){
//
//           self.popupImage.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg" ))
//
//
//        popupImage.downloadedFrom(link: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg" )
//
    
    
    
    
    
    
    
    
}



