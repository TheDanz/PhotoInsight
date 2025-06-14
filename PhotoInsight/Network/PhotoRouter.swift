import Foundation

enum PhotoRouter: URLRequestConvertible {
    case fetch
    
    var endpoint: String {
        switch self {
        case .fetch:
            return "/photos/?client_id=\(UnsplashAPI.publicKey)"
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
