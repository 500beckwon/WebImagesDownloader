//
//  ImageDownLoad.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/02/17.
//

import Foundation

enum ImageDownloadError: Error {
    case badURL
    case failDownload
}

struct ImageDownLoad {
    
    func downloadImage(urlString: String, completion: @escaping(Result<Data, ImageDownloadError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let downloadTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.failDownload))
            }
            
            if let data = data,
               let response = response as? HTTPURLResponse,
               200..<300 ~= response.statusCode  {
                completion(.success(data))
            } else {
                completion(.failure(.failDownload))
            }
        }        
        
        downloadTask.resume()
    }
}
