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
    internal init(root: String, port: UInt16) {
        server = HTTPServer()
        var routes = Routes(baseUri: "/api")
        routes.add(makeRoutes())
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
}
