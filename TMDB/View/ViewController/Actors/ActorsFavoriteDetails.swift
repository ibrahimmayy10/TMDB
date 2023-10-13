//
//  ActorsFavoriteDetails.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit
import Firebase

class ActorsFavoriteDetails: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var likedBtn: UIButton!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var tvSeriesCollectionView: UICollectionView!
    
    var id = Int()
    var name = String()
    var department = String()
    var imageUrlString = String()
    
    var actorMoviesViewModel = ActorsMoviesViewModel()
    var actorTvSeriesViewModel = ActorsTvSeriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        tvSeriesCollectionView.delegate = self
        tvSeriesCollectionView.dataSource = self
        
        actorMoviesViewModel.downloadActorsMovie(id: id) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
        
        actorTvSeriesViewModel.downloadActorsTvSeries(id: id) {
            DispatchQueue.main.async {
                self.tvSeriesCollectionView.reloadData()
            }
        }
        
        write()
        
    }
    
    func write () {
        nameLabel.text = name
        departmentLabel.text = department
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = .push
        transition.subtype = .fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toActorsFavoriteVC") as! ActorsFavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if likedBtn.tag == 0 {
            likedBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likedBtn.tag = 1
                        
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
        
        let actorID = id
        
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
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "actorFavoriteMovieCell", for: indexPath) as! ActorsFavoriteMovieCollectionViewCell
            let movie = actorMoviesViewModel.actorMovies[indexPath.row]
            cell.actorFavoriteMovieTitleLabel.text = movie.title
            cell.actorFavoriteMovieIMDBLabel.text = String(movie.vote_average)
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: imageData)
                cell.actorFavoriteMovieImageView.image = image
            }
            return cell
        } else if collectionView == tvSeriesCollectionView {
            let cell = tvSeriesCollectionView.dequeueReusableCell(withReuseIdentifier: "actorFavoriteTvSeriesCell", for: indexPath) as! ActorsFavoriteTvSeriesCollectionViewCell
            let tvSeries = actorTvSeriesViewModel.actorTvSeries[indexPath.row]
            cell.actorTvSeriesFavoriteTitleLabel.text = tvSeries.name
            cell.actorTvSeriesIMDBLabel.text = String(tvSeries.vote_average)
            
            if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(tvSeries.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
                let image = UIImage(data: imageData)
                cell.actorTvSeriesFavoriteImageView.image = image
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
}
