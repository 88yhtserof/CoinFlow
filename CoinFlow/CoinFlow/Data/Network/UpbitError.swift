//
//  UpbitError.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

import Alamofire

enum UpbitError: NetworkError {
    case badRequest(String)
    case unauthorized(String)
    case unknown
    
    init?<T: Decodable>(_ statusCode: Int, errorResponse: DataResponse<T, AFError>) {
        
        guard let data = errorResponse.data,
              let decoded = try? JSONDecoder().decode(UpbitErrorResponse.self, from: data) else {
            print("Failed to decode error response")
            return nil
        }
        let message = decoded.error.message
        
        switch statusCode {
        case 400:
            self = .badRequest(message)
        case 401:
            self = .unauthorized(message)
        default:
            self = .unknown
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .unknown:
            return nil
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다.\n관리자에게 문의하십시오"
        case .unauthorized:
            return "권한이 없습니다.\n관리자에게 문의하십시오"
        case .unknown:
            return "알 수 없는 오류입니다.\n관리자에게 문의하십시오"
        }
    }
    
    var errorLog: String {
        switch self {
        case .badRequest(let log):
            return log
        case .unauthorized(let log):
            return log
        case .unknown:
            return "Unknown Error"
        }
    }
    
}

extension UpbitError {
    
    enum ErrorCode: String {
        
        // 400 Bad Request
        case create_ask_error
        case create_bid_error
        case insufficient_funds_ask
        case insufficient_funds_bid
        case under_min_total_ask
        case under_min_total_bid
        case withdraw_address_not_registerd
        case validation_error
        
        // 401 Unauthorized
        case invalid_query_payload
        case jwt_verification
        case expired_access_key
        case nonce_used
        case no_authorization_i_p
        case out_of_scope
        
        var code: String {
            return rawValue
        }
        
        var message: String {
            switch self {
            case .create_ask_error, .create_bid_error:
                return "주문 요청 정보가 올바르지 않습니다."
            case .insufficient_funds_ask, .insufficient_funds_bid:
                return "매수/매도 가능 잔고가 부족합니다."
            case .under_min_total_ask, .under_min_total_bid:
                return "최소 매매 금액을 충족하지 않았습니다."
            case .withdraw_address_not_registerd:
                return "허용되지 않은 출금 주소입니다."
            case .validation_error:
                return "잘못된 API 요청입니다."
                
            case .invalid_query_payload:
                return "JWT 헤더의 페이로드가 올바르지 않습니다.\n서명에 사용한 페이로드 값을 확인해주세요."
            case .jwt_verification:
                return "JWT 헤더 검증에 실패했습니다.\n토큰이 올바르게 생성, 서명되었는지 확인해주세요."
            case .expired_access_key:
                return "액세스 키가 만료되었습니다.\n새로 발급받으신 키를 사용해주세요."
            case .nonce_used:
                return "nonce 값이 중복되었습니다.\nnonce 값을 재발급받으신 후 다시 시도해주세요."
            case .no_authorization_i_p:
                return "허용되지 않은 IP 주소입니다."
            case .out_of_scope:
                return "허용되지 않은 기능입니다."
            }
        }
    }
}
