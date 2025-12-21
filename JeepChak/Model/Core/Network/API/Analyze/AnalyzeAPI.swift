//
//  AnalyzeAPI.swift
//  JeepChak
//
//  Created by 김은찬 on 12/3/25.
//

import Foundation
import Moya
internal import Alamofire

enum AnalyzeAPI {
    case analyze(request: AnalyzeRequestDTO, files: [URL])
    case getAnalyzeDetail(id: Int)
    case riskSolution(request: RiskSolutionRequestDTO, files: [URL])
    case getRiskSolution(id: Int)
}

extension AnalyzeAPI: TargetType {
    var baseURL: URL {
        URL(string: "http://zipchak-backend.kro.kr:8080")!
    }
    
    var path: String {
        switch self {
        case .analyze:
            return "/api/analyze"
        case .getAnalyzeDetail(let id):
            return "/api/analyze/\(id)"
        case .riskSolution:
            return "/api/risk/solution"
        case .getRiskSolution(let id):
            return "/api/risk/solution/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .analyze, .riskSolution:
            return .post
        case .getAnalyzeDetail, .getRiskSolution:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .analyze(let request, let files):
            var formData: [Moya.MultipartFormData] = []
            
            // propertyId, marketPrice, deposit, monthlyRent를 개별 필드로 추가
            formData.append(Moya.MultipartFormData(provider: .data("\(request.propertyId)".data(using: .utf8)!), name: "propertyId"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.marketPrice)".data(using: .utf8)!), name: "marketPrice"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.deposit)".data(using: .utf8)!), name: "deposit"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.monthlyRent)".data(using: .utf8)!), name: "monthlyRent"))
            
            // 파일들을 form-data로 추가
            for fileURL in files {
                if let fileData = try? Data(contentsOf: fileURL) {
                    let fileName = fileURL.lastPathComponent
                    let mimeType = mimeType(for: fileURL)
                    formData.append(Moya.MultipartFormData(
                        provider: .data(fileData),
                        name: "files",
                        fileName: fileName,
                        mimeType: mimeType
                    ))
                }
            }
            
            return .uploadMultipart(formData)
            
        case .riskSolution(let request, let files):
            var formData: [Moya.MultipartFormData] = []
            
            // propertyId, marketPrice, deposit, monthlyRent를 개별 필드로 추가
            formData.append(Moya.MultipartFormData(provider: .data("\(request.propertyId)".data(using: .utf8)!), name: "propertyId"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.marketPrice)".data(using: .utf8)!), name: "marketPrice"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.deposit)".data(using: .utf8)!), name: "deposit"))
            formData.append(Moya.MultipartFormData(provider: .data("\(request.monthlyRent)".data(using: .utf8)!), name: "monthlyRent"))
            
            // 파일들을 form-data로 추가
            for fileURL in files {
                if let fileData = try? Data(contentsOf: fileURL) {
                    let fileName = fileURL.lastPathComponent
                    let mimeType = mimeType(for: fileURL)
                    formData.append(Moya.MultipartFormData(
                        provider: .data(fileData),
                        name: "files",
                        fileName: fileName,
                        mimeType: mimeType
                    ))
                }
            }
            
            return .uploadMultipart(formData)
            
        case .getAnalyzeDetail, .getRiskSolution:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [
            "Accept": "application/json"
        ]
        
        // multipart 요청의 경우 Content-Type은 Moya가 자동으로 설정하므로 명시하지 않음
        // 단, 파일이 없는 경우에만 Content-Type을 설정
        switch self {
        case .analyze(_, let files), .riskSolution(_, let files):
            // 파일이 있는 경우 multipart/form-data이므로 Content-Type을 설정하지 않음
            break
        default:
            headers["Content-Type"] = "application/json"
        }
        
        if let token = TokenStorage.accessToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    private func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        switch pathExtension {
        case "pdf":
            return "application/pdf"
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        default:
            return "application/octet-stream"
        }
    }
}

