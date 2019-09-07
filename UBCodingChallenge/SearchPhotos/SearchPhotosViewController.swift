//
//  SearchPhotosViewController.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import UIKit

/**
 SearchPhotosViewController is responsible of displaying the informations given by the presenter
 When the user interact with the view, the view call the presenter to know what to do
 */
class SearchPhotosViewController: UIViewController {
    var presenter: SearchPhotosPresenterProtocol?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelSearchView: UIView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var photosFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var informationsLabel: UILabel!
    
    private struct Identifiers {
        static let photoCell = "photoCell"
    }
    
    private let itemsPerRow: CGFloat = 3
    private let itemSpacing: CGFloat = 1
    private var itemSize: CGSize = CGSize.zero
    
    // DataSource attributes: I would like to discuss about this decision in the future
    private var totalPhotos = 0
    private var flickrPhotos: [FlickrPhoto] = [] {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnCancelSearchView(_:)))
        cancelSearchView.addGestureRecognizer(tap)
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.prefetchDataSource = self
        photosCollectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.photoCell)
        
        presenter?.viewDidLoad()
    }
    
    // Override viewDidLayoutSubviews to update collection cells size
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let spacing = (itemsPerRow - 1) * itemSpacing
        let size = floor((photosCollectionView.bounds.width - spacing) / itemsPerRow)
        itemSize = CGSize(width: size, height: size)
    }
    
    // Handle tap on the hidden view to close the search
    @objc private func tappedOnCancelSearchView(_ sender:UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
}

extension SearchPhotosViewController: SearchViewProtocol {
    func showEmptySearch() {
        photosCollectionView.isHidden = true
        informationsLabel.isHidden = false
        informationsLabel.text = "Search something!"
    }
    
    func showPhotos(photos: [FlickrPhoto], totalPhotos: Int) {
        informationsLabel.isHidden = true
        photosCollectionView.isHidden = false
        self.totalPhotos = totalPhotos
        flickrPhotos.append(contentsOf: photos)
    }
    
    func showEmptyResult() {
        photosCollectionView.isHidden = true
        informationsLabel.isHidden = false
        informationsLabel.text = "Nothing to see here, try again!"
    }
    
    func showError(error: Error) {
        photosCollectionView.isHidden = true
        informationsLabel.isHidden = false
        informationsLabel.text = "\(error)"
    }
    
    func showNetworkLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideNetworkLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        totalPhotos = 0
        flickrPhotos.removeAll()
        presenter?.searchPhoto(for: searchBar.text ?? "")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cancelSearchView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        cancelSearchView.isHidden = true
    }
}

extension SearchPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

extension SearchPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingCell(for: indexPath) || indexPath.row >= flickrPhotos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.photoCell, for: indexPath) as! PhotoCollectionViewCell
            cell.configure(flickrPhoto: nil)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.photoCell, for: indexPath) as! PhotoCollectionViewCell
            cell.configure(flickrPhoto: flickrPhotos[indexPath.row])
            return cell
        }
    }
}

extension SearchPhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.loadNextPhotos()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= flickrPhotos.count
    }
}
