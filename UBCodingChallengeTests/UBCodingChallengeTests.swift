//
//  UBCodingChallengeTests.swift
//  UBCodingChallengeTests
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import XCTest
@testable import UBCodingChallenge

class FlickApiServiceWithDataSpy: FlickrApiServiceProtocol {
    func searchPhotos(query: String, page: Int, result: @escaping (Result<FlickrSearchResponse, FlickrApiServiceError>) -> Void) {
        let photos = [
            FlickrPhoto(id: "1", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title", isPublic: 1, isFriend: 1, isFamily: 1),
            FlickrPhoto(id: "2", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title", isPublic: 1, isFriend: 1, isFamily: 1),
            FlickrPhoto(id: "3", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title", isPublic: 1, isFriend: 1, isFamily: 1),
            FlickrPhoto(id: "4", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title", isPublic: 1, isFriend: 1, isFamily: 1),
            FlickrPhoto(id: "5", owner: "owner", secret: "secret", server: "server", farm: 1, title: "title", isPublic: 1, isFriend: 1, isFamily: 1)
        ]
        let photosResponse = FlickrPhotosResponse(page: 1, pages: 1, perPage: 5, total: "5", photos: photos)
        let searchResponse = FlickrSearchResponse(photos: photosResponse, stat: "ok")
        result(.success(searchResponse))
    }
}

class FlickApiServiceWithoutDataSpy: FlickrApiServiceProtocol {
    func searchPhotos(query: String, page: Int, result: @escaping (Result<FlickrSearchResponse, FlickrApiServiceError>) -> Void) {
        let photos:[FlickrPhoto] = []
        let photosResponse = FlickrPhotosResponse(page: 0, pages: 0, perPage: 5, total: "0", photos: photos)
        let searchResponse = FlickrSearchResponse(photos: photosResponse, stat: "ok")
        result(.success(searchResponse))
    }
}

class FlickApiServiceWithErrorSpy: FlickrApiServiceProtocol {
    func searchPhotos(query: String, page: Int, result: @escaping (Result<FlickrSearchResponse, FlickrApiServiceError>) -> Void) {
        result(.failure(.apiError))
    }
}

class SearchPhotosViewControllerSpy: SearchViewProtocol {
    var presenter: SearchPhotosPresenterProtocol?
    private(set) var showEmptySearchHasBeenCalled = false
    private(set) var showPhotosHasBeenCalled = false
    private(set) var showEmptyResulthHasBeenCalled = false
    private(set) var showErrorHasBeenCalled = false
    private(set) var showNetworkLoadingHasBeenCalled = false
    private(set) var hideNetworkLoadingHasBeenCalled = false
    
    init(presenter: SearchPhotosPresenterProtocol) {
        self.presenter = presenter
    }
    
    func showEmptySearch() {
        showEmptySearchHasBeenCalled = true
    }
    
    func showPhotos(photos: [FlickrPhoto], totalPhotos: Int) {
        showPhotosHasBeenCalled = true
    }
    
    func showEmptyResult() {
        showEmptyResulthHasBeenCalled = true
    }
    
    func showError(error: Error) {
        showErrorHasBeenCalled = true
    }
    
    func showNetworkLoading() {
        showNetworkLoadingHasBeenCalled = true
    }
    
    func hideNetworkLoading() {
        hideNetworkLoadingHasBeenCalled = true
    }
    
    
}

class UBCodingChallengeTests: XCTestCase {
    
    var apiService: FlickrApiServiceProtocol!
    var viewController: SearchPhotosViewControllerSpy!
    var presenter: (SearchPhotosPresenterProtocol & SearchPhotosInteractorOutputProtocol)!
    var interactor: SearchPhotosInteractorInputProtocol!
    
    func testPresenterOnViewDidLoad() {
        givenAFlickrApiWithData()
        givenASearchPhotoInteractor(with: apiService)
        givenASearchPhotoPresenter()
        givenASearchPhotoView()
        whenTheSearchPhotosPresenterStart()
        thenTheEmptySearchIsDisplayed()
    }
    
    func testPresenterOnSearchPhotosWithData() {
        givenAFlickrApiWithData()
        givenASearchPhotoInteractor(with: apiService)
        givenASearchPhotoPresenter()
        givenASearchPhotoView()
        whenASearchIsAsked()
        thenTheLoadingIndicatorIsDisplayed()
        thenThePhotosAreDisplayed()
        thenTheLoadingIndicatorIsHidden()
    }
    
    func testPresenterOnSearchPhotosWithoutData() {
        givenAFlickrApiWithoutData()
        givenASearchPhotoInteractor(with: apiService)
        givenASearchPhotoPresenter()
        givenASearchPhotoView()
        whenASearchIsAsked()
        thenTheLoadingIndicatorIsDisplayed()
        thenTheEmptyResultIsDisplayed()
        thenTheLoadingIndicatorIsHidden()
    }
    
    func testPresenterOnSearchPhotosWithError() {
        givenAFlickrApiWithError()
        givenASearchPhotoInteractor(with: apiService)
        givenASearchPhotoPresenter()
        givenASearchPhotoView()
        whenASearchIsAsked()
        thenTheLoadingIndicatorIsDisplayed()
        thenTheErrorIsDisplayed()
        thenTheLoadingIndicatorIsHidden()
    }

    private func givenAFlickrApiWithData() {
        apiService = FlickApiServiceWithDataSpy()
    }
    
    private func givenAFlickrApiWithoutData() {
        apiService = FlickApiServiceWithoutDataSpy()
    }
    
    private func givenAFlickrApiWithError() {
        apiService = FlickApiServiceWithErrorSpy()
    }
    
    private func givenASearchPhotoInteractor(with apiService: FlickrApiServiceProtocol) {
        interactor = SearchPhotosInteractor(apiService: apiService)
    }
    
    private func givenASearchPhotoPresenter() {
        presenter = SearchPhotosPresenter()
        presenter.interactor = interactor
        interactor.presenter = presenter
    }
    
    private func givenASearchPhotoView() {
        viewController = SearchPhotosViewControllerSpy(presenter: presenter)
        presenter.view = viewController
    }
    
    private func whenTheSearchPhotosPresenterStart() {
        presenter.viewDidLoad()
    }
    
    private func thenTheEmptySearchIsDisplayed() {
        XCTAssertTrue(viewController.showEmptySearchHasBeenCalled)
    }

    private func whenASearchIsAsked() {
        presenter.searchPhoto(for: "test")
    }
    
    private func thenTheLoadingIndicatorIsDisplayed() {
        XCTAssertTrue(viewController.showNetworkLoadingHasBeenCalled)
    }
    
    private func thenTheLoadingIndicatorIsHidden() {
        XCTAssertTrue(viewController.hideNetworkLoadingHasBeenCalled)
    }
    
    private func thenThePhotosAreDisplayed() {
        XCTAssertTrue(viewController.showPhotosHasBeenCalled)
    }
    
    private func thenTheEmptyResultIsDisplayed() {
        XCTAssertTrue(viewController.showEmptyResulthHasBeenCalled)
    }
    
    private func thenTheErrorIsDisplayed() {
        XCTAssertTrue(viewController.showErrorHasBeenCalled)
    }
    
}
