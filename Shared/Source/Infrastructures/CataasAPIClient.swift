//
//  CataasAPIClient.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation
import Combine

final class CataasAPIClient {
    
    private let baseURL: URL = .init(string: "https://cataas.com")!
    private let endPoint: String = "cat"
    private let usingJSONQuery: URLQueryItem = .init(name: "json", value: "true")
    
    private let decoder = JSONDecoder()
    
}

extension CataasAPIClient {
    
    func makeURLRequest(percentEncodedText: String) -> URLRequest {
        
        var url = baseURL
        url.appendPathComponent(endPoint)
        url.appendPathComponent("says")
        url.appendPathComponent(percentEncodedText)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [usingJSONQuery]
        let resolvedURL = components.url!
        
        let request = URLRequest(url: resolvedURL)
        return request
        
    }
    
}

extension CataasAPIClient {
    
    private func downloadImage(from response: CataasJSONResponse) -> AnyPublisher<CatImage, GeneralError> {
        
        return URLSession.shared.dataTaskPublisher(for: baseURL.appendingPathComponent(response.path))
            .map({ .init(id: response.id, image: ImageData(data: $0.data) ?? ImageData()) })
            .mapError(mapError(_:))
            .eraseToAnyPublisher()
        
    }
    
    private func mapError(_ error: Error) -> GeneralError {
        
        switch error {
        case let urlError as URLError:
            return .urlError(urlError)
            
        case let decodingError as DecodingError:
            return .decodingError(decodingError)
            
        case let unknownError:
            return .unknownError(unknownError)
        }
        
    }
    
}

extension CataasAPIClient {
    
    private func send(line: String) -> AnyPublisher<CatImage, GeneralError> {
        
        guard let percentEncodedLine = line.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return Fail(error: .unknownError(TaskError.unableToMakePathComponent(line: line))).eraseToAnyPublisher()
        }
        
        let request = makeURLRequest(percentEncodedText: percentEncodedLine)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CataasJSONResponse.self, decoder: decoder)
            .mapError(mapError(_:))
            .flatMap(downloadImage(from:))
            .eraseToAnyPublisher()
        
    }
    
}

extension CataasAPIClient {
    
    enum TaskError: Swift.Error {
        case unableToMakePathComponent(line: String)
    }
    
}

extension CataasAPIClient.TaskError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .unableToMakePathComponent(line: let line):
            return "Unable to make path component with line: \(line)"
        }
    }
    
}
