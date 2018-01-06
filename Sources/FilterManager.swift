//
//  FilterManager.swift
//  PerfectDemoProject
//
//  Created by xiwang wang on 2018/1/6.
//

import PerfectLib
import PerfectHTTP

//MARK: 404过滤
struct Filter404: HTTPResponseFilter {
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.bodyBytes.removeAll()
            response.setBody(string: "404 file\(response.request.path) not exist")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        } else {
            callback(.continue)
        }
    }
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
}
