//
//  FlickrApiService.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 FlickrApiService is responsible of calling the remote Flickr api and convert the data into our defined models
 */
class FlickrApiService {
    private let urlSession = URLSession.shared
    
    private let jsonDecoder = JSONDecoder()
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, FlickrApiServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}

extension FlickrApiService: FlickrApiServiceProtocol {
    // URL parameters should be externalize in order to provide more options to the user. As this options are not available for this application, this is relatively acceptable.
    private func getSearchURL(query: String, page: Int) -> URL {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=\(escapedQuery)&page=\(page)")!
    }
    
    public func searchPhotos(query: String, page: Int, result: @escaping (Result<FlickrSearchResponse, FlickrApiServiceError>) -> Void) {
        fetchResources(url: getSearchURL(query: query, page: page), completion: result)
    }
}
