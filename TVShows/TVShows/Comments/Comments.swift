import Foundation

struct AquiredComment: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}

struct PostedComment: Codable {
    let text: String
    let episodeId: String
    let userId: String
    let userEmail: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userId
        case userEmail
        case type
        case id = "_id"
    }
}

enum Constants {
    enum InsetDirection {
        case Upwards
        case Downwards
    }
}


