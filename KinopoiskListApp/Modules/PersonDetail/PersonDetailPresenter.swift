//
//  PersonDetailPresenter.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 17.04.2024.
//  
//

import Foundation

final class PersonDetailPresenter: PresenterToViewPersonDetailProtocol {
    // MARK: Properties
    private unowned let view: ViewToPresenterPersonDetailProtocol
    var interactor: PresenterToInteractorPersonDetailProtocol!
    var router: PresenterToRouterPersonDetailProtocol!
    private let section = SectionViewModel()
    
    required init(with view: ViewToPresenterPersonDetailProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchData()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        router.presentMovieDetail(with: section.movieItems[indexPath.item])
    }
}

extension PersonDetailPresenter: InteractorToPresenterPersonDetailProtocol {
    // MARK: - Adding Data To Store In ViewModel
    func didReceiveData(with movies: [MovieServerModel], and person: Person) {
        section.singlePerson = CellViewModel(person: person)
        
        // Sorting by chars number in name
        movies.sorted(by: { lhs, rhs in
            //guard let lhsName = lhs.name, let rhsName = rhs.name else { return false }
            return lhs.name.count >= rhs.name.count
        }).forEach { section.movieItems.append(CellViewModel(movie: $0)) }
        
        person.facts.forEach { section.categoryItems.append(CellViewModel(category: $0.value, isFact: true))}
        
        view.reloadData(with: section)
    }
}
