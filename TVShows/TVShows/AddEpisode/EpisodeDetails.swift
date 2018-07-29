import Foundation

struct EpisodeDetails: Codable {
    let showId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    let type: String
    let id: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case title
        case description
        case episodeNumber
        case season
        case type
        case id = "_id"
        case imageUrl
    }
}

struct Media: Codable {
    let path: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id =  "_id"
    }
}
