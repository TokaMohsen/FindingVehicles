//
//  NetworkClient.swift
//  FindingVehicles
//
//  Created by toka mohsen on 05/12/2021.
//

import Foundation
import RxSwift
import Alamofire


/**
 The requests which are handled by the networking service.
 */
protocol Request {

    /** The response type when the response was parsed by the application. */
    associatedtype ResponseData: Decodable

    /** The URL that should be requested. */
    var url: URL { get }
}

enum Endpoints: String {
    case GetVehicles = "https://poi-api.mytaxi.com/PoiService/poi/v1/"
}


/**
Responsible for handling the networking communication.
*/
class NetworkingService<T: Codable> {
   
    static func getData<T: Codable>(parameters: [String: String]? , url: Endpoints , completion: @escaping (Result<T, FNError>) -> Void) {
            AF.request(url.rawValue, method: .get, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // if no error provided by alamofire return .notFound error instead.
                        // .notFound should never happen here?
                        completion(.failure(.notFound))
                        return
                    }
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(.notFound))
                    }
                case .failure(let error):
                    completion(.failure(.badRequest))
                }
            }
    }
       
}
