//
//  LocationsData.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 21/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import Foundation


struct LocationsData: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    var createdAt, firstName, lastName: String?
    var latitude, longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectID, uniqueKey, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
}

extension StudentInformation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
