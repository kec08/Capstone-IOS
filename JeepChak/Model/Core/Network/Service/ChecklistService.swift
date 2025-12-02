//
//  ChecklistService.swift
//  JeepChak
//
//  Created by 김은찬 on 11/15/25.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class ChecklistService {
    private let provider = MoyaProvider<ChecklistAPI>(plugins: [NetworkLoggerPlugin()])
    
    func uploadChecklist(request: ChecklistRequest) -> AnyPublisher<ChecklistResponse, Error> {
        provider.requestPublisher(.createChecklist(request: request))
            .filterSuccessfulStatusCodes()
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<ChecklistResponse>.self,
                    from: response.data
                )
                return decoded.data
            }
            .eraseToAnyPublisher()
    }
    
    func generateChecklist(propertyId: Int) -> AnyPublisher<[GeneratedChecklistResponse], Error> {
        provider.requestPublisher(.generateChecklist(propertyId: propertyId))
            .filterSuccessfulStatusCodes()
            .tryMap { response in
                print(String(data: response.data, encoding: .utf8) ?? "nil")

                let decoded = try JSONDecoder().decode(
                    ApiResponse<[GeneratedChecklistResponse]>.self,
                    from: response.data
                )
                return decoded.data
            }
            .eraseToAnyPublisher()
    }
}
