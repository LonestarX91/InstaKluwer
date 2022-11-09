//
//  Photo.swift
//  InstaKluwer
//
//  Created by Daniel on 07.11.2022.
//

import UIKit

class Photo: Codable {
    let media_url: String
    let timestamp: String
    let id: String
    let caption: String?
    var children: [Photo]?
}

