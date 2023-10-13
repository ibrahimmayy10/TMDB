//
//  ActorsVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 22.09.2023.
//

import UIKit

class ActorsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var actorsViewModel = ActorsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        actorsViewModel.downloadActors {
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
    
    @IBAction func selectedButton(_ sender: Any) {
        let alert = UIAlertController(title: "Select Type", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Movie", style: .default, handler: { action in
            let movieVC = self.storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
            self.navigationController?.pushViewController(movieVC, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "TV List", style: .default, handler: { action in
            let tvListVC = self.storyboard?.instantiateViewController(identifier: "toTvListVC") as! TVListVC
            self.navigationController?.pushViewController(tvListVC, animated: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Actors", style: .default, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { action in
            
        }))
        
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorsViewModel.actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "actorsCell", for: indexPath) as! ActorsCollectionViewCell
        
        let actors = actorsViewModel.actors[indexPath.row]
        cell.actorsNameLabel.text = actors.name
        cell.actorsDepartmentLabel.text = actors.known_for_department
        
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(actors.profile_path ?? "")"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.actorsImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = actorsViewModel.actors[indexPath.row]
        let actorsDetailsVC = storyboard?.instantiateViewController(identifier: "toActorsDetailsVC") as! ActorsDetailsVC
        actorsDetailsVC.actorsResults = selectedItem
        navigationController?.pushViewController(actorsDetailsVC, animated: true)
    }

}
