//
//  WEService.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

class WEService {
    
    public static let shared = WEService()
    
    let apiUrl = "http://5b840ba5db24a100142dcd8c.mockapi.io/api"
    
    private init() {}
        
    func allEvents(result: @escaping (Result<[Event], WEServiceError>) -> Void) {
        let url = URL(string: "\(self.apiUrl)/events")!
        
        perform(url: url, completion: result)
    }
    
    func getEvent(id: String, result: @escaping (Result<Event, WEServiceError>) -> Void) {
        let url = URL(string: "\(self.apiUrl)/events/\(id)")!
        
        perform(url: url, completion: result)
    }
    
    func registerCheckin(checkin: Checkin, result: @escaping (Result<CheckinResponse, WEServiceError>) -> Void) {
        let url = URL(string: "\(self.apiUrl)/checkin")!
        
        let parameters: [String: String] = [
            "eventId": checkin.eventId,
            "name": checkin.name,
            "email": checkin.email
        ]
        
        perform(url: url, method: RequestType.post.rawValue, parameters: parameters, completion: result)
    }
    
    public enum RequestType: String {
        case get = "GET"
        case post = "POST"
    }
    
    public enum WEServiceError: Error {
        case noConnection
        case apiError
        case invalidEndpoint
        case invalidResponse
        case decodeError
    }
    
    private func perform<T: Decodable>(url: URL,
                                     method: String = RequestType.get.rawValue,
                                     parameters: [String: String]? = nil,
                                     completion: @escaping (Result<T, WEServiceError>) -> Void) {
        guard WeConnectivityStatus.online else {
            completion(.failure(.noConnection))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        if let parameters = parameters {
            var queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url, httpMethod: method) { (result) in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(value))
                    } catch _ {
                        completion(.failure(.decodeError))
                    }
            case .failure( _):
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
}
