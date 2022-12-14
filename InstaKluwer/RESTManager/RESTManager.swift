//
//  RESTManager.swift
//  InstaKluwer
//
//  Created by Daniel on 07.11.2022.
//

import UIKit

struct APIResponse: Codable {
    let data: [Photo]
}

enum RESTError: Error {
  case responseError(URLResponse?)
  case dataError
}

class RESTManager {
    static let shared = RESTManager()
    static let errorMessage = "Ooops"
    let session: URLSession
    
    init() {
      let config = URLSessionConfiguration.default
      session = URLSession(configuration: config)
    }
    
    func makeRequest(url: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        let request = URLRequest(url: url)
          let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
              completion(nil, error)
              return
            }
              guard let data = data else {
                completion(nil, RESTError.dataError)
                return
              }
              completion(data, nil)
          }
          task.resume()
    }
    
    func getAlbumsData(completion: @escaping ([Photo]?, Error?) -> (Void)) {
        makeRequest(url: URL(string: Constants.albumsURL)!) { data, error in
            if let data = data {
                do {
                    let group = DispatchGroup()
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    for album in response.data {
                        group.enter()
                        if let url = URL(string: Constants.baseURL + album.id + Constants.photosURLComponent) {
                            self.getAlbumPhotos(url: url) { photo, error in
                                album.children = photo ?? []
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: DispatchQueue.main) {
                        completion(response.data, nil)
                    }
                } catch let error {
                    print("ERROR \(error)")
                    completion(nil, error)
                }
            }
            completion(nil, error)
        }
    }
    
    func getAlbumPhotos(url: URL, completion: @escaping ([Photo]?, Error?) -> (Void)) {
        makeRequest(url: url) { data, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(response.data, nil)
                } catch let error {
                    print("ERROR \(error)")
                    completion(nil, error)
                }
            }
        }
    }
}
