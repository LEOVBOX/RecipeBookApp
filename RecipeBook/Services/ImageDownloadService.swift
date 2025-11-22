//
//  ImageDownloadService.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 18.11.2025.
//

import Foundation
import UIKit

protocol IImageDownloader {
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelDownload()
}

final class ImageDownloadService: IImageDownloader {
    static let shared = ImageDownloadService()
    
    private var task: URLSessionDataTask?
    private let imageCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 300
        return cache
    }()
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Пытаемся взять из кэша
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
            return
        }
        
        // Загружаем из сети
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(ImageDownloadError.invalidData))
                return
            }
            
            // Сохраняем в кэш
            self?.imageCache.setObject(image, forKey: url as NSURL)
            completion(.success(image))
        }
        
        task?.resume()
    }
    
    func cancelDownload() {
        task?.cancel()
        task = nil
    }
}


enum ImageDownloadError: Error {
    case invalidData
    case downloadFailed
}
