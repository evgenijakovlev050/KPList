//
//  SearchPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//  
//

final class SearchPresenter: PresenterToViewSearchProtocol {
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
    
    func didTapCell(at index: Int) {
        router.presentMovieDetail(with: section.movieItems[index])
    }
}

// MARK: - Extensions - InteractorToPresenterSearchProtocol
extension SearchPresenter: InteractorToPresenterSearchProtocol {
    func didReceiveData(with movies: [MovieServerModel]) {
        section.movieItems.removeAll()
        movies.forEach { movie in
            if !movie.name.isEmpty && movie.poster?.url != nil {
                section.movieItems.append(CellViewModel(movie: movie))
                print(movie.name)
            }
        }
        view?.reloadData(with: section)
    }
}
