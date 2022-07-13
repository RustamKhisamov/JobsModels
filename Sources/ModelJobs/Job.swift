//
//  Job.swift
//  GitJobs
//
//  Created by Rustam on 01.04.2021.
//

import Foundation
import RealmSwift
import ObjectMapper

class Job: Object, Mappable {

    @objc dynamic var jobId = ""
    @objc dynamic var title = ""
    @objc dynamic var company = ""
    @objc dynamic var howApply = ""
    @objc dynamic var jobDescription = ""
    @objc dynamic var createDate = ""
    
    override static func primaryKey() -> String {
        "jobId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        jobId <- map["id"]
        title <- map["title"]
        company <- map["company"]
        howApply <- map["how_to_apply"]
        jobDescription <- map["description"]
        createDate <- map["created_at"]
        
        formateDate()
    }
    
    private func formateDate() {
        let date =  createDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd HH:mm:ss z yyyy"
        let dateShortForm = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        createDate = dateFormatter.string(from: dateShortForm!)
    }
}
