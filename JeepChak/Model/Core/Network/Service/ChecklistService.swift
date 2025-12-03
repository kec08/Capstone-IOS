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
    private let provider = MoyaProvider<ChecklistAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
    )
    
    func generateChecklist(request: ChecklistGenerateRequest) -> AnyPublisher<[GeneratedChecklistResponse], Error> {
        provider.requestPublisher(.generateChecklist(request: request))
            .tryMap { response in
                print("status:", response.statusCode)
                print(String(data: response.data, encoding: .utf8) ?? "nil")

                let decoded = try JSONDecoder().decode(
                    ApiResponse<[GeneratedChecklistResponse]>.self,
                    from: response.data
                )
                
                if (200...299).contains(response.statusCode) {
                    return decoded.data
                }
                
                let msg = decoded.message
                throw NSError(
                    domain: "ChecklistService",
                    code: response.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: msg]
                )
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
