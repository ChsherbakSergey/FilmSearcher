//
//  MovieTableViewCell.swift
//  FilmSearcher
//
//  Created by Sergey on 12/2/20.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //Views that will be displayed on this cell
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    //Constants and variables
    static let identifier = "MovieTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setInitialUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Frame of the posterImageView
        posterImageView.frame = CGRect(x: 15,
                                       y: 15,
                                       width: contentView.frame.size.width - contentView.frame.size.width / 1.5,
                                       height: contentView.frame.size.height - 30)
        posterImageView.layer.cornerRadius = 10
        //Frame of the titleLabel
        titleLabel.frame = CGRect(x: posterImageView.frame.origin.x + contentView.frame.size.width - contentView.frame.size.width / 1.5 + 20,
                                  y: 25,
                                  width: contentView.frame.size.width - (posterImageView.frame.origin.x + contentView.frame.size.width - contentView.frame.size.width / 1.5 + 20) - 10,
                                  height: 80)
        //Frame of the year label
        yearLabel.frame = CGRect(x: posterImageView.frame.origin.x + contentView.frame.size.width - contentView.frame.size.width / 1.5 + 20,
                                  y: 100,
                                  width: contentView.frame.size.width - (posterImageView.frame.origin.x + contentView.frame.size.width - contentView.frame.size.width / 1.5 + 20) - 10,
                                  height: 60)
    }
    
    ///Sets initial UI
    private func setInitialUI() {
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(yearLabel)
    }
    
    public func configureCell(with model: Movie) {
        titleLabel.text = model.Title
        yearLabel.text = model.Year
        let url = model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!) {
            posterImageView.image = UIImage(data: data)
        }
    }
    
}
