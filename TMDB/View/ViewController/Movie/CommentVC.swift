//
//  CommentVC.swift
//  TMDB
//
//  Created by İbrahim Ay on 21.09.2023.
//

import UIKit

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var commentTableView: UITableView!
    
    var id = Int()
    var results = [CommentResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.dataSource = self
        commentTableView.delegate = self

        getData()
        
    }
    
    func getData () {
        let url = "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=3e4dbb0176e7f36f4df0a3b954f5a609"
        guard let url = URL(string: url) else { return }
        
        Webservices().downloadComment(url: url) { result in
            switch result {
            case .success(let result):
                if let result = result {
                    self.results = result
                    DispatchQueue.main.async {
                        self.commentTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let result = results[indexPath.row]
        cell.commentLabel.text = result.content
        cell.nameLabel.text = result.author
        return cell
    }
    
}
