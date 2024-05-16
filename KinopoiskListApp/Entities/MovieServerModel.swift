//
//  MovieServerModel.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 25.04.2024.
//

struct MovieServerModel: ResponseType {
    let id: Int
    let name: String
    let poster: UrlToImage?
    let year: Int
    let genres: [GenreOrCountryOrCinemaPlatform]
    let countries: [GenreOrCountryOrCinemaPlatform]
    let watchability: Watchability?
    
    static var type = "movie"
    static var searchType = "/search"
    static let database = StorageManager.shared
    
    var countriesAndGenresString: String {
        return "\(convertArrayToString(from: countries)) - \(convertArrayToString(from: genres))"
    }
    
    // Determine either movie is enabled to watch on KP
    var isOnline: Bool {
        guard let watchability = watchability else { return false }
        return !watchability.items.filter { $0.name == "Kinopoisk HD" }
            .isEmpty
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case poster
        case year
        case genres
        case countries
        case watchability
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        if let poster = try? container.decodeIfPresent(UrlToImage.self, forKey: .poster) {
            self.poster = poster
        } else {
            self.poster = nil
        }
        self.year = try container.decode(Int.self, forKey: .year)
        self.genres = try container.decode([GenreOrCountryOrCinemaPlatform].self, forKey: .genres)
        self.countries = try container.decode([GenreOrCountryOrCinemaPlatform].self, forKey: .countries)
        self.watchability = try container.decodeIfPresent(Watchability.self, forKey: .watchability)
    }
    
    func convertArrayToString(from array: [GenreOrCountryOrCinemaPlatform]) -> String {
        array.map { $0.name }
            .joined(separator: ", ")
    }
    
    // Core Data Usage
    func store(with kpListSlug: String = "", personId: Int? = nil, title: String = "") {
        guard let film = MovieServerModel.database.add(Film.self) else { return }
        film.id = Int64(id)
        film.name = name
        film.poster = poster?.url
        film.isFavorite = false
        film.watchability = isOnline
        film.genres = countriesAndGenresString
        film.slug = kpListSlug
        film.year = String(year)
        film.searchTitle = title
        film.isWatched = false
        film.isFavorite = true
        if let personId = personId {
            film.personId = Int64(personId)
        }
        MovieServerModel.database.saveContext()
        //return film
    }
}

struct UrlToImage: Codable {
    let url: String
}

struct GenreOrCountryOrCinemaPlatform: Codable {
    let name: String
}

struct Watchability: Codable {
    let items: [GenreOrCountryOrCinemaPlatform]
}
