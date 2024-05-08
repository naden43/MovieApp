//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by JETSMobileLabMini3 on 24/04/2024.
//

import UIKit
import Reachability
import CoreData


class MoviesListViewController: UIViewController {
    

    @IBOutlet weak var MovieTable: UITableView!
    var movieSList : [Movie]?
    
    var appDelegate :AppDelegate?
    var context : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        
        
        MovieTable.delegate = self
        MovieTable.dataSource = self
        movieSList = []
        
        /*let indecator = UIActivityIndicatorView(style: .large)
        indecator.center = view.center
        indecator.startAnimating()
        view.addSubview(indecator)*/
        /*loadData {[weak self] movies in
            DispatchQueue.main.sync {
                self?.movieSList = movies
                self?.MovieTable.reloadData()
                indecator.stopAnimating()
            }
        }*/
            
            //loadData(complationHandler: load)
            
        
            /*let img = UIImage(named: "img1")
             let movie1:Movie = Movie(title: "movie1", image: img, rating: 4.5, releaseYear: 2001, genre: ["Action , " , "Comedy"])
             
             movieSList?.append(movie1)
             
             let movie2:Movie = Movie(title: "movie2", image: "img2", rating: 3, releaseYear: 2002, genre: ["Action"])
             
             movieSList?.append(movie2)
             
             let movie3:Movie = Movie(title: "movie3", image: "img3", rating: 2, releaseYear: 2020, genre: ["Comedy , " , "Cartoon"])
             
             movieSList?.append(movie3)
             
             let movie4:Movie = Movie(title: "movie4", image: "img4", rating: 4, releaseYear: 2013, genre: ["Action , " , "Comedy"])
             
             movieSList?.append(movie4)
             
             let movie5:Movie = Movie(title: "movie5", image: "img5", rating: 5, releaseYear: 2001, genre: ["Action , " , "Comedy"])
             
             movieSList?.append(movie5)*/
            
            print("here")
            
        }
        
        func load(movies:[Movie]){
            DispatchQueue.main.sync {
                movieSList = movies
                MovieTable.reloadData()
                //indecator.stopAnimating()
            }
        }
        
    
    override func viewWillAppear(_ animated: Bool) {
        
       /* let database = DataBaseManager.instance
        movieSList = database.retriveMovies()*/
        
        let reachability = try! Reachability()
        
        
        switch reachability.connection {
            
        case .unavailable:
            fetchCoreData()
        case .wifi:
            fetchApi()
        case .cellular:
            print("here")
        }
        
        
        func fetchCoreData(){
         
            let fetch = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
            do{
                let result = try context?.fetch(fetch)
                for item in result! {
                    let movie = convertMovieApiToMovie(data:item)
                    movieSList?.append(movie)
                }
            }
            catch{
                print("error")
            }
            
            MovieTable.reloadData()
            
        }
        
        func fetchApi(){
            
            
            let fetch = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
            do{
                let result = try context?.fetch(fetch)
                for item in result! {
                    context?.delete(item)
                }
                try context?.save()
            }
            catch{
                print("error")
            }
            let indecator = UIActivityIndicatorView(style: .large)
            indecator.center = view.center
            indecator.startAnimating()
            view.addSubview(indecator)
            loadData {[weak self] movies in
                DispatchQueue.main.sync {
                    self?.movieSList = movies
                    convertMovieToMovieApi(movies: movies)
                    self?.MovieTable.reloadData()
                    indecator.stopAnimating()
                }
            }
            
            
            
        }
        
        func convertMovieToMovieApi(movies:[Movie]){
            let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context!)
            for item in movies {
                let mov = NSManagedObject(entity: entity!, insertInto: context!)
                mov.setValue(item.title, forKey: "title")
                mov.setValue(item.rating, forKey: "rate")
                mov.setValue(item.genre.joined(separator: ","), forKey: "genre")
                mov.setValue(item.image, forKey: "image")
                mov.setValue(item.releaseYear, forKey: "releaseYear")
            }
            
            do{
                try context?.save()
            }catch let error {
                print("error")
            }
        }
        
        func convertMovieApiToMovie(data:NSManagedObject) -> Movie{
            
             let title = data.value(forKey: "title") as? String
             let releaseYear = data.value(forKey: "releaseYear") as? Int
             let image = data.value(forKey: "image") as? String
             let rate = data.value(forKey: "rate") as? Float
            let genre = data.value(forKey: "genre") as? String
            let list:[String] = genre?.components(separatedBy: ",") ?? []
            
            let movie = Movie(title: title!, image: image!, rating: rate!, releaseYear: releaseYear!, genre: list)
            
            return movie
            
        }
        
    }
    @IBAction func insertMovie(_ sender: Any) {
        
        let addScreen = self.storyboard?.instantiateViewController(withIdentifier: "add_screen") as! AddMovieViewController
        
        addScreen.movieManager = self
        
        self.navigationController?.pushViewController(addScreen, animated: true)
    }
}


extension MoviesListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieSList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movieSList?[indexPath.row].title ?? "Invalid Movie"
        cell.imageView?.image = UIImage(systemName: "movieclapper")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard?.instantiateViewController(identifier:"details_screen" ) as! MovieDetailsViewController
        
        
        details.movie = movieSList?[indexPath.row]
        
        self.present(details, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction:UIContextualAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") {_,_,_ in 
            
            let alert = UIAlertController(title: "Delete Movie", message: "Are you sure you want to delete ?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                let key = self.movieSList?[indexPath.row].title
                self.movieSList?.remove(at: indexPath.row)
                
                /*let database = DataBaseManager.instance
                database.deleteMovie(key: key ?? "film")*/
                
                
                self.MovieTable.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
     
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
        
    }
    
    
}

extension MoviesListViewController : MovieManager{
    func addMovie(movie: Movie) {
        let dataBase = DataBaseManager.instance
        dataBase.insertMovie(movie: movie)
        movieSList = dataBase.retriveMovies()
        MovieTable.reloadData()
    }
    
    
}
