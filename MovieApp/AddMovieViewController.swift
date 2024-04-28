//
//  AddMovieViewController.swift
//  MovieApp
//
//  Created by JETSMobileLabMini3 on 24/04/2024.
//

import UIKit
import Cosmos

class AddMovieViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var datePicker: UIPickerView!
    
    var movieManager:MovieManager?
    
    @IBOutlet weak var moveiGenre: UITextField!
    
    @IBOutlet weak var movieRate: CosmosView!
    @IBOutlet weak var movieTitle: UITextField!
    var filmYears : [Int]?
    var yearOfRelease : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmYears = []
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy"
        let currentYear:Int = Int(dateFormat.string(from: Date())) ?? 2024
        
        for i in 1990...currentYear{
            
            filmYears?.append(i)
        }
        
        datePicker.delegate = self
        datePicker.dataSource = self
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        moviePoster.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        picker.dismiss(animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return filmYears?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year:String = String(filmYears?[row] ?? 2024)
        return year
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearOfRelease = filmYears?[row]
    }

    @IBAction func addMovie(_ sender: Any) {
        
        if movieTitle.text == "" {
            
            let alert = UIAlertController(title: "Add Movie", message: "At Least enter the movie title", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            let title :String = movieTitle.text ?? "film"
            let Myear:Int = yearOfRelease ?? 2024
            let genreList:[String] = moveiGenre.text?.components(separatedBy:",") ?? []
            let image:Data  = (moviePoster.image?.pngData()!)!
            
            let movie : Movie = Movie(title: title , image: image, rating: Float(movieRate.rating), releaseYear: Myear , genre: genreList)
            
            movieManager?.addMovie(movie: movie)
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    

}
