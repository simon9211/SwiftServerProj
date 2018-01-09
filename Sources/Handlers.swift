//
//  Handlers.swift
//  PerfectDemoProject
//
//  Created by xiwang wang on 2018/1/6.
//

import PerfectHTTP
import PerfectLib
import Foundation

public class CustomHandlers {
    
    open static func LevelHtmlTest(request: HTTPRequest, _ response: HTTPResponse) {
        response.setHeader(.contentType, value: "text/html")
        let jsonDict = ["hello":"world"]
        let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: jsonDict)
        response.setBody(string: jsonString)
        response.completed()
    }
    
    open static func LevelAllHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        let result = LevelTableOperationManager.shareManager.mysqlGetHomeDataResult()
        let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: result)
        response.setBody(string: jsonString)
        response.setHeader(.contentType, value: "application/json")
        response.completed()
    }
    
    open static func LevelInsertHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        let params = request.postBodyString
        do {
            let dict: Dictionary<String, Any> = try params?.jsonDecode() as! [String:Any]
            let level: LevelModel = LevelModel(dict:dict)
            let result = LevelTableOperationManager.shareManager.insertToLevelTable(level: level)
            if result {
                let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: "register successed")
                response.setBody(string: jsonString)
                response.setHeader(.contentType, value: "application/json")
                response.completed()
            } else {
                response.completed(status: .badRequest)
                return
            }
        } catch {
            
        }
    }
    
    open static func LevelDeleteHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        let params = request.postBodyString
        do {
            let dict: Dictionary<String, Any> = try params?.jsonDecode() as! [String:Any]
            let res = LevelTableOperationManager.shareManager.deleteLevelWithLevelId(levelId: dict["level_id"] as! Int)
            if res {
                let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: "delete successed")
                response.setBody(string: jsonString)
                response.setHeader(.contentType, value: "application/json")
                response.completed()
            } else {
                response.completed(status: .badRequest)
                return
            }
        } catch {
            
        }
    }
    
    open static func LevelUpdateHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        let params = request.postBodyString
        do {
            let dict: Dictionary<String, Any> = try params?.jsonDecode() as! [String:Any]
            let level: LevelModel = LevelModel(dict:dict)
            let res = LevelTableOperationManager.shareManager.updateLevelTable(level: level)
            if res {
                let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: "update successed")
                response.setBody(string: jsonString)
                response.setHeader(.contentType, value: "application/json")
                response.completed()
            } else {
                response.completed(status: .badRequest)
                return
            }
        } catch {
            
        }
    }
    
    open static func LevelSelectHandlerGet(request: HTTPRequest, _ response: HTTPResponse) {
        let params = request.postBodyString
        do {
            let dict: Dictionary<String, Any> = try params?.jsonDecode() as! [String:Any]
            let level: LevelModel = LevelModel(dict:dict)
            let res = LevelTableOperationManager.shareManager.selectLevelTabel(level: level)
            let jsonString = baseResponseBodyJSONData(status: 200, message: "successed", data: res)
            response.setBody(string: jsonString)
            response.setHeader(.contentType, value: "application/json")
            response.completed()
        } catch {
            
        }
    }
    
    //MARK: 通用响应格式
    static func baseResponseBodyJSONData(status: Int, message: String, data: Any!) -> String {
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
}
