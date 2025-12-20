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
        provider.requestPublisher(.analyze(request: request, files: files))
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

