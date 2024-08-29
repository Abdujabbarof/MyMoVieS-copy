//
//  NetworkManager.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/"
    let seachBaseUrl = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword="
    let apikey = "8c8e1a50-6322-4135-8875-5d40a5420d86"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getTrailers(for movieId: Int, completed: @escaping (Result<TrailerResponse, GFError>) -> Void) {
        let endpoint = "\(baseUrl)\(movieId)/videos"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apikey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(.unableTo))
                print("Wrror", error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidRes))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Received JSON: \(jsonString)")
//            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let moviesResponse = try decoder.decode(TrailerResponse.self, from: data)
                completed(.success(moviesResponse.self))
            } catch {
                completed(.failure(.invalidData2))
                print("Decoding error: \(error.localizedDescription)")
                
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    default:
                        print("Other decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getMovie(for movieId: Int, completed: @escaping (Result<MovieDetail, GFError>) -> Void) {
        let endpoint = "\(baseUrl)\(movieId)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apikey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(.unableTo))
                print("Wrror", error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidRes))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Received JSON: \(jsonString)")
//            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let moviesResponse = try decoder.decode(MovieDetail.self, from: data)
                completed(.success(moviesResponse.self))
            } catch {
                completed(.failure(.invalidData2))
                print("Decoding error: \(error.localizedDescription)")
                
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    default:
                        print("Other decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getMovies(for type: String, page: Int, completed: @escaping (Result<[Film], GFError>) -> Void) {
        let endpoint = "\(baseUrl)top?type=\(type)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apikey, forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(.unableTo))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidRes))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
//             Print the raw JSON data as a string for debugging
//                        if let jsonString = String(data: data, encoding: .utf8) {
//                            print("Received JSON: \(jsonString)")
//                        }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: data)
                completed(.success(moviesResponse.films))
            } catch {
                completed(.failure(.invalidData2))
                print("Decoding error: \(error.localizedDescription)")
                
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                    default:
                        print("Other decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getSearchMovies(keyword: String, completed: @escaping (Result<[Film], GFError>) -> Void) {
            let endpoint = "\(seachBaseUrl)\(keyword)"
            
            guard let url = URL(string: endpoint) else {
                completed(.failure(.invalidUsername))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(apikey, forHTTPHeaderField: "X-API-KEY")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completed(.failure(.unableTo))
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidRes))
                    return
                }
                
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let searchResponse = try decoder.decode(SearchMoviesResponse.self, from: data)
                    completed(.success(searchResponse.films))
                } catch {
                    completed(.failure(.invalidData2))
                    print("Decoding error: \(error.localizedDescription)")
                    
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .typeMismatch(let type, let context):
                            print("Type mismatch: \(type), \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value not found: \(type), \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("Key not found: \(key), \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        default:
                            print("Other decoding error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            task.resume()
        }
}
