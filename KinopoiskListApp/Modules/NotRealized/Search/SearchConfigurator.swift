//
//  SearchConfigurator.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//

protocol SearchConfiguratorProtocol {
    static func configure(withView view: SearchViewController)
}

final class SearchConfigurator: SearchConfiguratorProtocol {
    static func configure(withView view: SearchViewController) {
        let presenter = SearchPresenter(with: view)
        let interactor = SearchInteractor(with: presenter)
        let router = SearchRouter(with: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
