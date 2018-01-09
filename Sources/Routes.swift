//
//  Routes.swift
//  PerfectDemoProject
//
//  Created by xiwang wang on 2018/1/6.
//

import PerfectLib
import PerfectHTTP

public func makeRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/", handler: CustomHandlers.LevelHtmlTest)
    routes.add(method: .get, uri: "/home", handler: CustomHandlers.LevelAllHandlerGet)
    routes.add(method: .post, uri: "/register", handler: CustomHandlers.LevelInsertHandlerGet)
    routes.add(method: .post, uri: "/delete", handler: CustomHandlers.LevelDeleteHandlerGet)
    routes.add(method: .post, uri: "/update", handler: CustomHandlers.LevelUpdateHandlerGet)
    routes.add(method: .post, uri: "/select", handler: CustomHandlers.LevelSelectHandlerGet)
    return routes
}

