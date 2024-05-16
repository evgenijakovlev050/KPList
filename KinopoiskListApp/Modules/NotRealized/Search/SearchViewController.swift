//
//  SearchViewController.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 29.04.2024.
//

import UIKit

final class SearchViewController: UITableViewController {
    // MARK: - Properties
    private var sectionViewModel: SectionViewModelProtocol = SectionViewModel()
    var presenter: PresenterToViewSearchProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieTableViewCell.self)
        tableView.rowHeight = 100
    }
}

// MARK: - Extensions - ViewToPresenterSearchProtocol
extension SearchViewController: ViewToPresenterSearchProtocol {
    func reloadData(with section: SectionViewModel) {
        sectionViewModel = section
        tableView.reloadData()
    }
}

// MARK: - Extensions - UITableViewDelegate, UITableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionViewModel.numberOfMovieItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseId,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        cell.viewModel = sectionViewModel.movieItems[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapCell(at: indexPath.row)
    }
}

// MARK: - Extensions - UISearchBarDelegate, UISearchResultsUpdating
extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(
        _ searchBar: UISearchBar,
        selectedScopeButtonIndexDidChange selectedScope: Int
    ) {
        print("scope selection started")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("search started")
        if let title = searchController.searchBar.text, !title.isEmpty {
            presenter.searchStarted(with: title)
        } else {
            sectionViewModel.movieItems.removeAll()
            tableView.reloadData()
        }
    }
}

// MARK: - Extensions - UpdateFavoriteStatusDelegate
extension SearchViewController: UpdateFavoriteStatusDelegate {
    func modalClosed() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if presenter.wasAnyStatusChanged {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
