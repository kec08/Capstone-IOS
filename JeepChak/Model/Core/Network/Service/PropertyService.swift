import Foundation
import Combine
import Moya
import CombineMoya

struct CreatePropertyMessageResponse: Decodable {
    let message: String
}

final class PropertyService {
    private let provider = MoyaProvider<PropertyAPI>(
        plugins: [NetworkLoggerPlugin()]
    )

    func getProperties() -> AnyPublisher<[PropertyListResponse], Error> {
        provider.requestPublisher(.getProperties)
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<[PropertyListResponse]>.self,
                    from: response.data
                )

                guard decoded.success else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }

                return decoded.data ?? []
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func getPropertyDetail(id: Int) -> AnyPublisher<PropertyResponse, Error> {
        provider.requestPublisher(.getPropertyDetail(id: id))
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<PropertyResponse>.self,
                    from: response.data
                )

                guard decoded.success else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }

                guard let data = decoded.data else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "매물 상세 데이터가 없습니다."]
                    )
                }

                return data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    /// 매물 생성: POST /api/properties
    /// Request: { name, address, propertyType, floor, builtYear, area, marketPrice, leaseType, deposit, monthlyRent, memo }
    /// Response: { message: "매물이 생성되었습니다." }
    func createProperty(request: PropertyRequest) -> AnyPublisher<String, Error> {
        provider.requestPublisher(.createProperty(request: request))
            .tryMap { response in
                // 명세에 따른 응답: { message: "매물이 생성되었습니다." }
                // 1) 단독 message 형태 (명세에 정확히 맞는 형태)
                if let msgResponse = try? JSONDecoder().decode(CreatePropertyMessageResponse.self, from: response.data) {
                    return msgResponse.message
                }
                
                // 2) ApiResponse로 래핑된 경우
                if let wrapped = try? JSONDecoder().decode(ApiResponse<String>.self, from: response.data) {
                    if wrapped.success {
                        return wrapped.message
                    }
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: wrapped.message]
                    )
                }
                
                // 3) ApiResponse<PropertyResponse> 형태
                if let wrapped = try? JSONDecoder().decode(ApiResponse<PropertyResponse>.self, from: response.data) {
                    if wrapped.success {
                        return wrapped.message
                    }
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: wrapped.message]
                    )
                }

                // 파싱 실패
                let raw = String(data: response.data, encoding: .utf8) ?? "nil"
                throw NSError(
                    domain: "PropertyService",
                    code: response.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "응답 파싱 실패: \(raw)"]
                )
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func deleteProperty(id: Int) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.deleteProperty(id: id))
            .tryMap { response in
                // delete도 ApiResponse로 올 수도 있으니 안전 처리
                if let wrapped = try? JSONDecoder().decode(ApiResponse<String>.self, from: response.data) {
                    guard wrapped.success else {
                        throw NSError(
                            domain: "PropertyService",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: wrapped.message]
                        )
                    }
                    return ()
                }

                // 래핑이 아니면 status code 기준 성공 처리
                guard (200..<300).contains(response.statusCode) else {
                    throw NSError(
                        domain: "PropertyService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "삭제 실패"]
                    )
                }
                return ()
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
