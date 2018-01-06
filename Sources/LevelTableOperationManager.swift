//
//  LevelTableOperationManager.swift
//  PerfectDemoProjectPackageDescription
//
//  Created by xiwang wang on 2018/1/6.
//

import StORM
import MySQLStORM

class LevelModel: MySQLStORM {
    var id: Int = 0
    var level_id: Int = 0
    var name: String = ""
    
    override init() {
        
    }
    
    init(dict: Dictionary<String, Any>) {
        level_id = dict["level_id"] as! Int
        name = dict["name"] as! String
    }
    
    override open func table() -> String {
        return " "
    }
    
    override func to(_ this: StORMRow) {
        id = this.data["id"] as! Int
        level_id = this.data["level_id"] as! Int
        name = this.data["name"] as! String
    }
    
    func rows() -> [LevelModel] {
        var rows = [LevelModel]()
        for i in 0..<self.results.rows.count {
            let row = LevelModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}

class LevelTableOperationManager {
    
    static var shareManager: LevelTableOperationManager = LevelTableOperationManager()
    
    private let mysql_host: String = "0.0.0.0"
    private let mysql_user: String = "root"
    private let mysql_pwd: String = "simon0919"
    private let mysql_database: String = "TianProject"
    private let table_name: String = "account_level"
    private let mysql_port: Int32 = 3306
    private let databaseManager = DatabaseManager()
    
    
    init() {
        databaseManager.mysqlHost = mysql_host
        databaseManager.mysqlUser = mysql_user
        databaseManager.mysqlPwd = mysql_pwd
        databaseManager.mysqlDatabase = mysql_database
        databaseManager.tableName = table_name
        guard databaseManager.connectedDatabase() else {
            return
        }
    }
    
    func insertToLevelTable(level: LevelModel) -> Bool {
        let res = databaseManager.insertDatabaseSQL(tableName: table_name, key: "(level_id, name)", value: "\(level.level_id),'\(level.name)'")
        if res.success {
            return true
        }
        print("insert error tableName \(table_name), model \(level)")
        return false
    }
    
    // 查看account_level表中所有数据
    func mysqlGetHomeDataResult() -> [Dictionary<String, String>]? {
        let result = self.databaseManager.queryAllDatabaseSQL(tableName: table_name)
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

