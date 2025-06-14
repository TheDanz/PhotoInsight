struct Photo: Codable {
    let description: String?
    let altDescription: String
    let color: String
    let likes: Int
    let urls: PhotoURL
    let user: User
    
    private enum CodingKeys: String, CodingKey {
        case description
        case altDescription = "alt_description"
        case color
        case likes
        case urls
        case user
    }
    
    struct PhotoURL: Codable {
        let thumb: String
        let regular: String
    }

    struct User: Codable {
        let username: String
    }
}
