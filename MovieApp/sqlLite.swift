//
//  sqlLite.swift
//  MovieApp
//
//  Created by JETSMobileLabMini3 on 28/04/2024.
//

import UIKit
import SQLite3

class DataBaseManager {
    
    static var instance = DataBaseManager()
    
    var fullBath:String?
    
    var db:OpaquePointer?
    
    private init(){
        let dataBaseFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let myDataBaseName = "Movie.sqlite"
        
        fullBath = dataBaseFile?.appendingPathComponent(myDataBaseName).path()
        
        db = openDB()
    }
    
    public func openDB() -> OpaquePointer?{
        var db : OpaquePointer?
        
        guard let dataBasePath = fullBath else{
            return nil
        }
        
        if sqlite3_open(dataBasePath, &db) == SQLITE_OK {
            
            return db
        }
        else{
            return nil
        }
    }
    
    public func createMovieTable(){
        
        let createTableQuery = """
 create table movie(title char(255) primary key not null, rate double , year int , genre Text , image blob)
 """
        
        var createStatment:OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery,-1, &createStatment, nil) == SQLITE_OK{
            
            print("created successfully")
            
            if sqlite3_step(createStatment) == SQLITE_DONE {
                print("run")
            }
            else{
                print("fail to run")
            }
        }
        else{
            print("fail")
        }
        
        sqlite3_finalize(createStatment)
        
    }
    
    public func insertMovie(movie:Movie){
        
        let insertQuery = "insert into movie values(? , ? , ?, ? , ?)"
        
        var compiledInsertStatment : OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &compiledInsertStatment, nil) == SQLITE_OK {
            
            print("compiled successfully")
            
            //var title:NSString = movie.title.
            
            /*sqlite3_bind_text(compiledInsertStatment, 1 ,( movie.title as NSString).utf8String, -1, nil)
             
             /* let movieImage = NSData(data: movie.image)
              sqlite3_bind_blob(compiledInsertStatment, 5, movieImage.bytes,  Int32(movieImage.length), nil)*/
             //sqlite3_bind_text(compiledInsertStatment, 5, (String("img1") as NSString).utf8String, -1, nil)
             
             sqlite3_bind_double(compiledInsertStatment, 2, Double(movie.rating))
             
             sqlite3_bind_int(compiledInsertStatment, 3, Int32(movie.releaseYear))
             
             let genre = movie.genre.joined(separator: ",") as NSString
             sqlite3_bind_text(compiledInsertStatment, 4, genre.utf8String, -1, nil)
             
             if sqlite3_step(compiledInsertStatment) == SQLITE_DONE {
             
             print("run successfully")
             }
             else{
             
             print("fail")
             }
             
             }
             
             sqlite3_finalize(compiledInsertStatment)*/
        }
    }
    
    public func retriveMovies() -> [Movie] {
        
        let retriveMoviesQuery = "select * from movie"
        
        var retriveMoviesStatment:OpaquePointer?
        
        var listOfMovies:[Movie] = []
        if sqlite3_prepare_v2(db, retriveMoviesQuery, -1, &retriveMoviesStatment, nil) == SQLITE_OK {
            
            print("prespared")
            while sqlite3_step(retriveMoviesStatment) == SQLITE_ROW{
                
                print("start")
                /*let title = String(cString: sqlite3_column_text(retriveMoviesStatment, 0))*/
                
              
                
                
                //let imageTxt = String(cString:sqlite3_column_text(retriveMoviesStatment, 4))
                //print(imageTxt)
                
                //let image:UIImage = UIImage(named: imageTxt)!
                
                let movieImageBlob = sqlite3_column_blob(retriveMoviesStatment, 4)
                let movieImageBlobLength = sqlite3_column_bytes(retriveMoviesStatment, 4)
               /*let imageData = Data(bytes: movieImageBlob!, count: Int(movieImageBlobLength))
                //let image = UIImage(data: imageData)!
                
                
                let rate = Float(sqlite3_column_double(retriveMoviesStatment, 1))
                
                let releaseYear = Int(sqlite3_column_int(retriveMoviesStatment, 2))
                
                let genre = String(cString: sqlite3_column_text(retriveMoviesStatment, 3)).components(separatedBy: ",")*/
                
                /*let movie = convertToMovie(title: title, image: imageData, rating: rate, releaseYear: releaseYear, genre: genre)
                
                listOfMovies.append(movie)*/
            }
            
            print("success")
        }
        
        sqlite3_finalize(retriveMoviesStatment)
        return listOfMovies
    }
    
    /*public func convertToMovie(title : String ,image : Data ,rating : Float,releaseYear : Int,genre : [String]) -> Movie{
        
        /*let movie = Movie(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genre)*/
        
        return movie
        
    }*/
    
    public func deleteMovie(key : String){
        
        let deleteQuery = "DELETE FROM movie WHERE title = \"\(key)\""
        
        var deleteStatment:OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatment, nil) == SQLITE_OK{
            
            //sqlite3_bind_text(deleteStatment, 1, (key as NSString ).utf8String, -1, nil)
            if sqlite3_step(deleteStatment) == SQLITE_DONE {
                print("done")
            }
        }
        
        sqlite3_finalize(deleteStatment)
        
    }
    
}
