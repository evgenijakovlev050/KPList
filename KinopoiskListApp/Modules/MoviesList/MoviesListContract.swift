//
//  MoviesListContract.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 18.04.2024.
//  
//

/// ViewInputProtocol (VC conforms, Presenter contains)
protocol ViewToPresenterMoviesListProtocol: AnyObject {
    func reloadData(with section: SectionViewModel)
    func reloadHeader(with title: String)
}

/// ViewOutputProtocol (Presenter conforms, VC contains)
protocol PresenterToViewMoviesListProtocol: FavoriteStatusProtocol {
    init(with view: ViewToPresenterMoviesListProtocol)
    var interactor: PresenterToInteractorMoviesListProtocol! { get set }
    var router: PresenterToRouterMoviesListProtocol! { get set }
    func viewDidLoad()
    func didTapCell(at index: Int)
}

/// InteractorInputProtocol (Interactor confroms, Presenter contains)
protocol PresenterToInteractorMoviesListProtocol: FavoriteStatusProtocol {
    init(with presenter: InteractorToPresenterMoviesListProtocol, and kpList: KPList)
    func getHeader()
    func fetchData()
}

/// InteractorOutputProtocol (Presenter conforms, Interactor contains)
protocol InteractorToPresenterMoviesListProtocol: AnyObject {
    func didReceiveData(with movies: [MovieServerModel])
    func setHeader(with title: String)
}

/// RouterInputProtocol (Router conforms, Presenter contains)
protocol PresenterToRouterMoviesListProtocol {
    init(with view: MoviesListViewController)
    func presentMovieDetail(with viewModel: CellViewModelProtocol)
}
