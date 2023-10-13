//
//  OnDisplayVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class OnDisplayVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieDisplayViewModel = MovieDisplayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        movieDisplayViewModel.downloadNowPlayingMovie {
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
    
    @IBAction func trendingButton(_ sender: Any) {
        let trendingVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(trendingVC, animated: false)
    }
    
    @IBAction func upcomingButton2(_ sender: Any) {
        let upcomingVC = storyboard?.instantiateViewController(identifier: "toUpcomingVC") as! UpcomingVC
        navigationController?.pushViewController(upcomingVC, animated: false)
    }
    
    @IBAction func topRatedButton(_ sender: Any) {
        let topRatedVC = storyboard?.instantiateViewController(identifier: "toTopRatedVC") as! TopRatedVC
        navigationController?.pushViewController(topRatedVC, animated: false)
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
        return movieDisplayViewModel.resultsDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviePlayingCell", for: indexPath) as! PlayingMovieCollectionViewCell
        let onDisplayMovie = movieDisplayViewModel.resultsDisplay[indexPath.row]
        cell.moviePlayingTitleLabel.text = onDisplayMovie.title
        cell.moviePlayingIMDBLabel.text = "(\(String(onDisplayMovie.vote_average)))"
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(onDisplayMovie.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.moviePlayingImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = movieDisplayViewModel.resultsDisplay[indexPath.row]
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.onDisplay = selectedItem
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}
