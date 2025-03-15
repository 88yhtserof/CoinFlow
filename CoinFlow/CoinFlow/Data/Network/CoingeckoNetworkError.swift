//
//  CoingeckoNetworkError.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/14/25.
//

import Foundation

enum CoingeckoNetworkError: NetworkError {
    case badRequest
    case unauthorized
    case forbidden
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case accessDenied
    case apiKeyMissing
    case unknown
    
    var statusCode: Int? {
        switch self {
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .tooManyRequests:
            return 429
        case .internalServerError:
            return 500
        case .serviceUnavailable:
            return 503
        case .accessDenied:
            return 1020
        case .apiKeyMissing:
            return 10002
        case .unknown:
            return nil
        }
    }
    
    var errorDescription: String? {
        return message
    }
    
}

extension CoingeckoNetworkError: LocalizedError {
    
    private var message: String {
        switch self {
        case .badRequest:
            return "요청이 잘못되었습니다.\n입력한 내용을 다시 확인하고 시도해 주세요."
        case .unauthorized:
            return "인증에 실패했습니다.\n로그인 상태를 확인하고, 올바른 인증 정보를 입력해 주세요."
        case .forbidden:
            return "해당 작업을 수행할 권한이 없습니다.\n권한을 확인한 후 다시 시도해 주세요."
        case .tooManyRequests:
            return "요청이 너무 많습니다.\n요청 속도를 줄이거나, 더 높은 요금제에 가입하여 더 많은 요청을 할 수 있습니다."
        case .internalServerError:
            return "서버에 문제가 발생했습니다.\n잠시 후 다시 시도해 주세요. 문제가 지속되면 고객 지원에 문의해 주세요."
        case .serviceUnavailable:
            return "서비스가 현재 이용 불가입니다.\nAPI 상태 및 업데이트를 여기에서 확인해 주세요."
        case .accessDenied:
            return "CDN 방화벽 규칙 위반으로 접근이 거부되었습니다.\n시스템 관리자에게 문의해 주세요."
        case .apiKeyMissing:
            return "제공된 API 키가 올바르지 않습니다.\n개발자 대시보드에서 키를 확인하고 올바른 API 키를 사용해 주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다.\n관리자에게 문의해 주세요."
        }
    }
}

/*
 {
     "status": {
         "error_code": 429,
         "error_message": "You've exceeded the Rate Limit. Please visit https://www.coingecko.com/en/api/pricing to subscribe to our API plans for higher rate limits."
     }
 }
 */
