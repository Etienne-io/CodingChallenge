//
//  SearchPresenter.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 SearchPhotosPresenter is responsible of the business logic.
 It takes input from the View and request data to the interactor.
 It calls view method to display information
 */
class SearchPhotosPresenter: SearchPhotosPresenterProtocol {
    var interactor: SearchPhotosInteractorInputProtocol?
    weak var view: SearchViewProtocol?
    
    private var page = 1
    private var totalPage = Int.max
    private var lastQuery = ""
    private var fetchInProgress = false
    
    func viewDidLoad() {
        view?.showEmptySearch()
    }
    
    func searchPhoto(for query: String) {
        page = 1
        totalPage = Int.max
        lastQuery = query
        if query.isEmpty {
            view?.showEmptySearch()
        }
        else {
            interactor?.retrievePhotos(query: lastQuery, page: page)
        }
    }
    
    func loadNextPhotos() {
        guard !fetchInProgress else {
            return
        }
        fetchInProgress = true
        page += 1
        interactor?.retrievePhotos(query: lastQuery, page: page)
    }
    
}

extension SearchPhotosPresenter: SearchPhotosInteractorOutputProtocol {
    func didStartNetworkRequest() {
        DispatchQueue.main.async {
            self.view?.showNetworkLoading()
        }
    }
    
    func didStopNetworkRequest() {
        DispatchQueue.main.async {
            self.view?.hideNetworkLoading()
        }
    }
    
    func didRetrievePhotos(_ photos: FlickrPhotosResponse) {
        fetchInProgress = false
        if (photos.pages == 0) {
            DispatchQueue.main.async {
                self.view?.showEmptyResult()
            }
        }
        else {
            page = photos.page
            DispatchQueue.main.async {
                print("show photo \(self.lastQuery)")
                self.view?.showPhotos(photos: photos.photos, totalPhotos: photos.pages)
            }
        }
    }
    
    func didFailed(error: Error) {
        DispatchQueue.main.async {
            self.view?.showError(error: error)
        }
    }
}
