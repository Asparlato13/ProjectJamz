//
//  SearchResultsResponse.swift
//  JamzApp
//
//  Created by Adrianna Parlato on 10/11/22.
//

import Foundation



struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
//    let profiles: SearchProfilesResponse
//    let users: SearchUserResponse
}


struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
//struct SearchProfilesResponse: Codable {
//    let items: [UserProfile]
//}
//struct SearchUserResponse: Codable {
//    let items: User
//}
