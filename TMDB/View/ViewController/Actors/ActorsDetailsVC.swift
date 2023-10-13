//
//  ActorsDetailsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 23.09.2023.
//

import UIKit
import Firebase

class ActorsDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var likedBtn: UIButton!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var tvSeriesCollectionView: UICollectionView!
    
    var actorsResults: ActorsResults?
    var actorMoviesViewModel = ActorsMoviesViewModel()
    var actorTvSeriesViewModel = ActorsTvSeriesViewModel()
        
    var isActorDetailsVC = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
                
        tvSeriesCollectionView.dataSource = self
        tvSeriesCollectionView.delegate = self
        
        actorMoviesViewModel.downloadActorsMovie(id: actorsResults?.id ?? 0) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }

        actorTvSeriesViewModel.downloadActorsTvSeries(id: actorsResults?.id ?? 0) {
            DispatchQueue.main.async {
                self.tvSeriesCollectionView.reloadData()
            }
        }
        
        write()
        
    }
    
    func write () {
        nameLabel.text = actorsResults?.name
        departmentLabel.text = actorsResults?.known_for_department
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(actorsResults?.profile_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if likedBtn.tag == 0 {
            likedBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likedBtn.tag = 1
            
            let firestoreDatabase = Firestore.firestore()
            
            var firestoreReference : DocumentReference? = nil
            
            var firestoreFavorite : [String: Any] = [:]
            
            firestoreFavorite = ["imageUrl": actorsResults?.profile_path, "name": actorsResults?.name, "department": actorsResults?.known_for_department, "id": actorsResults?.id] as [String: Any]
            
            firestoreReference = firestoreDatabase.collection("actorFavorite").addDocument(data: firestoreFavorite, completion: { error in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        } else {
            likedBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likedBtn.tag = 0
            
            getDocumentForActor { documentID in
                if let documentID = documentID {
                    let firestoreDatabase = Firestore.firestore()
                    firestoreDatabase.collection("actorFavorite").document(documentID).delete { error in
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
    
    func getDocumentForActor (completion: @escaping (String?) -> Void ) {
        let firestoreDatabase = Firestore.firestore()
        
        let actorID = actorsResults?.id
        
        let actorFavoriteCollection = firestoreDatabase.collection("actorFavorite")
        let query = actorFavoriteCollection.whereField("id", isEqualTo: actorID)
        
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
        completion(nil)
    }
    
    @IBAction func commentButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return actorMoviesViewModel.actorMovies.count
        } else if collectionView == tvSeriesCollectionView {
            return actorTvSeriesViewModel.actorTvSeries.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == movieCollectionView {
            
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "actorMovieCell", for: indexPath) as! ActorsMovieCollectionViewCell
            let actorMovies = actorMoviesViewModel.actorMovies[indexPath.row]
            cell.actorMovieTitleLabel.text = actorMovies.title
            cell.actorMovieIMDBLabel.text = "(\(String(actorMovies.vote_average)))"
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(actorMovies.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: imageData)
                cell.actorMovieImageView.image = image
            }
            
            return cell
            
        } else if collectionView == tvSeriesCollectionView {
            
            let cell = tvSeriesCollectionView.dequeueReusableCell(withReuseIdentifier: "actorTvSeriesCell", for: indexPath) as! ActorsTvSeriesCollectionViewCell
            
            let actorTvSeries = actorTvSeriesViewModel.actorTvSeries[indexPath.row]
            
            cell.actorTvTitleLabel.text = actorTvSeries.name
            cell.actorTvIMDBLabel.text = "(\(String(actorTvSeries.vote_average)))"
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(actorTvSeries.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: imageData)
                cell.actorTvImageView.image = image
            }
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == movieCollectionView {
            let selectedItem = actorMoviesViewModel.actorMovies[indexPath.row]
            let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
            detailsVC.castMovie = selectedItem
            detailsVC.isActorDetailsVC = true
            navigationController?.pushViewController(detailsVC, animated: true)
        } else if collectionView == tvSeriesCollectionView {
            let selectedItem = actorTvSeriesViewModel.actorTvSeries[indexPath.row]
            let tvDetailsVC = storyboard?.instantiateViewController(identifier: "toTvDetailsVC") as! TvListDetailsVC
            tvDetailsVC.castTvSeries = selectedItem
            tvDetailsVC.isActorDetailsVC = true
            navigationController?.pushViewController(tvDetailsVC, animated: true)
        }
    }
}
