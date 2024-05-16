//
//  ViewController.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 13.03.2024.
//

import UIKit
import SkeletonView

final class HomeInfoViewController: UIViewController {
    // MARK: - Properties
    var presenter: HomeInfoViewOutputProtocol!
    
    // UICV Properties
    private var collectionView: UICollectionView!
    private var sectionViewModel: SectionViewModelProtocol = SectionViewModel()
    private let sectionHeaderView = SectionHeaderView()
    
    // SearchBar Properties
    private var searchController: UISearchController!
    private var searchVC: SearchViewController!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
        addSkeletonAnimation()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesSection()
    }
}

// MARK: - Extensions - Private Methodds
extension HomeInfoViewController {
    // MARK: - Adding Favorites If Needed
    private func updateFavoritesSection() {
        if presenter.wasAnyStatusChanged {
            presenter.updateFavoriteMovies()
        }
    }
    
    // MARK: - Setup the Collection View
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(KPListCollectionViewCell.self)
        collectionView.register(KPItemCell.self)
        collectionView.register(CategoryCell.self)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseId
        )
        
        view.addSubview(collectionView)
    }
    
    // MARK: - Setup the Search Controller and Scope Bar
    private func setupSearchController() {
        searchVC = SearchViewController()
        
        searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = searchVC
        
        // Show resultsVC after tapping search bar
        searchController.showsSearchResultsController = true
        
        searchController.searchBar.autocapitalizationType = .none
        
        // Adding placeholder and scope
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Фильмы, персоны, сериалы", comment: "")
        searchController.searchBar.scopeButtonTitles = [
            "Все результаты",
            "Онлайн-кинотеатр"
        ]
        searchController.searchBar.returnKeyType = .done
        
        /** Place the search bar in the navigation bar and make it visible even while scroling */
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        // Make the search bar hiding during presentation
        searchController.hidesNavigationBarDuringPresentation = true

        // Monitor when the search controller is presented and dismissed.
        searchController.delegate = self
        
        // Monitor when the search button is tapped, and start/end editing.
        searchController.searchBar.delegate = searchVC
        
        /** Specify that this view controller determines how the search controller is presented.
            The search controller should be presented modally and match the physical size of this view controller.
        */
        definesPresentationContext = true
        
        //searchController.searchBar.placeholder = "Фильмы, персоны, сериалы"
        //searchController.obscuresBackgroundDuringPresentation = false
        //searchController.definesPresentationContext = true
    }
    
    // MARK: - Setup the Navigation Bar
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Setup the SkeletonView
    private func addSkeletonAnimation() {
        SkeletonAppearance.default.skeletonCornerRadius = 4
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton()
    }
}

// MARK: - Extensions - Setup UICVCompositionalLayout
extension HomeInfoViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return CellFactory.createSection(for: .collections)
            case 1:
                return CellFactory.createSection(for: .categories)
            case 2:
                return CellFactory.createSection(for: .collections)
            default:
                return CellFactory.createSection(for: .movies)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
}

// MARK: - Extensions - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeInfoViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        sectionViewModel.numberOfSections
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return KPListCollectionViewCell.reuseId
        case 1:
            return CategoryCell.reuseId
        default:
            return KPItemCell.reuseId
        }
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        supplementaryViewIdentifierOfKind: String,
        at indexPath: IndexPath
    ) -> ReusableCellIdentifier? {
        return SectionHeaderView.reuseId
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionViewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionViewModel.numberOfKPListItems
        case 1:
            return sectionViewModel.numberOfCategoryItems
        case 2:
            return sectionViewModel.numberOfPersonItems
        default:
            return sectionViewModel.numberOfMovieItems
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cellViewModel = sectionViewModel.kpListItems[indexPath.item]
            let cell = collectionView.dequeueCell(cellType: KPListCollectionViewCell.self, for: indexPath)
            cell.hideSkeleton()
            cell.viewModel = cellViewModel
            return cell
        case 1:
            let cellViewModel = sectionViewModel.categoryItems[indexPath.item]
            let cell = collectionView.dequeueCell(cellType: CategoryCell.self, for: indexPath)
            cell.hideSkeleton()
            cell.viewModel = cellViewModel
            return cell
        default:
            let cellViewModel = (indexPath.section == 2) ?
                sectionViewModel.personItems[indexPath.item] :
                sectionViewModel.movieItems[indexPath.item]
            
            let cell = collectionView.dequeueCell(cellType: KPItemCell.self, for: indexPath)
            cell.hideSkeleton()
            cell.viewModel = cellViewModel
            return cell
        }
    }
        
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseId,
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        switch indexPath.section {
        case 0:
            sectionHeaderView.title.text = "Советуем посмотреть"
        case 1:
            sectionHeaderView.title.text = "Категории"
        case 2:
            sectionHeaderView.title.text = "Родились сегодня"
        default:
            sectionHeaderView.title.text = "Буду смотреть"
        }
        
        return sectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath)
    }
}

// MARK: - Extensions - HomeInfoViewInputProtocol
extension HomeInfoViewController: HomeInfoViewInputProtocol {
    func reloadData(section: SectionViewModel) {
        sectionViewModel = section
        collectionView.hideSkeleton()
    }
    
    func reloadDataAfterFavoritesUpdate(section: SectionViewModel) {
        sectionViewModel = section
        if collectionView.numberOfSections == 3 {
            if !sectionViewModel.movieItems.isEmpty {
                collectionView.insertSections(.init(integer: 3))
            }
        } else {
            if sectionViewModel.movieItems.isEmpty {
                collectionView.deleteSections(.init(integer: 3))
            } else {
                collectionView.reloadSections(.init(integer: 3))
            }
        }
    }
}

// MARK: - Extensions - UpdateFavoriteStatusDelegate
extension HomeInfoViewController: UpdateFavoriteStatusDelegate {
    func modalClosed() {
        guard let indexPath = collectionView
            .indexPathsForSelectedItems else { return }
        
        if presenter.wasAnyStatusChanged  {
            indexPath
                .forEach { sectionViewModel.movieItems.remove(at: $0.item) }
            if sectionViewModel.numberOfMovieItems == 0 {
                collectionView.deleteSections(.init(integer: 3))
            } else {
                collectionView.deleteItems(at: indexPath)
            }
        }
    }
}

// MARK: - Extensions - UISearchControllerDelegate
extension HomeInfoViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        print("searchResultsVC will be presented")
        SearchConfigurator.configure(withView: searchVC)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        updateFavoritesSection()
    }
}
