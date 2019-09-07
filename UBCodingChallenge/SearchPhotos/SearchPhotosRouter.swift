//
//  SearchPhotosRouter.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 07/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation
import UIKit

class SearchPhotosRouter: SearchPhotosRouterProtocol {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static func createSearchPhotosModule(apiService: FlickrApiService) -> UIViewController {
        let searchPhotosViewController = storyboard.instantiateViewController(withIdentifier: "searchPhotoViewController") as! SearchPhotosViewController
        let presenter: SearchPhotosPresenterProtocol & SearchPhotosInteractorOutputProtocol = SearchPhotosPresenter()
        let interactor: SearchPhotosInteractorInputProtocol = SearchPhotosInteractor(apiService: apiService)
        searchPhotosViewController.presenter = presenter
        presenter.view = searchPhotosViewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        return searchPhotosViewController
    }
}
