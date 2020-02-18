//
//  Photos.swift
//  Flickrrr
//
//  Created by Kedar Sukerkar on 30/07/18.
//  Copyright © 2018 Kedar Sukerkar. All rights reserved.
//

import UIKit



// MARK: - FlickrJSONResponse
struct FlickrJSONResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
