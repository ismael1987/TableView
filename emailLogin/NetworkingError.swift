//
//  NetworkingError.swift
//  emailLogin
//
//  Created by user158383 on 10/8/19.
//  Copyright © 2019 user158383. All rights reserved.
//

import Foundation

enum NetworkingError: Swift.Error {
    
    case serializingError
    case notValidEmailError
    case wrongEmailError
    case noPasswordError
    case wrongPasswordError
    case networkOfflineError
    case unexpectedDataError
    case nonSuccessfulResponseError
    case unexpectedError
    
    func getErrorString() -> String {
        switch self {
        case .serializingError:
            return "Error: Serialization!"
        case .notValidEmailError:
            return "Error: NotValidEmai!"
        case .wrongEmailError:
            return "Error: WrongEmail!"
        case .noPasswordError:
            return "Error: NoPassword!"
        case .wrongPasswordError:
            return "Error: WrongPassword!"
        case .networkOfflineError:
            return "Error: NetworkOffline!"
        case .unexpectedDataError:
            return "Error: UnexpectedData!"
        case .nonSuccessfulResponseError:
            return "Error: NonsuccessfulResponse!"
        case .unexpectedError:
            return "Error: Unexpected!"
        }
    }
}
