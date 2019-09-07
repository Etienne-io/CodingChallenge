//
//  SearchProtocols.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation
import UIKit

/**
 SearchViewProtocol defines the methods that can be called by the presenter on the view
 */
protocol SearchViewProtocol: class {
    var presenter: SearchPhotosPresenterProtocol? { get set }
    
    func showEmptySearch()
    func showPhotos(photos: [FlickrPhoto], totalPhotos: Int)
    func showEmptyResult()
    func showError(error: Error)
    func showNetworkLoading()
    func hideNetworkLoading()
}

/**
 SearchPhotosPresenterProtocol defines the methods that can be called by the view on the presenter
 */
protocol SearchPhotosPresenterProtocol: class {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchPhotosInteractorInputProtocol? { get set }
    
    func viewDidLoad()
    func searchPhoto(for query: String)
    func loadNextPhotos()
}

/**
 SearchPhotosInteractorInputProtocol defines the methods that can be called by the presenter on the interactor
 */
protocol SearchPhotosInteractorInputProtocol: class {
    var presenter: SearchPhotosInteractorOutputProtocol? { get set }
    
    func retrievePhotos(query: String, page: Int)
}

/**
 SearchPhotosInteractorOutputProtocol defines the methods that can be called by the interactor on the presenter
 */
protocol SearchPhotosInteractorOutputProtocol: class {
    func didStartNetworkRequest()
    func didStopNetworkRequest()
    func didRetrievePhotos(_ photos: FlickrPhotosResponse)
    func didFailed(error: Error)
}

/**
 SearchPhotosRouterProtocol defines methods that can be called when the user navigate through the application
 As we only got on screen for the moment, it will be use only to create the view controller and instantiate all required object
 */
protocol SearchPhotosRouterProtocol: class {
    static func createSearchPhotosModule(apiService: FlickrApiService) -> UIViewController
}
