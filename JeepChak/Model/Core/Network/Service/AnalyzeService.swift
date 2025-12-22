//
//  AnalyzeService.swift
//  JeepChak
//
//  Created by 김은찬 on 12/3/25.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class AnalyzeService {
    private let provider = MoyaProvider<AnalyzeAPI>(
        plugins: [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
    )
    
    // 위험도 분석 리포트
    func analyze(request: AnalyzeRequestDTO, files: [URL]) -> AnyPublisher<AnalyzeResponseDTO, Error> {
        // 요청 정보 로깅
        print("=== 분석 요청 정보 ===")
        print("propertyId: \(request.propertyId)")
        print("marketPrice: \(request.marketPrice)")
        print("deposit: \(request.deposit)")
        print("monthlyRent: \(request.monthlyRent)")
        print("파일 개수: \(files.count)")
        for (index, fileURL) in files.enumerated() {
            print("파일 \(index + 1): \(fileURL.lastPathComponent)")
        }
        if let token = TokenStorage.accessToken {
            print("토큰 존재: 예 (길이: \(token.count))")
        } else {
            print("토큰 존재: 아니오")
        }
        print("==================")
        
        return provider.requestPublisher(.analyze(request: request, files: files))
            .tryMap { response in
                print("=== 분석 응답 정보 ===")
                print("Status Code: \(response.statusCode)")
                print("Response Data 크기: \(response.data.count) bytes")
                
                // 403 오류 처리
                if response.statusCode == 403 {
                    let responseBody = String(data: response.data, encoding: .utf8) ?? "비어있음"
                    print("403 오류 응답 본문: \(responseBody)")
                    
                    // 응답 본문이 있으면 그 내용을 사용
                    if !response.data.isEmpty {
                        if let errorMessage = String(data: response.data, encoding: .utf8), !errorMessage.isEmpty {
                            throw NSError(
                                domain: "AnalyzeService",
                                code: 403,
                                userInfo: [NSLocalizedDescriptionKey: errorMessage]
                            )
                        }
                    }
                    
                    throw NSError(
                        domain: "AnalyzeService",
                        code: 403,
                        userInfo: [NSLocalizedDescriptionKey: "서버에서 요청을 거부했습니다. (403) 파일 형식이나 크기를 확인해주세요."]
                    )
                }
                
                // 응답 body가 비어있는 경우 처리
                guard !response.data.isEmpty else {
                    throw NSError(
                        domain: "AnalyzeService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "서버 응답이 비어있습니다."]
                    )
                }
                
                let responseBody = String(data: response.data, encoding: .utf8) ?? "디코딩 실패"
                print("응답 본문: \(responseBody)")
                
                let decoded = try JSONDecoder().decode(
                    ApiResponse<AnalyzeResponseDTO>.self,
                    from: response.data
                )
                if decoded.success, let data = decoded.data {
                    print("분석 성공!")
                    return data
                } else {
                    print("분석 실패: \(decoded.message)")
                    throw NSError(
                        domain: "AnalyzeService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
            }
            .mapError { error in
                print("에러 발생: \(error.localizedDescription)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // 분석 내용 조회
    func getAnalyzeDetail(id: Int) -> AnyPublisher<AnalyzeResponseDTO, Error> {
        provider.requestPublisher(.getAnalyzeDetail(id: id))
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<AnalyzeResponseDTO>.self,
                    from: response.data
                )
                if decoded.success, let data = decoded.data {
                    return data
                } else {
                    throw NSError(
                        domain: "AnalyzeService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 대처 방안 확인
    func riskSolution(request: RiskSolutionRequestDTO, files: [URL]) -> AnyPublisher<RiskSolutionResponseDTO, Error> {
        provider.requestPublisher(.riskSolution(request: request, files: files))
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<RiskSolutionResponseDTO>.self,
                    from: response.data
                )
                if decoded.success, let data = decoded.data {
                    return data
                } else {
                    throw NSError(
                        domain: "AnalyzeService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 대처 방안 조회
    func getRiskSolution(id: Int) -> AnyPublisher<RiskSolutionResponseDTO, Error> {
        provider.requestPublisher(.getRiskSolution(id: id))
            .tryMap { response in
                let decoded = try JSONDecoder().decode(
                    ApiResponse<RiskSolutionResponseDTO>.self,
                    from: response.data
                )
                if decoded.success, let data = decoded.data {
                    return data
                } else {
                    throw NSError(
                        domain: "AnalyzeService",
                        code: response.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: decoded.message]
                    )
                }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

