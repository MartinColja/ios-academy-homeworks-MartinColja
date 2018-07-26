import Foundation


struct ShowDetails: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
        
    }
}

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
    }
}

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
