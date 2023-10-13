//
//  TVSeriesFavoriteVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit
import Firebase

class TVSeriesFavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var dateArray = [String]()
    var overviewArray = [String]()
    var idArray = [Int]()
    var imageArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFavoriteTVSeries()
        
    }
    
    func getDataFavoriteTVSeries () {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("favoriteTvSeries").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if !(snapshot?.isEmpty ?? true) {
                    for document in snapshot!.documents {
                        if let title = document.get("title") as? String {
                            self.titleArray.append(title)
                        }
                        if let date = document.get("date") as? String {
                            self.dateArray.append(date)
                        }
                        if let overview = document.get("overview") as? String {
                            self.overviewArray.append(overview)
                        }
                        if let id = document.get("id") as? Int {
                            self.idArray.append(id)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.imageArray.append(imageUrl)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteMovieButton(_ sender: Any) {
        let movieVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(movieVC, animated: false)
    }
    
    @IBAction func favoriteActorsButton(_ sender: Any) {
        let actorsVC = storyboard?.instantiateViewController(identifier: "toActorsFavoriteVC") as! ActorsFavoriteVC
        navigationController?.pushViewController(actorsVC, animated: false)
    }
    
    @IBAction func homePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func upcomingMovieButton(_ sender: Any) {
        let upcomingVC = storyboard?.instantiateViewController(identifier: "toUpcomingVC") as! UpcomingVC
        navigationController?.pushViewController(upcomingVC, animated: false)
    }
    
    @IBAction func accountButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteTVSeriesCell", for: indexPath) as! TVSeriesFavoriteTableViewCell
        cell.tvSeriesFavoriteTitleLabel.text = titleArray[indexPath.row]
        cell.tvSeriesFavoriteDateLabel.text = dateArray[indexPath.row]
        
        let imageUrlString = imageArray[indexPath.row]
        if let imageUrl  = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.tvSeriesFavoriteImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "toTvSeriesFavoriteDetailsVC") as! TvSeriesFavoriteDetailsVC
        detailsVC.tvSeriesTitle = titleArray[indexPath.row]
        detailsVC.date = dateArray[indexPath.row]
        detailsVC.overview = overviewArray[indexPath.row]
        detailsVC.id = idArray[indexPath.row]
        detailsVC.imageUrlString = imageArray[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }

}
