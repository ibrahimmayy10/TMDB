//
//  ActorsFavoriteVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 11.10.2023.
//

import UIKit
import Firebase

class ActorsFavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var departmentArray = [String]()
    var idArray = [Int]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFavoriteActor()
        
    }
    
    func getDataFavoriteActor () {
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("actorFavorite").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error)
            } else {
                if !(snapshot?.isEmpty ?? true) {
                    for document in snapshot!.documents {
                        if let name = document.get("name") as? String {
                            self.nameArray.append(name)
                        }
                        if let department = document.get("department") as? String {
                            self.departmentArray.append(department)
                        }
                        if let id = document.get("id") as? Int {
                            self.idArray.append(id)
                        }
                        if let image = document.get("imageUrl") as? String {
                            self.imageArray.append(image)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func movieButton(_ sender: Any) {
        let movieVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(movieVC, animated: false)
    }
    
    @IBAction func favoriteTvSeriesButton(_ sender: Any) {
        let tvSeriesVC = storyboard?.instantiateViewController(identifier: "toTVSeriesFavoriteVC") as! TVSeriesFavoriteVC
        navigationController?.pushViewController(tvSeriesVC, animated: false)
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
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteActorsCell", for: indexPath) as! ActorsFavoriteTableViewCell
        cell.actorsFavoriteTitleLabel.text = nameArray[indexPath.row]
        cell.actorsFavoriteDepartmentLabel.text = departmentArray[indexPath.row]
        
        let imageUrlString = imageArray[indexPath.row]
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)"), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.actorsFavoriteImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "toActorsFavoriteDetailsVC") as! ActorsFavoriteDetails
        detailsVC.name = nameArray[indexPath.row]
        detailsVC.department = departmentArray[indexPath.row]
        detailsVC.id = idArray[indexPath.row]
        detailsVC.imageUrlString = imageArray[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 183
    }

}
