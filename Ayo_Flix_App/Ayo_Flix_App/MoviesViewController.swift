//
//  MoviesViewController.swift
//  Ayo_Flix_App
//
//  Created by Ayo  on 1/26/20.
//  Copyright © 2020 Ayo . All rights reserved.
//

import UIKit
import AlamofireImage

// Step one: Add UITableViewDataSource, UITableViewDelegate
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
        
    // Creating an array of dictionaries
    
    @IBOutlet var tableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
// Step three: Call the implemented functions.
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        print("Hello")
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            // Movies is an array of dictionaries.
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            //Reload data to call the tableView functions
            self.tableView.reloadData()
            print(self.movies)
           // print(dataDictionary)
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()

    }
    //Step two: Add tableView functions.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieViewCell") as! MovieViewCell
        let movie = movies[indexPath.row]
        // Cast the title to a string
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
    
        
        //indexPath.row is the index associated with each row. 
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        //Created custom cell
        cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
   
}
