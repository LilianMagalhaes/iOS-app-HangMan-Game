//
//  DictionaryMode.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-05.
//

import Foundation
class WordManager {
    
    static let shared = WordManager()
    private init() {}

    private let baseUrl = "https://random-word-api.herokuapp.com/"
    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    
    func getWord(callback: @escaping (Bool, Data?) -> Void) {
        guard let url = URL(string: baseUrl + "word") else {
            callback(false, nil)
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        return
                }
                callback(true, data)
            }
        }
        task?.resume()
    }
}

