//
//  NetworkingService.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 17.03.2024.
//

import Foundation
import Alamofire
import UIKit

enum Links: String {
    case baseUrl = "https://api.kinopoisk.dev/v1.4/"
}

final class NetworkingManager {
    static let shared = NetworkingManager()
    private let headers: HTTPHeaders = [
      "accept": "application/json",
      "X-API-KEY": "0DRDXYH-D2CM4R4-GEY083Z-N090K66"//"H2BEHR2-ZP9MHW2-Q168Q5V-ARA0EGX"
    ]
    private let decoder = JSONDecoder()
    
    private init() {}
    
    //typealias Completion<T> = (Result<T, AFError>) -> Void
    
    // MARK: - Alamofire request
    func fetchDataFaster<T: ResponseType>(
        type: T.Type,
        searchType: String = "",
        parameters: [String: [String]] = [:],
        completion: @escaping (Result<[T], AFError>) -> Void
    ) {
        guard let url = URL(
            string: Links.baseUrl.rawValue +
            T.type + searchType + "?") else { return }
        AF.request(
            url,
            parameters: parameters,
            encoder:  URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets)),
            headers: headers
        ).validate()
            .responseDecodable(of: APIResponse<T>.self, decoder: decoder) { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    completion(.success(value.docs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
