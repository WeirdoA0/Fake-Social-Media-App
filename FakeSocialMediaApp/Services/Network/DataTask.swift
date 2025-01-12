//
//  DataTask.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import Foundation

protocol IDataTaskService {
    static func completeRequest(request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void )
}

final class DataTaskService: IDataTaskService {
    static func completeRequest(request: URLRequest, completion: @escaping(Result<Data, Error>) -> Void ) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            if (error != nil) {
                completion(.failure(TaskError.unableToRunTask))
            } else {
                let httpResponse  = response as? HTTPURLResponse
                switch httpResponse?.statusCode{
                case 200:
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(TaskError.noData))
                    }
                case 403:
                    completion(.failure(TaskError.noAccess))
                case 404:
                    completion(.failure(TaskError.notFound))
                default:
                    completion(.failure(TaskError.badResponse))
                }
            }
        })
        dataTask.resume()
    }
}

private enum TaskError: Error {
    case unableToRunTask
    case noAccess
    case notFound
    case badResponse
    case noData
}
extension TaskError: LocalizedError {
    public var errorDescription: String? {
          switch self {
          case .unableToRunTask:
              return("Failed to start data Task")
          case .noAccess:
              return("Error 403 failed to access database")
          case .notFound:
              return("Error 404")
          case .badResponse:
              return("bad response")
          case .noData:
              return("Failed to load data")
          }
    }
}
