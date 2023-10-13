//
//  TvListDetailsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 24.09.2023.
//

import UIKit
import Firebase

class TvListDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tvList: TvListPopularResults?
    var onTheAir: TvListOnTheAirResults?
    var airingToday: TvListAiringTodayResults?
    var topRated: TvListTopRatedResults?
    var castTvSeries: TvSeriesCast?
    var actorTvSeries: ActorsResults?
    
    var castViewModel = CastTvListViewModel()
    
    var isActorDetailsVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if isActorDetailsVC {
            actorTvSeriesWrite()
            castViewModel.downloadCastTvList(id: castTvSeries?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = onTheAir {
            onTheAirWrite()
            castViewModel.downloadCastTvList(id: onTheAir?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = airingToday {
            airingTodayWrite()
            castViewModel.downloadCastTvList(id: airingToday?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if let _ = topRated {
            topRatedWrite()
            castViewModel.downloadCastTvList(id: topRated?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else {
            popularWrite()
            castViewModel.downloadCastTvList(id: tvList?.id ?? 0) {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
                
    }
    
    func topRatedWrite () {
        titleLabel.text = topRated?.name
        dateLabel.text = topRated?.first_air_date
        overviewLabel.text = topRated?.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(topRated?.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    func airingTodayWrite () {
        titleLabel.text = airingToday?.name
        dateLabel.text = airingToday?.first_air_date
        overviewLabel.text = airingToday?.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(airingToday?.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    func onTheAirWrite () {
        titleLabel.text = onTheAir?.name
        dateLabel.text = onTheAir?.first_air_date
        overviewLabel.text = onTheAir?.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(onTheAir?.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
 
    func actorTvSeriesWrite () {
        titleLabel.text = castTvSeries?.name
        dateLabel.text = castTvSeries?.first_air_date
        overviewLabel.text = castTvSeries?.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(castTvSeries?.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    func popularWrite () {
        titleLabel.text = tvList?.name
        dateLabel.text = tvList?.first_air_date
        overviewLabel.text = tvList?.overview
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(tvList?.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if likeBtn.tag == 0 {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeBtn.tag = 1
            
            let firestoreDatabase = Firestore.firestore()
            
            var firestoreReference : DocumentReference? = nil
            
            var firestoreFavorite : [String: Any] = [:]
            
            if let tvList = tvList {
                firestoreFavorite = ["imageUrl": tvList.poster_path, "title": tvList.name, "overview": tvList.overview, "date": tvList.first_air_date, "id": tvList.id] as [String: Any]
            } else if let topRated = topRated {
                firestoreFavorite = ["imageUrl": topRated.poster_path, "title": topRated.name, "overview": topRated.overview, "date": topRated.first_air_date, "id": topRated.id] as [String: Any]
            } else if let onTheAir = onTheAir {
                firestoreFavorite = ["imageUrl": onTheAir.poster_path, "title": onTheAir.name, "overview": onTheAir.overview, "date": onTheAir.first_air_date, "id": onTheAir.id] as [String: Any]
            } else if let airingToday = airingToday {
                firestoreFavorite = ["imageUrl": airingToday.poster_path, "title": airingToday.name, "overview": airingToday.overview, "date": airingToday.first_air_date, "id": airingToday.id] as [String: Any]
            }
            
            firestoreReference = firestoreDatabase.collection("favoriteTvSeries").addDocument(data: firestoreFavorite, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likeBtn.tag = 0
            
            getDocumentIDForMovie { documentID in
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
    
    func getDocumentIDForMovie (completion: @escaping (String?) -> Void ) {
        let firestoreDatabase = Firestore.firestore()
        
        if let tvList = tvList {
            let tvSeriesID = tvList.id
            
            let tvSeriesFavoriteCollection = firestoreDatabase.collection("favoriteTvSeries")
            let query = tvSeriesFavoriteCollection.whereField("id", isEqualTo: tvSeriesID)
            
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
            let tvSeriesID = topRated.id
            
            let tvSeriesFavoriteCollection = firestoreDatabase.collection("favoriteTvSeries")
            let query = tvSeriesFavoriteCollection.whereField("id", isEqualTo: tvSeriesID)
            
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
        } else if let airingToday = airingToday {
            let tvSeriesID = airingToday.id
            
            let tvSeriesFavoriteCollection = firestoreDatabase.collection("favoriteTvSeries")
            let query = tvSeriesFavoriteCollection.whereField("id", isEqualTo: tvSeriesID)
            
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
        } else if let onTheAir = onTheAir {
            let tvSeriesID = onTheAir.id
            
            let tvSeriesFavoriteCollection = firestoreDatabase.collection("favoriteTvSeries")
            let query = tvSeriesFavoriteCollection.whereField("id", isEqualTo: tvSeriesID)
            
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
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentsButton(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castViewModel.tvListCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvDetailsCell", for: indexPath) as! TvActorsCollectionViewCell
        let tv = castViewModel.tvListCast[indexPath.row]
        cell.tvCastNameLabel.text = tv.name
        cell.tvCastCharacterLabel.text = tv.character
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(tv.profile_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.tvCastImageView.image = image
        }
        return cell
    }

}
