//
//  TVListVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class TVListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var tvListPopularCollectionView: UICollectionView!
    
    var tvListPopularViewModel = TvListPopularViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tvListPopularCollectionView.dataSource = self
        tvListPopularCollectionView.delegate = self
        
        tvListPopularViewModel.downloadPopularTvList {
            DispatchQueue.main.async {
                self.tvListPopularCollectionView.reloadData()
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
    
    @IBAction func onTheAirButton(_ sender: Any) {
        let onTheAirVC = storyboard?.instantiateViewController(identifier: "toTvListOnTheAirVC") as! TvListOnTheAirVC
        navigationController?.pushViewController(onTheAirVC, animated: false)
    }
    
    @IBAction func airingTodayButton(_ sender: Any) {
        let airingTodayVC = storyboard?.instantiateViewController(identifier: "toTvListAiringTodayVC") as! TvListAiringTodayVC
        navigationController?.pushViewController(airingTodayVC, animated: false)
    }
    
    @IBAction func topRatedButton(_ sender: Any) {
        let topRatedVC = storyboard?.instantiateViewController(identifier: "toTvListTopRatedVC") as! TvListTopRatedVC
        navigationController?.pushViewController(topRatedVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvListPopularViewModel.tvListPopularResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tvListPopularCollectionView.dequeueReusableCell(withReuseIdentifier: "tvListCell", for: indexPath) as! TVListCollectionViewCell
        let tvListResults = tvListPopularViewModel.tvListPopularResults[indexPath.row]
        
        cell.tvListTitleLabel.text = tvListResults.name
        cell.tvListIMDBLabel.text = "(\(String(tvListResults.vote_average)))"
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(tvListResults.poster_path ?? "")"
        if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.tvListImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = tvListPopularViewModel.tvListPopularResults[indexPath.row]
        let tvDetailsVC = storyboard?.instantiateViewController(identifier: "toTvDetailsVC") as! TvListDetailsVC
        tvDetailsVC.isActorDetailsVC = false
        tvDetailsVC.tvList = selectedItem
        navigationController?.pushViewController(tvDetailsVC, animated: true)
    }
    
}
