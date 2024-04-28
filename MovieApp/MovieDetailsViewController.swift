//
//  ViewController.swift
//  MovieApp
//
//  Created by JETSMobileLabMini3 on 24/04/2024.
//

import UIKit
import Cosmos

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var movieRate: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    var movie:Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie?.title
        movieRate.rating = Double(movie?.rating ?? 0.0)
        movieRate.settings.updateOnTouch = false
        
        movieImg.image = UIImage(data: movie?.image ?? Data())
        
        //movieRate.text = String(movie?.rating ?? 5)
        
        movieYear.text =  String(movie?.releaseYear ?? 2001)
        
        movieGenre.text = movie?.genre.joined()
        
        
        
    }
    
    
}

