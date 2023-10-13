//
//  TopRatedVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class TopRatedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieTopRatedViewModel = MovieTopRatedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        movieTopRatedViewModel.downloadTopRatedMovie {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func upcomingButton(_ sender: Any) {
        let upcomingVC = storyboard?.instantiateViewController(identifier: "toUpcomingVC") as! UpcomingVC
        navigationController?.pushViewController(upcomingVC, animated: false)
    }
    
    @IBAction func accountButton(_ sender: Any) {
        let accountVc = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVc, animated: false)
    }
    
    @IBAction func onDisplayButton(_ sender: Any) {
        let onDisplayVC = storyboard?.instantiateViewController(identifier: "toOnDisplayVC") as! OnDisplayVC
        navigationController?.pushViewController(onDisplayVC, animated: false)
    }
    
    @IBAction func trendingButton(_ sender: Any) {
        let trendingVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(trendingVC, animated: false)
    }
    
    @IBAction func selectedButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select Type", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Movie", style: .default, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "TV List", style: .default, handler: { action in
            let tvListVC = self.storyboard?.instantiateViewController(identifier: "toTvListVC") as! TVListVC
            self.navigationController?.pushViewController(tvListVC, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Actors", style: .default, handler: { action in
            let actorsVC = self.storyboard?.instantiateViewController(identifier: "toActorsVC") as! ActorsVC
            self.navigationController?.pushViewController(actorsVC, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
            
        }))
        
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTopRatedViewModel.topRatedResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieTopRatedCell", for: indexPath) as! MovieTopRatedCollectionViewCell
        let topRatedMovie = movieTopRatedViewModel.topRatedResults[indexPath.row]
        cell.movieTopRatedTitleLabel.text = topRatedMovie.title
        cell.movieTopRatedIMDBLabel.text = "(\(String(topRatedMovie.vote_average)))"
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(topRatedMovie.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.movieTopRatedImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = movieTopRatedViewModel.topRatedResults[indexPath.row]
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.topRated = selectedItem
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
