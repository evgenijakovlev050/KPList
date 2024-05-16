//
//  MoviesListInteractor.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 18.04.2024.
//  
//

import Foundation

final class MoviesListInteractor: PresenterToInteractorMoviesListProtocol {
    // MARK: Properties
    private let presenter: InteractorToPresenterMoviesListProtocol
    private let kpList: KPList
    
    private let storageManager = StorageManager.shared
    var wasAnyStatusChanged: Bool {
        get {
            storageManager.wasAnyStatusChanged
        } set {
            storageManager.wasAnyStatusChanged = newValue
        }
    }
    
    required init(with presenter: InteractorToPresenterMoviesListProtocol, and kpList: KPList) {
        self.presenter = presenter
        self.kpList = kpList
    }
    
    func getHeader() {
        presenter.setHeader(with: kpList.name)
    }
    
    func fetchDatasdc() {
        StorageManager.shared.fetchData(
            predicate: NSPredicate(format: "slug == %@", argumentArray: [kpList.slug])
        ) { [unowned self] result in
            switch result {
            case .success(let films):
                if films.isEmpty {
                    //fetchFromNetwork()
                } else {
                    //presenter.didReceiveData(with: films, and: kpList)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchData() {
        NetworkingManager.shared.fetchDataFaster(
            type: MovieServerModel.self,
            parameters: [
                "limit": ["250"],
                "selectFields": [
                    "id", "name", "enName", "poster",
                    "year","genres", "countries",
                    "watchability"
                ],
                "notNullFields": ["poster.url"],
                "lists" : [kpList.slug]
            ]
        ) { [unowned self] result in
            switch result {
            case .success(let value):
                //value.forEach { $0.store(with: self.kpList.slug) }
                //self.fetchData()
                presenter.didReceiveData(with: value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
