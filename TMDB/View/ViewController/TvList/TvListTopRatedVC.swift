//
//  TvListTopRatedVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class TvListTopRatedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var topRatedViewModel = TvListTopRatedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        topRatedViewModel.downloadTopRatedTvList {
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
        let tvListVC = storyboard?.instantiateViewController(identifier: "toTvListVC") as! TVListVC
        navigationController?.pushViewController(tvListVC, animated: false)
    }
    
    @IBAction func onTheAirButton(_ sender: Any) {
        let onTheAirVC = storyboard?.instantiateViewController(identifier: "toTvListOnTheAirVC") as! TvListOnTheAirVC
        navigationController?.pushViewController(onTheAirVC, animated: false)
    }
    
    @IBAction func airingTodayButton(_ sender: Any) {
        let airingTodayVC = storyboard?.instantiateViewController(identifier: "toTvListAiringTodayVC") as! TvListAiringTodayVC
        navigationController?.pushViewController(airingTodayVC, animated: false)
    }
    
    @IBAction func selectedButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select Type", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Movie", style: .default, handler: { action in
            let vc = self.storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "TV List", style: .default, handler: { action in

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
        return topRatedViewModel.tvListTopRatedResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tvListTopRatedCell", for: indexPath) as! TvListTopRatedCollectionViewCell
        
        let topRated = topRatedViewModel.tvListTopRatedResults[indexPath.row]
        cell.tvListTopRatedTitleLabel.text = topRated.name
        cell.tvListTopRatedIMDBLabel.text = "(\(String(topRated.vote_average)))"

        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(topRated.poster_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.tvListTopRatedImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = topRatedViewModel.tvListTopRatedResults[indexPath.row]
        let tvDetailsVC = storyboard?.instantiateViewController(identifier: "toTvDetailsVC") as! TvListDetailsVC
        tvDetailsVC.isActorDetailsVC = false
        tvDetailsVC.topRated = selectedItem
        navigationController?.pushViewController(tvDetailsVC, animated: true)
    }
    
}
