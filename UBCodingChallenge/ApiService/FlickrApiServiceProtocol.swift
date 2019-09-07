//
//  FlickrApiServiceProtocol.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 FlickrApiServiceProtocol defines the methods that can be use on our data provider (here the ApiService)
 */
protocol FlickrApiServiceProtocol: class {
    func searchPhotos(query: String, page: Int, result: @escaping (Result<FlickrSearchResponse, FlickrApiServiceError>) -> Void)
}
