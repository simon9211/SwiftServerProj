//
//  DatabaseManager.swift
//  PerfectDemoProjectPackageDescription
//
//  Created by xiwang wang on 2018/1/5.
//

import PerfectMySQL

let mysql_host = "0.0.0.0"
let mysql_user = "root"
let mysql_pwd = "simon0919"
let mysql_database = "TianProject"

let table_account = "account_level"

open class DatabaseManager {
    
    fileprivate var mysql: MySQL
    internal init() {
        mysql = MySQL.init()
        guard connectedDatabase() else {
            return
        }
    }
    
    //MARK: 开启连接
    private func connectedDatabase() -> Bool {
        let connected = mysql.connect(host: mysql_host, user: mysql_user, password: mysql_pwd, db: mysql_database, port: 3306, socket: nil, flag: 0)
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
        guard mysql.selectDatabase(named: mysql_database) else {
            msg = "not found \(mysql_database) database"
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
        let SQL: String = "INSERT INTO \(tableName) \(key) VALUES (\(value))"
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
    
    // 查看account_level表中所有数据
    func mysqlGetHomeDataResult() -> [Dictionary<String, String>]? {
        let result = queryAllDatabaseSQL(tableName: table_account)
        var resultArray = [Dictionary<String, String>]()
        var dict = [String:String]()
        result.mysqlResult?.forEachRow(callback: { (row) in
            dict["level_id"] = row[0]
            dict["name"] = row[1];
            resultArray.append(dict)
        })
        return resultArray
    }
}




