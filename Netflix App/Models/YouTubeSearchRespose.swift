//
//  File.swift
//  Netflix App
//
//  Created by Cumulations on 11/06/23.
//

import Foundation


struct YouTubeSearchResponse : Codable {
    let items : [VideoElement]
}


struct VideoElement : Codable {
    let id : IDVideoElement
}

struct IDVideoElement : Codable {
    let kind : String
    let videoId : String
}
