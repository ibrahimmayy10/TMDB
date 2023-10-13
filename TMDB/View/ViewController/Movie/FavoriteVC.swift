//
//  FavoriteVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 20.09.2023.
//

import UIKit
import Firebase

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var dateArray = [String]()
    var imageArray = [String]()
    var overviewArray = [String]()
    var idArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
                
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFirestore()
                
    }
    
    func getDataFirestore() {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("favoriteMovie").addSnapshotListener { snapshot, error in
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
                        if let image = document.get("imageUrl") as? String {
                            self.imageArray.append(image)
                        }
                        if let overview = document.get("overview") as? String {
                            self.overviewArray.append(overview)
                        }
                        if let id = document.get("id") as? Int {
                            self.idArray.append(id)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteTVSeriesButton(_ sender: Any) {
        let tvSeriesVC = storyboard?.instantiateViewController(identifier: "toTVSeriesFavoriteVC") as! TVSeriesFavoriteVC
        navigationController?.pushViewController(tvSeriesVC, animated: false)
    }
    
    @IBAction func favoriteActorsButton(_ sender: Any) {
        let actorsVC = storyboard?.instantiateViewController(identifier: "toActorsFavoriteVC") as! ActorsFavoriteVC
        navigationController?.pushViewController(actorsVC, animated: false)
    }
    
    
    @IBAction func homePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "toViewControllerVC") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func upcomingButton(_ sender: Any) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.favoriteTitleLabel.text = titleArray[indexPath.row]
        cell.favoriteDateLabel.text = dateArray[indexPath.row]
        
        let imageUrlString = imageArray[indexPath.row]
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.favoriteImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteDetailsVC = storyboard?.instantiateViewController(identifier: "toFavoriteDetailsVC") as! FavoriteDetailsVC
        favoriteDetailsVC.imageUrlString = imageArray[indexPath.row]
        favoriteDetailsVC.movieTitle = titleArray[indexPath.row]
        favoriteDetailsVC.date = dateArray[indexPath.row]
        favoriteDetailsVC.overview = overviewArray[indexPath.row]
        favoriteDetailsVC.id = idArray[indexPath.row]
        navigationController?.pushViewController(favoriteDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }
    
}
