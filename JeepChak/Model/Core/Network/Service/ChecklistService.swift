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
    
    // 기존 메서드 이름 변경
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
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 체크리스트 자동 생성
    func generateChecklist(propertyId: Int) -> AnyPublisher<[GeneratedChecklistResponse], Error> {
        provider.requestPublisher(.generateChecklist(propertyId: propertyId))
            .filterSuccessfulStatusCodes()
            .tryMap { response in
                print("====== RAW JSON START ======")
                print(String(data: response.data, encoding: .utf8) ?? "nil")
                print("====== RAW JSON END ======")

                let decoded = try JSONDecoder().decode(
                    ApiResponse<[GeneratedChecklistResponse]>.self,
                    from: response.data
                )

                return decoded.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

}
