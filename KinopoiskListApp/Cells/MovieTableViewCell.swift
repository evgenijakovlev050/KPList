//
//  MovieTableViewCell.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 04.04.2024.
//

import UIKit
import Kingfisher
import SkeletonView

class MovieTableViewCell: UITableViewCell, CellModelRepresanteble {
    
    // MARK: - Properties
    var viewModel: CellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 5
        return imageView
    }()
    
    private let rUNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.isSkeletonable = true
        label.skeletonCornerRadius = 3
        label.skeletonTextLineHeight = .fixed(15)
        label.skeletonTextNumberOfLines = 3
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let countryAndGenreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = .lightGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let watchOnlineButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "play.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 12, weight: .bold, scale: .small
                )
            ),
            for: .normal
        )
        button.setTitle("Смотреть", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.tintColor = .orange
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        button.contentHorizontalAlignment = .leading
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
        button.isHidden = true
        return button
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.fill")
        imageView.contentMode = .top
        imageView.tintColor = .orange
        imageView.sizeToFit()
        imageView.isHidden = true
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.isHidden = true
        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        movieImageView.hideSkeleton()
    }
    
    // MARK: - Setup Layout
    private func commonInit() {
        let innerStackView = UIStackView(
            arrangedSubviews: [
                rUNameLabel, periodLabel, 
                countryAndGenreLabel,
                watchOnlineButton, emptyView
            ]
        )
        innerStackView.axis = .vertical
        innerStackView.spacing = 2
        innerStackView.isSkeletonable = true
        
        let mainStackView = UIStackView(
            arrangedSubviews: [movieImageView, innerStackView, favoriteImageView]
        )
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        mainStackView.isSkeletonable = true
        
        contentView.addSubview(mainStackView)
        
        // Setup Constraints
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.width.equalTo(55)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
    
    }
    
    private func updateView() {
        guard let viewModel = viewModel as? CellViewModel else { return }
        let processor = DownsamplingImageProcessor(size: CGSize(width: 55, height: mainStackView.bounds.height))
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(
            with: URL(string: viewModel.imageUrl),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        guard let film = viewModel.film else { return }
        rUNameLabel.text = film.name
        periodLabel.text = film.year
        countryAndGenreLabel.text = film.genres
        watchOnlineButton.isHidden = !film.watchability
        emptyView.isHidden = !watchOnlineButton.isHidden
        favoriteImageView.isHidden = !film.isFavorite
    }
}
