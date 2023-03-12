//
//  ImageDownLoad.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/02/17.
//

import UIKit

enum ImageDownloadError: Error {
    case badURL
    case failDownload
    case cancelled
}

final class ImageDownLoadManager {
    var workItem: BlockOperation!
    var task: URLSessionDataTask!
    var observation: NSKeyValueObservation!
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func reset() {
        guard task != nil, observation != nil else { return }
        task = nil
        observation.invalidate()
        observation = nil
    }
    
    func makeWork(
        progressHandler: @escaping(Progress) -> Void,
        completion: @escaping(Result<UIImage?, ImageDownloadError>) -> Void) -> BlockOperation {
        workItem = BlockOperation { [weak self] in
            let task = self?.makeTask(progressHandler: progressHandler, completion: completion)
            task?.resume()
            
        }
        return workItem
    }
    
    @discardableResult
    func makeTask(
        progressHandler: @escaping(Progress) -> Void,
        completion: @escaping(Result<UIImage?, ImageDownloadError>) -> Void
    ) -> URLSessionDataTask? {
        
        guard workItem.isCancelled == false else {
            completion(.failure(.cancelled))
            return nil }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
      
            if let error = error {
                guard error.localizedDescription == "cancelled" else {
                    completion(.failure(.failDownload))
                    return
                }
                completion(.failure(.cancelled))
            }
            
            guard self.workItem.isCancelled == false else {
                completion(.failure(.cancelled))
                return
            }
            
            if let data,
               let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(.failDownload))
            }
        }
        
        progressHandler(task.progress)
        
        return task
    }
}
