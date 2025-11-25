//
//  ChecklistService.swift
//  JeepChak
//
//  Created by 김은찬 on 11/13/25.

import Foundation
import Combine
import Moya
import CombineMoya


final class PropertyService {
    private let provider = MoyaProvider<PropertyAPI>(plugins: [NetworkLoggerPlugin()])
    
    // 전체 매물 조회
    func getProperties() -> AnyPublisher<[PropertyListResponse], Error> {
        provider.requestPublisher(.getProperties)
            .filterSuccessfulStatusCodes()
            .tryMap { response in
                print("====== RAW JSON START ======")
                print(String(data: response.data, encoding: .utf8) ?? "nil")
                print("====== RAW JSON END ======")

                let decoded = try JSONDecoder().decode(
                    ApiResponse<[PropertyListResponse]>.self,
                    from: response.data
                )
                return decoded.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }




    // 매물 상세 조회
    func getPropertyDetail(id: Int) -> AnyPublisher<PropertyResponse, Error> {
        provider.requestPublisher(.getPropertyDetail(id: id))
            .filterSuccessfulStatusCodes()
            .map(PropertyResponse.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 매물 생성
    func createProperty(request: PropertyRequest) -> AnyPublisher<PropertyResponse, Error> {
        provider.requestPublisher(.createProperty(request: request))
            .filterSuccessfulStatusCodes()
            .map(PropertyResponse.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 매물 삭제
    func deleteProperty(id: Int) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.deleteProperty(id: id))
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
