//
//  LoadableImageView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 18.11.2025.
//

import UIKit

final class LoadableImageView: UIView, ILoadableImageView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var imageRepository: IImageRepository?
    private var currentURL: String?
    
    init(imageRepository: IImageRepository = ImageRepository.shared) {
        self.imageRepository = imageRepository
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        addSubview(imageView)
        addSubview(placeholderImageView)
        addSubview(activityIndicator)
        
        placeholderImageView.isHidden = true
        
        layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Placeholder
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            placeholderImageView.heightAnchor.constraint(equalTo: placeholderImageView.widthAnchor),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    func setImage(with url: String?, placeholder: UIImage? = nil) {
        imageView.image = nil
        currentURL = url
        
        if let placeholder = placeholder {
            placeholderImageView.image = placeholder
            placeholderImageView.isHidden = false
        } else {
            placeholderImageView.isHidden = true
        }
        
        guard let url else {
            placeholderImageView.isHidden = false
            return
        }
        
        imageRepository = ImageRepository.shared
        let image = imageRepository?.getImage(url: url)
        if let image {
            imageView.image = image
            return
        }
    }
    
    func clearImage() {
        imageView.image = nil
        placeholderImageView.isHidden = true
        currentURL = nil
    }
    
}


extension LoadableImageView {
    // Удобные методы для настройки
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        imageView.layer.cornerRadius = radius
    }
    
    func setContentMode(_ contentMode: UIView.ContentMode) {
        imageView.contentMode = contentMode
    }
}

