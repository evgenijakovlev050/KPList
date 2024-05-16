//
//  SearchInteractor.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//
//

import Foundation

final class SearchInteractor: PresenterToInteractorSearchProtocol {
    // MARK: Properties
    private let presenter: InteractorToPresenterSearchProtocol
    private let storageManager = StorageManager.shared
    var wasAnyStatusChanged: Bool {
        get {
            storageManager.wasAnyStatusChanged
        } set {
            storageManager.wasAnyStatusChanged = newValue
        }
    }
    
    required init(with presenter: InteractorToPresenterSearchProtocol) {
        self.presenter = presenter
    }
    
    func fetchDatavfds(with title: String) {
        storageManager.fetchData(
            predicate: NSPredicate(format: "searchTitle == %@", argumentArray: [title])//NSPredicate(format: "searchTitle == %d" , title)
        ) { [unowned self] result in
            switch result {
            case .success(let films):
                if films.isEmpty {
                    //fetchFromNetwork(with: title)
                } else {
                    //presenter.didReceiveData(with: films)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchData(with title: String) {
        NetworkingManager.shared.fetchDataFaster(
            type: MovieServerModel.self,
            searchType: MovieServerModel.searchType,
            parameters: [
                "limit": ["30"],
                "query" : [title]
            ]
        ) { [unowned self] result in
            switch result {
            case .success(let value):
//                let movies = value.compactMap { movie in
////                    if !storageManager.checkIfItemExist(id: movie.id) {
////                        movie.store()
////                    }
//                    var film: Film?
//                    
//                    if let movie = storageManager.fetchSearchResults(
//                        predicate: NSPredicate(format: "id == %d" , movie.id)
//                    ) {
//                        film = movie
//                    } else {
//                        film = movie.store(title: title)
//                    }
//                    
//                    film?.searchTitle = title
//                    storageManager.saveContext()
//                    
//                    return film
//                }
                
                presenter.didReceiveData(with: value)
                //self.fetchData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
