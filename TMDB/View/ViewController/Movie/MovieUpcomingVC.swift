//
//  UpcomingVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import UIKit

class UpcomingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    
    var upcomingViewModel = UpcomingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
        
        upcomingViewModel.downloadUpcoming {
            DispatchQueue.main.async {
                self.upcomingCollectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func homePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func accountButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    @IBAction func trendingButton(_ sender: Any) {
        let trendingVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(trendingVC, animated: false)
    }
    
    @IBAction func onDisplayButton(_ sender: Any) {
        let onDisplayVC = storyboard?.instantiateViewController(identifier: "toOnDisplayVC") as! OnDisplayVC
        navigationController?.pushViewController(onDisplayVC, animated: false)
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
        return upcomingViewModel.upcomingResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! UpcomingCollectionViewCell
        let upcoming = upcomingViewModel.upcomingResults[indexPath.row]
        cell.upcomingTitleLabel.text = upcoming.title
        cell.upcomingIMDBLabel.text = "(\(String(upcoming.vote_average))"
        
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(upcoming.poster_path)"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.upcomingImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = upcomingViewModel.upcomingResults[indexPath.row]
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.upcoming = selectedItem
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
