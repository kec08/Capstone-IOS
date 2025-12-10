import Foundation
import Combine
import Moya
import CombineMoya

final class PropertyService {
    private let provider = MoyaProvider<PropertyAPI>(
        plugins: [NetworkLoggerPlugin()]
    )
    
    // 전체 매물 조회
    func getProperties() -> AnyPublisher<[PropertyListResponse], Error> {
        provider.requestPublisher(.getProperties)
            .tryMap { response in
                print(String(data: response.data, encoding: .utf8) ?? "nil")
                
                let decoded = try JSONDecoder().decode(
                    ApiResponse<[PropertyListResponse]>.self,
                    from: response.data
                )
                
                // ✔ success 체크 + Optional data 언래핑
                guard decoded.success, let list = decoded.data else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
                
                print("조회된 매물 개수:", list.count)
                return list
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    // 매물 상세 조회
    func getPropertyDetail(id: Int) -> AnyPublisher<PropertyResponse, Error> {
        provider.requestPublisher(.getPropertyDetail(id: id))
            .tryMap { response in
                print(String(data: response.data, encoding: .utf8) ?? "nil")
                
                let decoded = try JSONDecoder().decode(
                    ApiResponse<PropertyResponse>.self,
                    from: response.data
                )
                
                guard decoded.success, let property = decoded.data else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
                
                return property
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 매물 생성
    func createProperty(request: PropertyRequest) -> AnyPublisher<PropertyResponse, Error> {
        provider.requestPublisher(.createProperty(request: request))
            .tryMap { response in
                print("status:", response.statusCode)
                print(String(data: response.data, encoding: .utf8) ?? "nil")

                let decoded = try JSONDecoder().decode(
                    ApiResponse<PropertyResponse>.self,
                    from: response.data
                )
                
                guard decoded.success, let property = decoded.data else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }

                return property
            }
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
