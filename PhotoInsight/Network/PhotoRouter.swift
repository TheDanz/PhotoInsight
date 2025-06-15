import Foundation

enum PhotoRouter: URLRequestConvertible {
    case fetch(page: Int, perPage: Int)
    
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
        
        let urlString = UnsplashAPI.baseURL + endpoint
        
        switch self {
        case let .fetch(page, perPage):

            guard var urlComponents = URLComponents(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: UnsplashAPI.publicKey),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
            
            guard let url = urlComponents.url else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            return request
        }
    }
}
