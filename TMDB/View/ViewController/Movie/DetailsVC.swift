//
//  DetailsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import UIKit
import Firebase

class DetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsDateLabel: UILabel!
    @IBOutlet weak var detailsDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var results: Results?
    var castMovie: Cast?
    var onDisplay: OnDisplayResults?
    var topRated: MovieTopRatedResults?
    var upcoming: UpcomingResults?
    
    var castViewModel = CastViewModel()
    
    var isActorDetailsVC = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
            
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if isActorDetailsVC {
            actorMovieWrite()
            castViewModel.downloadCastMovie(id: castMovie?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = onDisplay {
            onDisplayWrite()
            castViewModel.downloadCastMovie(id: onDisplay?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = topRated {
            topRatedWrite()
            castViewModel.downloadCastMovie(id: topRated?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = upcoming {
            upcomingWrite()
            castViewModel.downloadCastMovie(id: upcoming?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else {
            write()
            castViewModel.downloadCastMovie(id: results?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
                    
    }
    
    func upcomingWrite () {
        detailsTitleLabel.text = upcoming?.title
        detailsDateLabel.text = upcoming?.release_date
        detailsDescriptionLabel.text = upcoming?.overview
            
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(upcoming?.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            detailsImageView.image = image
        }
    }
    
    func topRatedWrite() {
        detailsTitleLabel.text = topRated?.title
        detailsDateLabel.text = topRated?.release_date
        detailsDescriptionLabel.text = topRated?.overview
            
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(topRated?.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            detailsImageView.image = image
        }
    }
    
    func onDisplayWrite() {
        detailsTitleLabel.text = onDisplay?.title
        detailsDateLabel.text = onDisplay?.release_date
        detailsDescriptionLabel.text = onDisplay?.overview
            
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(onDisplay?.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            detailsImageView.image = image
        }
    }
    
    func actorMovieWrite () {
        detailsTitleLabel.text = castMovie?.title
        detailsDateLabel.text = castMovie?.release_date
        detailsDescriptionLabel.text = castMovie?.overview
            
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(castMovie?.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            detailsImageView.image = image
        }
    }
    
    func write () {
        detailsTitleLabel.text = results?.title
        detailsDateLabel.text = results?.release_date
        detailsDescriptionLabel.text = results?.overview
            
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(results?.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            detailsImageView.image = image
        }
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if likeBtn.tag == 0 {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeBtn.tag = 1

            let firestoreDatabase = Firestore.firestore()
                        
            var firestoreRefrence: DocumentReference? = nil
                    
            var firestoreFavorite: [String: Any] = [:]
            
            if let results = results {
                firestoreFavorite = ["imageUrl": results.poster_path, "title": results.title, "overview": results.overview, "date": results.release_date, "id": results.id] as [String: Any]
            } else if let onDisplay = onDisplay {
                firestoreFavorite = ["imageUrl": onDisplay.poster_path, "title": onDisplay.title, "overview": onDisplay.overview, "date": onDisplay.release_date, "id": onDisplay.id] as [String: Any]
            } else if let topRated = topRated {
                firestoreFavorite = ["imageUrl": topRated.poster_path, "title": topRated.title, "overview": topRated.overview, "date": topRated.release_date, "id": topRated.id] as [String: Any]
            } else if let upcoming = upcoming {
                firestoreFavorite = ["imageUrl": upcoming.poster_path, "title": upcoming.title, "overview": upcoming.overview, "date": upcoming.release_date, "id": upcoming.id] as [String: Any]
            }
            
            firestoreRefrence = firestoreDatabase.collection("favoriteMovie").addDocument(data: firestoreFavorite, completion: { error in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    
                }
            })
            
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likeBtn.tag = 0
                        
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
        
        if let results = results {
            let movieID = results.id
            
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
        } else if let topRated = topRated {
            let movieID = topRated.id
            
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
        } else if let upcoming = upcoming {
            let movieID = upcoming.id
            
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
        } else if let onDisplay = onDisplay {
            let movieID = onDisplay.id
            
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
        }
        completion(nil)
    }
    
    @IBAction func commentMessageButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromTop
        
        let commentVC = storyboard?.instantiateViewController(identifier: "toCommentVC") as! CommentVC
        commentVC.id = results?.id ?? 0
        commentVC.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(commentVC, animated: false)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromTop
        
        let commentVC = storyboard?.instantiateViewController(identifier: "toCommentVC") as! CommentVC
        commentVC.id = results?.id ?? 0
        commentVC.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(commentVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
        
        let cast = castViewModel.cast[indexPath.row]
        cell.castNameLabel.text = cast.name
        cell.castCharacterLabel.text = cast.character
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(cast.profile_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.castImageView.image = image
        }
        return cell
    }

}
