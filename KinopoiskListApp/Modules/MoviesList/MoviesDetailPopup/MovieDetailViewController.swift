//
//  MovieDetailViewController.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 22.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieDetailViewController: UITableViewController {
    
    // MARK: - Properties
    var viewModel: CellViewModelProtocol = CellViewModel() {
        didSet {
            updateView()
        }
    }
    weak var delegate: UpdateFavoriteStatusDelegate!
        
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let ruNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieImageView, infoStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ruNameLabel, periodLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = delegate {
            delegate.modalClosed()
        }
    }
}

// MARK: - Private Methodds
extension MovieDetailViewController {
    // MARK: - Setup Layout
    private func customizeView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.sectionHeaderTopPadding = 20
        tableView.sectionHeaderHeight = 90
        
        movieImageView.snp.makeConstraints { make in
            make.width.equalTo(55)
        }
    }
    
    private func updateView() {
        guard let viewModel = viewModel as? CellViewModel else { return }
        let imageURL  = URL(string: viewModel.imageUrl ?? "")
        let processor = DownsamplingImageProcessor(size: CGSize(width: 55, height: 80))
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(
            with: imageURL,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        { [weak self] result in
            switch result {
            case .success(_):
                self?.tableView.reloadData()
            case .failure(_):
                break
            }
        }
        
        if let movie = viewModel.movie {
            ruNameLabel.text = movie.name
            periodLabel.text = String(movie.year)
        } else if let film = viewModel.film {
            ruNameLabel.text = film.name
            periodLabel.text = film.year
        }
        
    }
}

// MARK: - Extensions - UITableViewDelegate, UITableViewDataSource
extension MovieDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        
        var content = cell.defaultContentConfiguration()
        content.imageProperties.tintColor = .black
        content.imageProperties.maximumSize = CGSize(width: 20, height: 20)
        content.textProperties.font = UIFont(name: "HelveticaNeue-Bold", size: 12)!
        switch indexPath.row {
        case 0:
            content.text = "Буду смотреть"
            if viewModel.favoriteStatus {
                content.image = UIImage(
                    systemName: "bookmark.fill",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
                )
                content.imageProperties.tintColor = .orange
            } else {
                content.image = UIImage(
                    systemName: "bookmark",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
                )
                content.imageProperties.tintColor = .black
            }
        default:
            content.text = "Просмотрен"
            if viewModel.watchedStatus {
                content.image = UIImage(
                    systemName: "eye.fill",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
                )
                content.imageProperties.tintColor = .orange
            } else {
                content.image = UIImage(
                    systemName: "eye",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
                )
                content.imageProperties.tintColor = .black
            }
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.setFavoriteStatus()
        default:
            viewModel.setWatchedStatus()
        }
        dismiss(animated: true)
    }
}
