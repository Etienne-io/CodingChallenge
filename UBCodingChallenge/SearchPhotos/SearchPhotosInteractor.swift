//
//  SearchPhotosInteractor.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 SearchPhotosInteractor is responsible of fetching data from the ApiService.
 If we had a database, the interactor could decide to return data from database if possible and call the api if no data are available
 */
class SearchPhotosInteractor: SearchPhotosInteractorInputProtocol {
    weak var presenter: SearchPhotosInteractorOutputProtocol?
    let apiService: FlickrApiService
    
    init(apiService: FlickrApiService) {
        self.apiService = apiService
    }
    
    func retrievePhotos(query: String, page: Int) {
        presenter?.didStartNetworkRequest()
        apiService.searchPhotos(query: query, page: page) { [weak self] (result: Result<FlickrSearchResponse, FlickrApiServiceError>) in
            switch result {
            case .success(let searchResponse):
                self?.presenter?.didStopNetworkRequest()
                self?.presenter?.didRetrievePhotos(searchResponse.photos)
                
            case .failure(let error):
                self?.presenter?.didStopNetworkRequest()
                self?.presenter?.didFailed(error: error)
            }
        }
    }
}
