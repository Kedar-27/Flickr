//
//  RecentVC.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



let recentCellReuseId = "recentImage"
let interestingCellReuseId = "interestingImage"

class RecentVC : UIViewController{
    //MARK: Declarations
    @IBOutlet weak var recentCollectionView: UICollectionView!
   var photosArray = [PhotosData]()
        var myPaginationUpperLimit = 0
        var indexRCount = 0
       var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
      var selectedIndex = 0
    
    let threshold = 0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    let recentSegueId = "fromRecentToPopup"
    
    
//    let recentString = "q=select%20*%20from%20flickr.photos.recent(\(indexRCount),10)%20where%20api_key%3D'd5c7df3552b89d13fe311eb42715b510'&diagnostics=true&format=json"
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
         NetworkManager.shared.delegate = self
        NetworkManager.shared.performAPI(Credentials: self.loadString())
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CheckInternet.Connection(){
            let layout = self.recentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
            layout.minimumInteritemSpacing = 5
            layout.itemSize = CGSize(width: (self.recentCollectionView.frame.width - 20)/2, height: (self.recentCollectionView.frame.height)/3)
            
        }else{
        
            self.Alert(Message: "Your Device is not connected with internet")
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        activityIndi()
    }
}


extension  RecentVC: UICollectionViewDataSource , recievedData ,UICollectionViewDelegate{
    
    //MARK: TableView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArray.count > 0 ?  self.photosArray.count : 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentCellReuseId, for: indexPath) as! RecentCell

        
       // print(indexPath.row)
        let  specificPhoto = photosArray[indexPath.row]
        
        
            cell.setData(photo: specificPhoto)
        cell.indexPathLabel.text = "\(indexPath.row)"
        myPaginationUpperLimit = indexPath.row
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          selectedIndex = indexPath.row
        performSegue(withIdentifier: recentSegueId, sender: indexPath)
      
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == recentSegueId{
            let destVC = segue.destination as! ReusablePopupVC
         destVC.photo = photosArray[selectedIndex]
//            print(photosArray[selectedIndex])
//           print(selectedIndex)
            
            
            //            let photo = photosArray[selectedIndex]
//            destVC.popupImage!.sd_setImage(with: URL(string: "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg" ))
//            //           destVC.popupImage.sd_setImage(with: URL(string: "http://farm2.staticflickr.com/1775/28842532577_0633dda99b.jpg"))
        }
    }
    
    
    
    
    

    func ReceivedData(data: Data) {
        //recieve data here and display through collectionview methods
        
        do{
            let downloadedJson = try JSONDecoder().decode(Query.self, from: data as Data)
            //downloadedJson.data
            
            
            
            
            for photo in downloadedJson.query.results.photo{
                
                let existingarr = self.photosArray.contains(where: { (existingPhoto) -> Bool in
                    existingPhoto.id == photo.id
                })
                if existingarr == true{
                    print("Data repeated from server")
                }else{
                    self.photosArray.append(photo)
                }
            }
            
            
            
            
//            self.photosArray.append(contentsOf: downloadedJson.query.results.photo)
            
            DispatchQueue.main.async {
                self.recentCollectionView.reloadData()
                  self.activityIndicator.stopAnimating()
            }
            
           
        }catch let jsonErr {
            print("Error serializing json:", jsonErr)
            
        }
    }
    
    func loadString() -> String{
        
        return "q=select%20*%20from%20flickr.photos.recent(\(indexRCount),100)%20where%20api_key%3D'd5c7df3552b89d13fe311eb42715b510'&diagnostics=true&format=json"
        
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//      print("func called")
//        if myPaginationUpperLimit == photosArray.count - 1 {
//            print("value equal called \(myPaginationUpperLimit)")
//        indexRCount = indexRCount + 10
//
//        DispatchQueue.global(qos: .userInitiated).async{
//            NetworkManager.shared.performAPI(Credentials:self.loadString())
//        }
//        }
//    }
    

    //MARK: UI Methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

//        let  height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//            if recentCollectionView.contentOffset.y >= (recentCollectionView.contentSize.height - recentCollectionView.frame.size.height) {
//
                //you reached end of the table

        //if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            //reach bottom
        
        
     let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if (bottomEdge >= (scrollView.contentSize.height - 100)) {
            // we are at the end
        
            indexRCount = indexRCount + 100
            NetworkManager.shared.performAPI(Credentials:self.loadString())
        
        }
}
    
    
    
    
    
 
    func activityIndi(){
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
    }
    func Alert (Message: String){
        
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}



