//
//  ImageRepository.swift
//  RecipeBook
//
//  Created by Леонид Шайхутдинов on 18.11.2025.
//

import UIKit

protocol IImageRepository {
    func getImage(url: String) -> UIImage?
    func saveImage(url: String)
}

final class ImageRepository: IImageRepository {
    static let shared = ImageRepository()
    private init() {}

    private let fileManager = FileManager.default
    private let imageDownloader: IImageDownloader = ImageDownloadService.shared
    
    private var documentsDirectory: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private func fileName(from urlString: String) -> String {
        return urlString
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "/", with: "_")
    }
    
    private func filePath(for urlString: String) -> URL? {
        guard let documentsDirectory else { return nil }
        return documentsDirectory.appendingPathComponent(fileName(from: urlString))
    }

    func getImage(url: String) -> UIImage? {
        guard let fileURL = filePath(for: url) else { return nil }
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: fileURL.path)
    }

    func saveImage(url: String) {
        guard let urlObj = URL(string: url) else { return }

        imageDownloader.downloadImage(from: urlObj) { [weak self] result in
            switch result {
            case .success(let image):
                self?.saveImageToFile(url: url, image: image)
            case .failure(let error):
                print("Image download failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveImageToFile(url: String, image: UIImage) {
        guard let fileURL = filePath(for: url) else { return }
        guard let data = image.pngData() else { return }

        do {
            try data.write(to: fileURL)
            print("Image saved to: \(fileURL.path)")
        } catch {
            print("Error writing file: \(error.localizedDescription)")
        }
    }
}
