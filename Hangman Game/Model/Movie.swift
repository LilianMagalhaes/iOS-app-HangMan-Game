//
//  Movie.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-12.
//

import Foundation

struct Movie: Decodable {
    var title: String
    var rating: [Rating]
    var genre: String
    var directors: String
    var actors: String
    var released: String
    var type: String
    
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        rating = try container.decode([Rating].self, forKey: CodingKeys.rating)
        genre = try container.decode(String.self, forKey: CodingKeys.genre)
        directors = try container.decode(String.self, forKey: CodingKeys.directors)
        actors = try container.decode(String.self, forKey: CodingKeys.actors)
        released = try container.decode(String.self, forKey: CodingKeys.released)
        type = try container.decode(String.self, forKey: CodingKeys.type)
        }
    
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case rating = "Ratings"
        case genre = "Genre"
        case directors = "Director"
        case actors = "Actors"
        case released = "Released"
        case type = "Type"
        }
}


struct Rating: Decodable {
    var source: String
    var value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source  = try container.decode(String.self, forKey: CodingKeys.source )
        value  = try container.decode(String.self, forKey: CodingKeys.value)
    }
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value  = "Value"
    }
}
/*
{
    "Title": "Star Wars: Episode VIII - The Last Jedi",
    "Year": "2017",
    "Rated": "PG-13",
    "Released": "15 Dec 2017",
    "Runtime": "152 min",
    "Genre": "Action, Adventure, Fantasy",
    "Director": "Rian Johnson",
    "Writer": "Rian Johnson, George Lucas",
    "Actors": "Daisy Ridley, John Boyega, Mark Hamill",
    "Plot": "The Star Wars saga continues as new heroes and galactic legends go on an epic adventure, unlocking mysteries of the Force and shocking revelations of the past.",
    "Language": "English",
    "Country": "United States",
    "Awards": "Nominated for 4 Oscars. 25 wins & 98 nominations total",
    "Poster": "https://m.media-amazon.com/images/M/MV5BMjQ1MzcxNjg4N15BMl5BanBnXkFtZTgwNzgwMjY4MzI@._V1_SX300.jpg",
    "Ratings": [
        {
            "Source": "Internet Movie Database",
            "Value": "6.9/10"
        },
        {
            "Source": "Rotten Tomatoes",
            "Value": "91%"
        },
        {
            "Source": "Metacritic",
            "Value": "84/100"
        }
    ],
    "Metascore": "84",
    "imdbRating": "6.9",
    "imdbVotes": "642,192",
    "imdbID": "tt2527336",
    "Type": "movie",
    "DVD": "27 Mar 2018",
    "BoxOffice": "$620,181,382",
    "Production": "N/A",
    "Website": "N/A",
    "Response": "True"
}
*/
