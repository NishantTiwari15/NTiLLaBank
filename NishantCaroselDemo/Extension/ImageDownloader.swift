//
//  ImageDownloader.swift
//  NishantCaroselDemo
//
//  Created by neosoft on 30/01/23.
//

import UIKit

final class ImageDownloader {

    static let shared = ImageDownloader()

    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]

    // MARK: Private init
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }
    
    func downloadImage(with imageUrlString: String?,
                       completionHandler: @escaping (UIImage?, Bool) -> Void,
                       placeholderImage: UIImage?) {

        // Case A.a
        guard let imageUrlString = imageUrlString else {
            completionHandler(placeholderImage, true)
            return
        }

        // Case B.a
        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completionHandler(image, true)
        } else {
            // Case A.b
            guard let url = URL(string: imageUrlString) else {
                completionHandler(placeholderImage, true)
                return
            }

            // Case C.a
            if let _ = getDataTaskFrom(urlString: imageUrlString) {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                guard let data = data else {
                    return
                }

                // Case A.c
                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeholderImage, true)
                    }
                    return
                }

                let image = UIImage(data: data)
                
                self.cachedImages[imageUrlString] = image
                self.imagesDownloadTasks.removeValue(forKey: imageUrlString)

                DispatchQueue.main.async {
                    // Case D
                    completionHandler(image, false)
                }
            }
            imagesDownloadTasks[imageUrlString] = task
            task.resume()
        }
    }


    // MARK: Helper methods
    private func getCachedImageFrom(urlString: String) -> UIImage? {
        return cachedImages[urlString]
    }

    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {
        return imagesDownloadTasks[urlString]
    }

}
