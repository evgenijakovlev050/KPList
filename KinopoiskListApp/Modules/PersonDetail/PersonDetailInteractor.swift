//
//  PersonDetailInteractor.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 17.04.2024.
//  
//

import Foundation

final class PersonDetailInteractor: PresenterToInteractorPersonDetailProtocol {
    // MARK: Properties
    private unowned let presenter: InteractorToPresenterPersonDetailProtocol
    private let person: Person
    
    required init(with presenter: InteractorToPresenterPersonDetailProtocol, and person: Person) {
        self.presenter = presenter
        self.person = person
    }
    
    func fetchData() {
        NetworkingManager.shared.fetchDataFaster(
            type: MovieServerModel.self,
            parameters: [
                "limit": ["20"],
                "notNullFields": ["name", "poster.url", "year"],
                "persons.id" : ["\(person.id)"]
            ]
        ) { [weak self] result in
            switch result {
            case .success(let value):
                guard let self = self else { return }
                presenter.didReceiveData(with: value, and: person)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDatacdf() {
        StorageManager.shared.fetchData(
            predicate: NSPredicate(format: "personId == %@", argumentArray: [person.id])
        ) { result in
            switch result {
            case .success(let films):
                if films.isEmpty {
                    //fetchFromNetwork()
                } else {
                    //presenter.didReceiveData(with: films, and: person)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
