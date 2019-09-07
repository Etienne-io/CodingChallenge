//
//  Entities.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 06/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation

/**
 Struct that represent the entire response of the flickr search api.
 @Discussion All attributes are not useful for this application but can be if we want to go further.
 Encodable is not required for this use case so we won't implement it
 */
public struct FlickrSearchResponse: Decodable {
    let photos:FlickrPhotosResponse
    let stat:String
}

/**
 Struct that represent the list of the photos for a giver search request.
 @Discussion We won't use the total attribute becaus page and pages will be enough. In order to respect the camelcase syntax, Decodable has been customize.
 Encodable is not required for this use case so we won't implement it
 */
public struct FlickrPhotosResponse {
    let page:Int
    let pages:Int
    let perPage:Int
    let total:String
    let photos:[FlickrPhoto]
}

extension FlickrPhotosResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photos = "photo"
    }
}

/**
 Struct that represent a single photo's information.
 @Discussion All attributes are not useful for this application but can be if we want to go further. In order to respect the camelcase syntax, Decodable has been customize. Encodable is not required for this use case so we won't implement it. Int that represents boolean have been left as Int for the sake of simplicity.
 */
public struct FlickrPhoto {
    let id:String
    let owner:String
    let secret:String
    let server:String
    let farm:Int
    let title:String
    let isPublic:Int
    let isFriend:Int
    let isFamily:Int
    
    func getImageUrlString() -> String {
        return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

extension FlickrPhoto: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}
