//
//  HomeInfoInteractor.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 15.04.2024.
//
import Foundation

final class HomeInfoInteractor: HomeInfoInteractorInputProtocol {
    private unowned let presenter: HomeInfoInteractorOutputProtocol
    private let storangeManager = StorageManager.shared
    
    var wasAnyStatusChanged: Bool {
        get {
            storangeManager.wasAnyStatusChanged
        } set {
            storangeManager.wasAnyStatusChanged = newValue
        }
    }

    required init(presenter: HomeInfoInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func getFavorites() {
        presenter.favoritesDidUpdate(
            with: storangeManager.fetchFavorites()
        )
        wasAnyStatusChanged = false
    }
    
    func fetchData() {
        var dataStore = HomeInfoDataStore()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        let startDate = Date()
        print("GetCollections starting...")
        NetworkingManager.shared.fetchDataFaster(
            type: KPList.self,
            parameters: [
                "limit": ["20"],
                "notNullFields" : ["cover.url"]
            ]
        ) { result in
            switch result {
            case .success(let value):
                dataStore.kpLists = value
                print("Collections fetched")
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
            print("GetCollections finishing...")
        }
        
        dispatchGroup.enter()
        print("GetPersons starting...")
        NetworkingManager.shared.fetchDataFaster(
            type: Person.self,
            parameters: [
                "limit": ["250"],
                "selectFields": [
                    "id", "name", "enName", "photo",
                    "birthday","death", "age",
                    "profession", "facts"
                ],
                "notNullFields": [
                    "birthday", "photo", "age",
                    "name", "countAwards", "facts.value"
                ],
                "sortField": ["countAwards"],
                "sortType": ["-1"]
            ]
        ) { result in
            switch result {
            case .success(let value):
                dataStore.persons = value
                print("Persons fetched")
            case .failure(let error):
                print(error)
            }
            dispatchGroup.leave()
            print("GetPersons finishing...")
        }
        
        print("Notify starting...")
        dispatchGroup.notify(queue: .main) { [unowned self] in
            dataStore.categoryList = StorageManager.shared.getCategories()
            storangeManager.fetchFavorites().forEach { dataStore.films.append($0) }
            presenter.dataDidReceive(with: dataStore)
            print(Date().timeIntervalSince(startDate))
            print("Notify finishing...")
        }
        
    }
}
