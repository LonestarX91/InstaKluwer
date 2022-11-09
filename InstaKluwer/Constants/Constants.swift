//
//  Constants.swift
//  InstaKluwer
//
//  Created by Daniel on 07.11.2022.
//

import UIKit

class Constants: NSObject {
    static let baseURL = "https://graph.instagram.com/"
    static let accessToken = access_token_here
    static let albumsURL = "\(baseURL)me/media?fields=media_url,timestamp,caption&access_token=\(Constants.accessToken)"
    static let photosURLComponent = "/children?fields=id,media_url,timestamp&access_token=\(Constants.accessToken)"
}
