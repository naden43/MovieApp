//
//  Movie.swift
//  MovieApp
//
//  Created by JETSMobileLabMini3 on 24/04/2024.
//

import UIKit

struct Movie : Codable{
    var title : String
    var image : String
    var rating : Float
    var releaseYear : Int
    var genre : [String]
    

    enum CodingKeys :String , CodingKey{
        case title = "title"
        case releaseYear = "year"
        case genre = "genre"
        case rating = "rating"
        case image = "poster"
    }
}

func loadData(complationHandler : @escaping ([Movie])->Void){
    
    print("enter")
    
    let url = URL(string: "https://freetestapi.com/api/v1/movies")
    
    let request = URLRequest(url: url!)
    
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: request) { data, respose, error in
        
        do{
           /* let json2 = try JSONSerialization.jsonObject(with: data!) as? []
            print(json2?[0]["title"])*/
            print(respose!)
            let json = try JSONDecoder().decode(Array<Movie>.self, from: data!)
            //print(json[0].title)
            complationHandler(json)
            
        }catch let error{
            
            print(error.localizedDescription)
        }
        
    }
    task.resume()
    
    
    
    
    
    
}

