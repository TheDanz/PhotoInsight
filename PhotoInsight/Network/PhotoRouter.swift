import Foundation

enum PhotoRouter: URLRequestConvertible {
    case fetch
    
    private static var publicKey = "tkTejaS4yQN-AcASG6Pa1UmeOPIWerDI_FgNgxihMWk"
    
    var endpoint: String {
        switch self {
        case .fetch:
            return "/photos/?client_id=\(PhotoRouter.publicKey)"
        }
    }
    
    var method: String {
        switch self {
        case .fetch:
            return "GET"
        }
    }
    
    func makeURLRequest() throws -> URLRequest {
        
        guard let url = URL(string: UnsplashAPI.baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return request
    }
}
