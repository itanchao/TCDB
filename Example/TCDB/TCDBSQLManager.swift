//
//  TCDBSQLManager.swift
//  TCDB_Example
//
//  Created by 谈超 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import TCDB
class TCDBSQLManager {
    class func openDB() {
        if TCDB.openDB(DBName: "TCDB-Example.sqlite") {
            creatTab()
        }
    }
    class func inSertPerson(name : String,sex : Bool = false , phone:String ){
        let sql = "INSERT INTO TB_EXAMPLE_FRIENDLIST (name,sex,phone) VALUES (\n"
            + "'\(name)',\(sex ? 1 : 0 ),\(phone));";
        TCDB.execSql(.insert, sql: sql) { (result) in
            let sucess = result as! Bool
            print("运行sql:\(sql)\n===>\(sucess == true ?  "成功" : "失败")")
        }
    }
    class func updatePerson( id : String , name : String? , sex : Bool , phone : String?) {
        var sql  = "UPDATE TB_EXAMPLE_FRIENDLIST SET \n"
        if name != nil {
            sql +=  " name = '\(name!)' ,"
        }
            sql +=  " sex = \(sex == true ? 1 : 0) ,"
        if phone != nil {
            sql +=  " phone = \(phone!) "
        }
            sql += "WHERE id = \(id)"
        TCDB.execSql(.update, sql: sql) { (result) in
            let sucess = result as! Bool
            print("运行sql:\(sql)\n===>\(sucess == true ?  "成功" : "失败")")
        }
    }
    class func selectPerson( str : String?,callback:@escaping (([[String : Any]])->())) {
        var sql = "SELECT * FROM TB_EXAMPLE_FRIENDLIST \n"
        if  str != nil {
            sql += "WHERE \n"
            sql += "name like \("%\(str!)%") OR \n"
            sql += "sex like \("%\(str == "男" ? 1 : 0)%") OR \n"
            sql += "phone like \("%\(str!)%") \n"
        }
        TCDB.execSql(.select, sql: sql) { (result) in
            callback(result as! [[String : Any]])
        }
    }
    class func deletePerson(_ id : String) {
        let sql = "DELETE FROM TB_EXAMPLE_FRIENDLIST \n"
            + "WHERE id=\(id);"
        TCDB.execSql(.delete, sql: sql) { (result) in
            let sucess = result as! Bool
            print("运行sql:\(sql)\n===>\(sucess == true ?  "成功" : "失败")")
        }
    }
    /// 创建表格
    private class func creatTab()  {
        //1、编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS TB_EXAMPLE_FRIENDLIST \n" +
            "(\n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT,\n" +
            "name TEXT NOT NULL,\n" +
            "sex INT DEFAULT 0,\n" +
            "phone TEXT NOT NULL);"
        // 2.执行
        TCDB.execSql(.create, sql: sql) { (result) in
            let sucess = result as! Bool
            print("运行sql:\(sql)\n===>\(sucess == true ?  "成功" : "失败")")
        }
    }

}
