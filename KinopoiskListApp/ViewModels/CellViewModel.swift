//
//  HomeInfoCellViewModel.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 16.04.2024.
//

import Foundation

protocol CellViewModelProtocol {
    var cellItemName: String { get }
    var imageUrl: String? { get }
    var id: Int { get }
    var favoriteStatus: Bool { get }
    var watchedStatus: Bool { get }
    func setFavoriteStatus()
    func setWatchedStatus()
}

protocol SectionViewModelProtocol: AnyObject {
    var personItems: [CellViewModelProtocol] { get }
    var kpListItems: [CellViewModelProtocol] { get }
    var categoryItems: [CellViewModelProtocol] { get }
    var movieItems: [CellViewModelProtocol] { get set }
    var singlePerson: CellViewModelProtocol { get }
    var numberOfCategoryItems: Int { get }
    var numberOfPersonItems: Int { get }
    var numberOfKPListItems: Int { get }
    var numberOfMovieItems: Int { get }
    var numberOfSections: Int { get }
}

final class CellViewModel: CellViewModelProtocol {
    private let storageManager = StorageManager.shared
    
    ///Items for each cell
    var person: Person?
    var kpList: KPList?
    var film: Film?
    private var category: String?
    
    ///Detect which kind of section is (facts or categories)
    var isFact: Bool
    
    var favoriteStatus: Bool {
        film?.isFavorite ?? false
    }
    
    var watchedStatus: Bool {
        film?.isWatched ?? false
    }
    
    var id: Int {
        if let person = person {
            return person.id
        } else if let film = film {
            return Int(film.id)
        }
        fatalError("no model exists")
    }
    
    var cellItemName: String {
        if let person = person {
            return person.name
        } else if let kpList = kpList {
            return kpList.name
        } else if let film = film {
            return film.name ?? ""
        }
        return category ?? ""
    }
    
    var imageUrl: String? {
        if let person = person {
            return person.photo
        } else if let kpList = kpList {
            return kpList.cover.url
        } else if let film = film {
            return film.poster
        }
        return nil
    }
    
    init(
        kpList: KPList? = nil,
        person: Person? = nil,
        category: String? = nil,
        movie: MovieServerModel? = nil,
        film: Film? = nil,
        isFact: Bool = false
    ) {
        self.kpList = kpList
        self.person = person
        self.category = category
        self.film = film
        self.isFact = isFact
    }
    
    // MARK: - Favorite status of film was changed
    func setFavoriteStatus() {
        storageManager.wasAnyStatusChanged = true
        guard let film = film else { return }
        film.isFavorite.toggle()
        storageManager.saveContext()
    }
    
    // MARK: - Watched status of film was changed
    func setWatchedStatus() {
        guard let film = film else { return }
        film.isWatched.toggle()
        storageManager.saveContext()
    }
}

final class SectionViewModel: SectionViewModelProtocol {
    // MARK: - Section Items
    var personItems: [CellViewModelProtocol] = []
    var kpListItems: [CellViewModelProtocol] = []
    var categoryItems: [CellViewModelProtocol] = []
    var movieItems: [CellViewModelProtocol] = []
    var singlePerson: CellViewModelProtocol = CellViewModel()
    
    var numberOfCategoryItems: Int {
        categoryItems.count
    }
    
    var numberOfPersonItems: Int {
        personItems.count
    }
    
    var numberOfKPListItems: Int {
        kpListItems.count
    }
    
    var numberOfMovieItems: Int {
        movieItems.count
    }
    
    var numberOfSections: Int {
        (numberOfMovieItems > 0) ? 4 : 3
    }
    
    var categoryName = ""
}
