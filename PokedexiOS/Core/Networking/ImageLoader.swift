//
//  ImageLoader.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import UIKit

protocol ImageLoaderProtocol {
    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable?
    func cachedImage(for url: URL) -> UIImage?
}

protocol Cancellable {
    func cancel()
}

final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
        
        // Optional: tune cache limit (safe defaults)
        cache.countLimit = 500
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> (any Cancellable)? {
        // Return cached immediately
        if let cached = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cached)
            }
            return nil
        }
        
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            let image: UIImage?
            if let data, let img = UIImage(data: data) {
                image = img
                // Use cost based on bytes
                self.cache.setObject(img, forKey: url as NSURL, cost: data.count)
            } else {
                image = nil
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
        return URLSessionTaskToken(task: task)
    }
}

private final class URLSessionTaskToken: Cancellable {
    private weak var task: URLSessionDataTask?
    
    init(task: URLSessionDataTask? = nil) {
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
    }
}
