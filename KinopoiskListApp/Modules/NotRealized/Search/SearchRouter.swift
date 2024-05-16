//
//  SearchRouter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 07.05.2024.
//  
//

import Foundation
import UIKit

class SearchRouter: PresenterToRouterSearchProtocol {
    private unowned let view: SearchViewController

    required init(with view: SearchViewController) {
        self.view = view
    }
    
    func presentMovieDetail(with viewModel: CellViewModelProtocol) {
        let vc = MovieDetailViewController()
        vc.delegate = view
        vc.viewModel = viewModel
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        view.present(vc, animated: true)
    }
}
