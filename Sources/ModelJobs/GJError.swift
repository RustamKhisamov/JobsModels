//
//  GJError.swift
//  GitJobs
//
//  Created by Rustam on 03.04.2021.
//

import Foundation

enum GJError: Error {
    case cantGetJobs(reason: String?)
    case emptyDetails
    
    public var message: String {
        switch self {
        case .cantGetJobs(let reason):
            return reason ?? "Can't download list of jobs"
        case .emptyDetails:
            return "Can't download job details. Try again"
        }
    }
}
