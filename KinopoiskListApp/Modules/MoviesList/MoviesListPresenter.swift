//
//  MoviesListPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 18.04.2024.
//  
//
import Foundation

// MARK: - PresenterToViewMoviesListProtocol
final class MoviesListPresenter: PresenterToViewMoviesListProtocol {
    // MARK: Properties
    private weak var view: (ViewToPresenterMoviesListProtocol)?
    var interactor: PresenterToInteractorMoviesListProtocol!
    var router: PresenterToRouterMoviesListProtocol!
    
    private let section = SectionViewModel()
    
    required init(with view: ViewToPresenterMoviesListProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.getHeader()
        interactor.fetchData()
    }
    
    func didTapCell(at index: Int) {
        router.presentMovieDetail(with: section.movieItems[index])
    }
}

// MARK: - Extensions - InteractorToPresenterMoviesListProtocol
extension MoviesListPresenter: InteractorToPresenterMoviesListProtocol {
    func setHeader(with title: String) {
        view?.reloadHeader(with: title)
    }
    
    func didReceiveData(with films: [Film], and kpList: KPList) {
        section.categoryName = kpList.name
        films.forEach { section.movieItems.append(CellViewModel(film: $0)) }
        view?.reloadData(with: section)
    }
}
