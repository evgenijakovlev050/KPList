//
//  SearchContract.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//  
//

/// ViewInputProtocol (VC conforms, Presenter contains)
protocol ViewToPresenterSearchProtocol: AnyObject {
    func reloadData(with section: SectionViewModel)
}

/// ViewOutputProtocol (Presenter conforms, VC contains)
protocol PresenterToViewSearchProtocol: FavoriteStatusProtocol {
    init(with view: ViewToPresenterSearchProtocol)
    var interactor: PresenterToInteractorSearchProtocol! { get set }
    var router: PresenterToRouterSearchProtocol! { get set }
    func searchStarted(with title: String)
    func didTapCell(at index: Int)
}

/// InteractorInputProtocol (Interactor confroms, Presenter contains)
protocol PresenterToInteractorSearchProtocol: FavoriteStatusProtocol {
    init(with presenter: InteractorToPresenterSearchProtocol)
    func fetchData(with title: String)
}

/// InteractorOutputProtocol (Presenter conforms, Interactor contains)
protocol InteractorToPresenterSearchProtocol: AnyObject {
    func didReceiveData(with movies: [MovieServerModel])
}

/// RouterInputProtocol (Router conforms, Presenter contains)
protocol PresenterToRouterSearchProtocol {
    init(with view: SearchViewController)
    func presentMovieDetail(with viewModel: CellViewModelProtocol)
}

