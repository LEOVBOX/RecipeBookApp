//
//  DownloadableImageView.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 18.11.2025.
//

import UIKit

protocol ILoadableImageView: UIView, AnyObject {
    func setImage(with url: String?, placeholder: UIImage?)
    func clearImage()
}

final class DownloadableImageView: UIView {
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
    
    private var imageDownloader: IImageDownloader?
    private var currentURL: URL?
    
    init(imageDownloader: IImageDownloader = ImageDownloadService.shared) {
        self.imageDownloader = imageDownloader
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
    
    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        cancelDownload()
        
        imageView.image = nil
        currentURL = url
        
        if let placeholder = placeholder {
            placeholderImageView.image = placeholder
            placeholderImageView.isHidden = false
        } else {
            placeholderImageView.isHidden = true
        }
        
        guard let url = url else {
            showPlaceholder()
            return
        }
        
        startLoading()
        
        imageDownloader = ImageDownloadService()
        imageDownloader?.downloadImage(from: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleDownloadResult(result)
            }
        }
    }
    
    func cancelDownload() {
        imageDownloader?.cancelDownload()
        imageDownloader = nil
        stopLoading()
    }
    
    func clearImage() {
        cancelDownload()
        imageView.image = nil
        placeholderImageView.isHidden = true
        currentURL = nil
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        placeholderImageView.isHidden = true
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func showPlaceholder() {
        stopLoading()
        placeholderImageView.isHidden = false
    }
    
    private func handleDownloadResult(_ result: Result<UIImage, Error>) {
        stopLoading()
        
        switch result {
        case .success(let image):
            imageView.image = image
            placeholderImageView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.imageView.alpha = 1.0
            }
            
        case .failure(let error):
            print("Failed to download image: \(error)")
            showPlaceholder()
        }
        
        imageDownloader = nil
    }
}

extension DownloadableImageView {
    // Удобные методы для настройки
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        imageView.layer.cornerRadius = radius
    }
    
    func setContentMode(_ contentMode: UIView.ContentMode) {
        imageView.contentMode = contentMode
    }
}
