//
//  TvSeriesFavoriteDetailsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit
import Firebase

class TvSeriesFavoriteDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likedBtn: UIButton!
    
    var tvSeriesTitle = String()
    var date = String()
    var overview = String()
    var imageUrlString = String()
    var id = Int()
    
    var castViewModel = CastTvListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        castViewModel.downloadCastTvList(id: id) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        write()
        
    }
    
    func write () {
        titleLabel.text = tvSeriesTitle
        dateLabel.text = date
        overviewLabel.text = overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }

    @IBAction func likedButton(_ sender: Any) {
        if likedBtn.tag == 0 {
            likedBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likedBtn.tag = 1
            
            getDocumentIDForTvSeries { documentID in
                if let documentID = documentID {
                    let firestoreDatabase = Firestore.firestore()
                    firestoreDatabase.collection("favoriteTvSeries").document(documentID).delete { error in
                        if error != nil {
                            print(error?.localizedDescription)
                        } else {
                            print("silme işlemi başarılı")
                        }
                    }
                }
            }
        }
    }
    
    func getDocumentIDForTvSeries (completion: @escaping (String?) -> Void ) {
        let firestoreDatabase = Firestore.firestore()
        
        let tvSeriesID = id
        
        let tvSeriesFavoriteCollection = firestoreDatabase.collection("favoriteTvSeries")
        let query = tvSeriesFavoriteCollection.whereField("id", isEqualTo: tvSeriesID)
        
        query.getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if let document = snapshot?.documents.first {
                    let documentID = document.documentID
                    completion(documentID)
                } else {
                    print("belge bulunamadı")
                }
            }
        }
    }
    
    @IBAction func commentButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toTVSeriesFavoriteVC") as! TVSeriesFavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel.tvListCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteTvSeriesCollectionCell", for: indexPath) as! FavoriteTvSeriesCastCollectionViewCell
        let cast = castViewModel.tvListCast[indexPath.row]
        cell.favoriteTvSeriesCastTitleLabel.text = cast.name
        cell.favoriteTvSeriesCastCharacterLabel.text = cast.character
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(cast.profile_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.favoriteTvSeriesCastImageView.image = image
        }
        return cell
    }
    
}
