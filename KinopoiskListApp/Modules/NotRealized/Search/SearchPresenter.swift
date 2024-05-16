//
//  SearchPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//  
//

import Foundation

final class SearchPresenter: PresenterToViewSearchProtocol {
    func didTapCell(at index: Int) {
        print("lkclsmlds")
    }
    
    // MARK: Properties
    private weak var view: (ViewToPresenterSearchProtocol)?
    var interactor: PresenterToInteractorSearchProtocol!
    var router: PresenterToRouterSearchProtocol!
    
    private let section = SectionViewModel()
    
    private let storageManager = StorageManager.shared
    
    var wasAnyStatusChanged: Bool {
        get {
            storageManager.wasAnyStatusChanged
        } set {
            storageManager.wasAnyStatusChanged = newValue
        }
    }
    
    // MARK: - Initialization
    required init(with view: ViewToPresenterSearchProtocol) {
        self.view = view
    }
    
    func searchStarted(with title: String) {
        interactor.fetchData(with: title)
    }
}

// MARK: - Extensions - InteractorToPresenterSearchProtocol
extension SearchPresenter: InteractorToPresenterSearchProtocol {
    func didReceiveData(with films: [Film]) {
        section.movieItems.removeAll()
        films.forEach {
            section.movieItems.append(CellViewModel(film: $0))
            print($0.name)
        }
        view?.reloadData(with: section)
    }
}
