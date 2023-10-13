//
//  ViewController.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var movieViewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        movieViewModel.downloadMovie {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModel.results.count
    }

    @IBAction func impressionButton(_ sender: Any) {
        let onDisplayVC = storyboard?.instantiateViewController(identifier: "toOnDisplayVC") as! OnDisplayVC
        navigationController?.pushViewController(onDisplayVC, animated: false)
    }
    
    @IBAction func upcomingButton2(_ sender: Any) {
        let upcomingVC = storyboard?.instantiateViewController(identifier: "toUpcomingVC") as! UpcomingVC
        navigationController?.pushViewController(upcomingVC, animated: false)
    }
    
    @IBAction func topRatedButton(_ sender: Any) {
        let topRatedVC = storyboard?.instantiateViewController(identifier: "toTopRatedVC") as! TopRatedVC
        navigationController?.pushViewController(topRatedVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let item = movieViewModel.results[indexPath.row]
        
        cell.movieTitleLabel.text = item.title
        cell.movieIMDBLabel.text = "(\(String(item.vote_average)))"
        
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(item.poster_path ?? "")"
        
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.movieImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = movieViewModel.results[indexPath.row]
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.results = selectedItem
        detailsVC.isActorDetailsVC = false
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}

