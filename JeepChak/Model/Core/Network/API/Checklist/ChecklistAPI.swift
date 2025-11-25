//
//  ChecklistAPI.swift
//  JeepChak
//
//  Created by 김은찬 on 11/13/25.
//

import Foundation
import Moya
internal import Alamofire

enum ChecklistAPI {
    case createChecklist(request: ChecklistRequest)
    case generateChecklist(propertyId: Int)
    case getChecklists
    case getChecklistDetail(id: Int)
    case updateChecklist(id: Int, items: [ChecklistItemRequest])
    case deleteChecklist(id: Int)
}

extension ChecklistAPI: TargetType {

    var baseURL: URL {
        URL(string: "http://zipchak-backend.kro.kr:8080/")!
    }

    var path: String {
        switch self {
        case .createChecklist:
            return "/api/checklist"
        case .generateChecklist:
            return "/api/checklist/generate"
        case .getChecklists:
            return "/api/checklist"
        case .getChecklistDetail(let id),
             .deleteChecklist(let id),
             .updateChecklist(let id, _):
            return "/api/checklist/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createChecklist, .generateChecklist: return .post
        case .getChecklists, .getChecklistDetail: return .get
        case .updateChecklist: return .put
        case .deleteChecklist: return .delete
        }
    }

    var task: Task {
        switch self {
        case .createChecklist(let request):
            return .requestJSONEncodable(request)

        case .generateChecklist(let propertyId):
            return .requestParameters(
                parameters: ["propertyId": propertyId],
                encoding: JSONEncoding.default
            )

        case .getChecklists, .getChecklistDetail, .deleteChecklist:
            return .requestPlain

        case .updateChecklist(_, let items):
            return .requestJSONEncodable(items)
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }
}
