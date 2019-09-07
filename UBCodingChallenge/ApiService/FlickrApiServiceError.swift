//
//  FlickrApiServiceError.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 FlickrApiServiceError is a simple enum to handle different error. More details should probably be added
 */
enum FlickrApiServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
