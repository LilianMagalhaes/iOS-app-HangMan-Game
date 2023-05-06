//
//  MovieManager.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-12.
//

import Foundation

class MovieManager {
    static var shared = MovieManager()
    private init() {}
    private  let baseUrl = "https://www.omdbapi.com/"
    

    private var task: URLSessionTask?

    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    
    func getMovie( callback: @escaping(Bool, Movie?) -> Void)  {
        guard let randomMovieId = imdbIdTab.randomElement(),
            let url = URL(string: "\(baseUrl)?apiKey=44c17920&i=\(randomMovieId)&r=json") else {
            callback(false, nil)
            return
            }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
         
         task?.cancel()
         task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response =  response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let movie =  try? JSONDecoder().decode(Movie.self, from: data)
                else {
                    callback(false, nil)
                    return
                }
                
             callback(true, movie)
                print(movie)
                }
            }
        task?.resume()
    }
}





