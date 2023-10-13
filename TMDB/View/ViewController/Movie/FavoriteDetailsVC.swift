//
//  FavoriteDetailsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 7.10.2023.
//

import UIKit
import Firebase

class FavoriteDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likedBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageUrlString = String()
    var movieTitle = String()
    var date = String()
    var overview = String()
    var id = Int()
    
    var castViewModel = CastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        castViewModel.downloadCastMovie(id: id) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        write()
                
    }
    
    func write() {
        titleLabel.text = movieTitle
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
                        
            getDocumentIDForMovie { documentID in
                if let documentID = documentID {
                    let firestoreDatabase = Firestore.firestore()
                    firestoreDatabase.collection("favoriteMovie").document(documentID).delete { error in
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
    
    func getDocumentIDForMovie (completion: @escaping (String?) -> Void ) {
        let firestoreDatabase = Firestore.firestore()
            
        let movieID = id
        
        let movieFavoriteCollection = firestoreDatabase.collection("favoriteMovie")
        let query = movieFavoriteCollection.whereField("id", isEqualTo: movieID)
            
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Sorgu sırasında bir hata oluştu: \(error.localizedDescription)")
            } else {
                if let document = querySnapshot?.documents.first {
                    let documentID = document.documentID
                    completion(documentID)
                } else {
                    print("Belge bulunamadı.")
                }
            }
        }
            
        completion(nil)
    }

    @IBAction func commentButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCollectionCell", for: indexPath) as! FavoriteCollectionViewCell
        let cast = castViewModel.cast[indexPath.row]
        cell.favoriteNameLabel.text = cast.name
        cell.favoriteCharacterLabel.text = cast.character
        
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(cast.profile_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.favoriteImageView.image = image
        }
        return cell
    }
    
}
