//
//  NetworkServerManager.swift
//  PerfectDemoProjectPackageDescription
//
//  Created by xiwang wang on 2018/1/5.
//
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

open class NetworkServerManager{
    fileprivate var server: HTTPServer
    fileprivate var databaseManager: DatabaseManager
    internal init(root: String, port: UInt16) {
        server = HTTPServer()
        databaseManager = DatabaseManager()
        var routes = Routes(baseUri: "/api")
        configure(routes: &routes)
        server.addRoutes(routes)
        server.serverPort = port
        server.documentRoot = root
        server.setResponseFilters([(Filter404(),.high)])
    }
    
    //MARK: 开启服务
    open func startServer() {
        do {
            print("启动服务器")
            try server.start()
        } catch PerfectError.networkError(let err, let msg){
            print( "网络出现错误\(err)\(msg)")
        } catch {
            print("网络未知错误")
        }
    }
    
    //MARK: 注册路由
    fileprivate func configure(routes: inout Routes) {
        routes.add(method: .get, uri: "/") { (request, response) in
            response.setHeader(.contentType, value: "text/html")
            let jsonDict = ["hello":"world"]
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "successed", data: jsonDict)
            response.setBody(string: jsonString)
            response.completed()
        }
        
        routes.add(method: .get, uri: "/home") { (request, response) in
            let result = self.databaseManager.mysqlGetHomeDataResult()
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "successed", data: result)
            response.setBody(string: jsonString)
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        }
        
        routes.add(method: .post, uri: "/register") { (request, response) in
            let params = request.postParams[0].0
            let jsonData: Data = params.data(using: .utf8)!
            let dict: Dictionary<String,String> = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary
            //let result = self.databaseManager.insertDatabaseSQL(tableName: table_account, key: dict["level_id"]!, value: dict["name"]!)
            //@"insert into Media (userId, sacId, checkId, httpUrl, fileUrl, startTime, mediaType, status, type, attributeId) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            let result = self.databaseManager.insertDatabaseSQL(tableName: table_account, key: "('name','level_id')", value: "'\(dict["name"]!)','\(dict["level_id"]!)'")
            if result.success {
                let jsonString = self.baseResponseBodyJSONData(status: 200, message: "successed", data: "register successed")
                response.setBody(string: jsonString)
                response.setHeader(.contentType, value: "application/json")
                response.completed()
            } else {
                response.completed(status: .badRequest)
                return
            }
            
        }
    }
    
    //MARK: 通用响应格式
    func baseResponseBodyJSONData(status: Int, message: String, data: Any!) -> String {
        var result = Dictionary<String, Any>()
        result.updateValue(status, forKey: "status")
        result.updateValue(message, forKey: "message")
        if data != nil {
            result.updateValue(data, forKey: "data")
        } else {
            result.updateValue("", forKey: "data")
        }
        
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
    }
    
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
    
}
