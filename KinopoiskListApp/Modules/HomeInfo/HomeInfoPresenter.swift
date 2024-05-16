//
//  HomeInfoPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 15.04.2024.
//

import Foundation

struct HomeInfoDataStore {
    var kpLists: [KPList] = []
    var persons: [Person] = []
    var categoryList: [String] = []
    var films: [Film] = []
    
    func getBirthdayPersons() -> [Person] {
        return persons.filter { $0.thisMonthBirth }
    }
}

final class HomeInfoPresenter {
    // MARK: - Properties
    var interactor: HomeInfoInteractorInputProtocol!
    var router: HomeInfoRouterInputProtocol!
    private unowned let view: HomeInfoViewInputProtocol
    private var dataStore: HomeInfoDataStore?
    private var section = SectionViewModel()
    
    // MARK: - Initialization
    required init(view: HomeInfoViewInputProtocol) {
        self.view = view
    }
}

// MARK: - HomeInfoViewOutputProtocol
extension HomeInfoPresenter: HomeInfoViewOutputProtocol {
    var wasAnyStatusChanged: Bool {
        get {
            interactor.wasAnyStatusChanged
        }
        set {
            interactor.wasAnyStatusChanged = newValue
        }
    }
    
    func viewDidLoad() {
        interactor.fetchData()
    }
    
    func updateFavoriteMovies() {
        interactor.getFavorites()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let kpList = dataStore?.kpLists[indexPath.item] else { return }
            router.routeToMoviesListVC(of: kpList)
        case 1:
            guard let category = dataStore?.categoryList[indexPath.item] else { return }
            router.routeToKPListsVC(of: category)
        case 2:
            guard let person = dataStore?.getBirthdayPersons()[indexPath.item] else { return }
            router.routeToPersonDetailVC(of: person)
        default:
            router.presentMovieDetail(with: section.movieItems[indexPath.item])
        }
    }
}

// MARK: - HomeInfoInteractorOutputProtocol
extension HomeInfoPresenter: HomeInfoInteractorOutputProtocol {
    func dataDidReceive(with dataStore: HomeInfoDataStore) {
        self.dataStore = dataStore
        dataStore.kpLists
            .forEach { section.kpListItems.append(CellViewModel(kpList: $0)) }
        dataStore.categoryList
            .forEach { section.categoryItems.append(CellViewModel(category: $0)) }
        dataStore.getBirthdayPersons()
            .forEach { section.personItems.append(CellViewModel(person: $0)) }
        dataStore.films
            .forEach { section.movieItems.append(CellViewModel(film: $0)) }
        view.reloadData(section: section)
    }
    
    func favoritesDidUpdate(with films: [Film]) {
        section.movieItems.removeAll()
        
        if !films.isEmpty {
            films.forEach { movie in
                section.movieItems.append(CellViewModel(film: movie))
            }
        }
        view.reloadDataAfterFavoritesUpdate(section: section)
    }
}
