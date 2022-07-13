//
//  Service.swift
//  GitJobs
//
//  Created by Rustam on 01.04.2021.
//

import Foundation
import Alamofire
import RxSwift
import Realm

struct Response {
    var items: [Job]?
    var error: GJError?
}

protocol ServiceP {
    func cachedJob(by jobID: String) -> Single<Job>
    func getList(page: Int) -> Single<Response>
}

private enum Request: URLRequestConvertible {
    
    case getList(page: Int)
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://jobs.github.com/positions.json")!)
        request.httpMethod = Alamofire.HTTPMethod.get.rawValue
        
        switch self {
        case let .getList(page):
            let params = [
                "description" : "developer",
                "page" : "\(page)"
            ]
            
            return try URLEncoding.queryString.encode(request, with: params)
        }
    }
}

class Service: ServiceP {
    
    private let dataBase: DataBase<Job>
    
    init(dataBase: DataBase<Job>) {
        self.dataBase = dataBase
    }
    
    func getList(page: Int) -> Single<Response> {
        if page == 1 {
            dataBase.delete()
        }
        
        return Single<Response>
            .create { single in
                AF.request(Request.getList(page: page)).responseJSON(completionHandler: { [unowned self] response in
                    if let error = response.error {
                        single(.success(Response(items: nil, error: GJError.cantGetJobs(reason: error.localizedDescription))))
                        return
                    }

                    let jsonString = String(data: response.data!, encoding: .utf8)!
                    guard let jobs = Array<Job>(JSONString: jsonString) else {
                        single(.success(Response(items: nil, error: GJError.cantGetJobs(reason: nil))))
                        return
                    }
                    dataBase.store(jobs)

                    single(.success(Response(items: dataBase.list(), error: nil)))
                })
                
                return Disposables.create()
            }
    }
    
    func cachedJob(by jobID: String) -> Single<Job> {
        Single<Job>
            .create { single in
                guard let job = self.dataBase.cached(jobID) else {
                    single(.failure(GJError.emptyDetails))
                    return Disposables.create()
                }
                single(.success(job))
                return Disposables.create()
            }
    }
}
