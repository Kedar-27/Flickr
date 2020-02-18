//
//  InterestingVC.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



class InterestingVC: UIViewController{
    
    
    
    
    @IBOutlet weak var interestingCollectionView: UICollectionView!
    //    let recentString = "q=select%20*%20from%20flickr.photos.interestingness(\(indexICount),10)%20where%20api_key%3D'd5c7df3552b89d13fe311eb42715b510'&diagnostics=true&format=json"
    
    var photosArray = [Photo]()
    var selectedIndex = 0
    var indexICount = 1
    var myPaginationUpperLimit = 0
    
    let interestingSegueId = "fromInterestingToPopup"
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.delegate = self
        
        
        NetworkManager.shared.performAPI(Credentials: self.loadString())
        
        
        interestingCollectionView.dataSource = self
        interestingCollectionView.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CheckInternet.Connection(){
            let layout = self.interestingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
            layout.minimumInteritemSpacing = 5
            layout.itemSize = CGSize(width: (self.interestingCollectionView.frame.width - 20)/2, height: (self.interestingCollectionView.frame.height)/3)
        }else{
            self.Alert(Message: "Your Device is not connected with internet")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        activityIndi()
    }
}



extension InterestingVC : UICollectionViewDataSource, recievedData ,UICollectionViewDelegate{
    
    
    //MARK: TableView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArray.count > 0 ?  self.photosArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: interestingCellReuseId, for: indexPath) as! InterestingCell
        
        let specificPhoto = photosArray[indexPath.row]
        cell.setData(photo: specificPhoto)
        myPaginationUpperLimit = indexPath.row
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: interestingSegueId, sender: indexPath)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == interestingSegueId{
            let destVC = segue.destination as! ReusablePopupVC
            destVC.photo = photosArray[selectedIndex]
            
            
        }
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        //do something heree
    //
    //         if indexPath.row + 1 == photosArray.count  {
    //        indexICount = indexICount + 10
    //
    //            DispatchQueue.global(qos: .userInitiated).async{
    //                NetworkManager.shared.performAPI(Credentials:self.loadString())
    //            }
    //     // collectionView.reloadData()
    //
    //        }
    //    }
    
    func ReceivedData(data: Data) {
        do{
            let downloadedJson = try JSONDecoder().decode(FlickrJSONResponse.self, from: data as Data)
            //downloadedJson.data
            //   self.photosArray.append(contentsOf:downloadedJson.query.results.photo)
            
            for photo in downloadedJson.photos.photo{
                
                let existingarr = self.photosArray.contains(where: { (existingPhoto) -> Bool in
                    existingPhoto.id == photo.id
                })
                if existingarr == true{
                    print("Data repeated from server")
                }else{
                    self.photosArray.append(photo)
                }
            }
            
            DispatchQueue.main.async {
                self.interestingCollectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }catch let jsonErr {
            print("Error serializing json:", jsonErr)
            
        }
    }
    
    func loadString() -> String{
        
        return "/?method=flickr.photos.getRecent&api_key=\(apiKey)&per_page=10&format=json&page=\(indexICount)&nojsoncallback=1"

        
        
        
    }
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        print("interesting scrolled")
    //        if myPaginationUpperLimit == photosArray.count - 1{
    //        indexICount = indexICount + 10
    //
    //        DispatchQueue.global(qos: .userInitiated).async{
    //            NetworkManager.shared.performAPI(Credentials:self.loadString())
    //    }
    //        }
    //    }
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let  height = scrollView.frame.size.height
    //        let contentYoffset = scrollView.contentOffset.y
    //        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
    //        if distanceFromBottom < height {
    //            print(" you reached end of the table")
    //
    //            if myPaginationUpperLimit == photosArray.count - 1{
    //                        indexICount = indexICount + 10
    //
    //                        DispatchQueue.global(qos: .userInitiated).async{
    //                            NetworkManager.shared.performAPI(Credentials:self.loadString())
    //                    }
    //                        }
    //
    //        }
    //    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (bottomEdge >= (scrollView.contentSize.height - 100)) {
            // we are at the end
            indexICount = indexICount + 1
            
            NetworkManager.shared.performAPI(Credentials:self.loadString())
            
            
        }
        
        
        
        
    }
    func activityIndi(){
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        
        
        
    }
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
}
