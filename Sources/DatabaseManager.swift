//
//  DatabaseManager.swift
//  PerfectDemoProjectPackageDescription
//
//  Created by xiwang wang on 2018/1/5.
//

import PerfectMySQL



open class DatabaseManager {
    
    fileprivate var mysql: MySQL
    var mysqlHost: String = "0.0.0.0"
    var mysqlUser: String = "root"
    var mysqlPwd: String = "simon0919"
    var mysqlDatabase: String = "TianProject"
    var mysqlPort: UInt32 = 3306
    var tableName: String = "account_level"
    internal init() {
        mysql = MySQL.init()
    }
    
    //MARK: 开启连接
    func connectedDatabase() -> Bool {
        let connected = mysql.connect(host: mysqlHost, user: mysqlUser, password: mysqlPwd, db: mysqlDatabase, port: mysqlPort, socket: nil, flag: 0)
        guard connected else {
            print("MySQL connected failed" + mysql.errorMessage())
            return false
        }
        
//        defer {
//            mysql.close() //这个延后操作能够保证在程序结束时无论什么结果都会自动关闭数据库连接
//        }
        print("MySQL connected successed")
        return true
    }
    
    //MARK: 执行SQL语句
    @discardableResult
    func mysqlStatement(_ sql: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        var msg: String
        
        guard mysql.selectDatabase(named: mysqlDatabase) else {
            msg = "not found \(mysqlDatabase) database"
            print(msg)
            return (false, nil, msg)
        }
        let successQuery = mysql.query(statement: sql)
        
        guard successQuery else {
            msg = "SQL failed: \(sql)"
            print(msg)
            return (false, nil, msg)
        }
        
        msg = "SQL successed:\(sql)"
        print(msg)
        return (true, mysql.storeResults(), msg)
    }
    
    // insert
    func insertDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let SQL: String = "INSERT INTO \(tableName) \(key) VALUES(\(value))"
        return mysqlStatement(SQL)
    }
    
    // delete
    func deleteDatabaseSQL(tableName: String, key: String, value: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let SQL: String = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        return mysqlStatement(SQL)
    }
    
    // update
    func updateDatabaseSQL(tableName: String, keyValue: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let SQL: String = "UPDATE \(tableName) SET \(keyValue) WHERE \(whereKey) = '\(whereValue)'"
        return mysqlStatement(SQL)
    }
    
    // query all
    func queryAllDatabaseSQL(tableName: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let SQL = "SELECT * FROM \(tableName)"
        return mysqlStatement(SQL)
    }
    
    // select
    func selectDatabaseSQL(tableName: String, whereKey: String, whereValue: String) -> (success: Bool, mysqlResult: MySQL.Results?, errorMsg: String) {
        let SQL = "SELECT * FROM \(tableName) WHERE \(whereKey) = '\(whereValue)'"
        return mysqlStatement(SQL)
    }
}




