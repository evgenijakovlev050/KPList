//
//  SearchContract.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 15.04.2024.
//
import Foundation

protocol FavoriteStatusProtocol: AnyObject {
    var wasAnyStatusChanged: Bool { get set }
}

/// ViewInputProtocol (VC conforms, Presenter contains)
protocol HomeInfoViewInputProtocol: AnyObject {
    func reloadData(section: SectionViewModel)
    func reloadDataAfterFavoritesUpdate(section: SectionViewModel)
}

/// ViewOutputProtocol (Presenter conforms, VC contains
protocol HomeInfoViewOutputProtocol: FavoriteStatusProtocol {
    var wasAnyStatusChanged: Bool { get set }
    init(view: HomeInfoViewInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
    func updateFavoriteMovies()
}

/// InteractorInput (Interactor conforms, Presenter contains)
protocol HomeInfoInteractorInputProtocol: FavoriteStatusProtocol {
    var wasAnyStatusChanged: Bool { get set }
    init(presenter: HomeInfoInteractorOutputProtocol)
    func fetchData()
    func getFavorites()
}

/// InteractorOutput (Presenter confroms, Interactor contains)
protocol HomeInfoInteractorOutputProtocol: AnyObject {
    func dataDidReceive(with dataStore: HomeInfoDataStore)
    func favoritesDidUpdate(with films: [Film])
}

/// RouterInput (Router conforms, Presenter contains)
protocol HomeInfoRouterInputProtocol {
    init(view: HomeInfoViewController)
    func routeToMoviesListVC(of kpList: KPList)
    func routeToKPListsVC(of category: String)
    func routeToPersonDetailVC(of person: Person)
    func presentMovieDetail(with viewModel: CellViewModelProtocol)
}
