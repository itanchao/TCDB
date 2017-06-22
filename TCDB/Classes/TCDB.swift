//
//  TCDB.swift
//  TCDB
//
//  Created by 谈超 on 2017/6/22.
//

import UIKit
import SQLite3

public typealias SQL = String
public enum EXECSQLMethod: String {
    /// 创建表格
    case create = "CREATE"
    /// 查询方法
    case select = "SELECT"
    /// 修改方法
    case update = "UPDATE"
    /// 删除方法
    case delete = "DELETE"
    /// 插入方法
    case insert = "INSERT"
}
public class TCDB {
    
    /// 执行语句
    ///
    /// - Parameters:
    ///   - method: 操作方法
    ///   - sql: sql语法
    ///   - onqueue: 线程
    ///   - callback: 回调
  public  class func execSql( _ method : EXECSQLMethod, sql : SQL , onqueue : DispatchQueue = dbQueue ,  callback:@escaping ((Any)->()) ){
        // 先把OC字符串转化为C字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)!
        guard method == .select else {
            onqueue.sync {
                // 执行语句
                /// 在SQLite3中，除了查询以外（创建/删除/更新）都是用同一个函数
                /*
                 1. 已经打开的数据库对象
                 2. 需要执行的SQL语句，c字符串
                 3. 执行SQL语句之后的回调，一般写nil
                 4. 是第三个参数的第一个参数，一般传nil
                 5. 错误信息，一般传nil
                 
                 SQLITE_API int SQLITE_STDCALL sqlite3_exec(
                 sqlite3*,                                  /* An open database */
                 const char *sql,                           /* SQL to be evaluated */
                 int (*callback)(void*,int,char**,char**),  /* Callback function */
                 void *,                                    /* 1st argument to callback */
                 char **errmsg                              /* Error msg written here */
                 );
                 */
                if sqlite3_exec(dbBase, cSQL, nil, nil, nil) != SQLITE_OK {
                    DispatchQueue.main.async {
                        callback(false)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(true)
                    }
                }
            }
            return
        }
        onqueue.async {
            // 先创建一个字典数组
            var dicts = [[String: Any]]()
            //创建一个对象保存预编译STMT
            var stmt :OpaquePointer? = nil
            // 执行预编译
            /**
             1、已经打开的数据库对象
             2、需要执行的SQL语句
             3、需要执行的SQL语句的长度、传入 -1 系统自动计算
             4、预编译之后的句柄，以及要想取出数据，就需要这个句柄
             5、一般传nil
             
             SQLITE_API int SQLITE_STDCALL sqlite3_prepare_v2(
             sqlite3 *db,            /* Database handle */
             const char *zSql,       /* SQL statement, UTF-8 encoded */
             int nByte,              /* Maximum length of zSql in bytes. */
             sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
             const char **pzTail     /* OUT: Pointer to unused portion of zSql */
             );
             */
            if sqlite3_prepare_v2(self.dbBase, cSQL, -1, &stmt, nil) != SQLITE_OK{
                //                print("预编译失败，请检查SQL语句")
                print("\n预编译失败，请检查SQL语句:\n\(sql)")
                DispatchQueue.main.async {
                    callback(dicts)
                }
                return
            }
            
            //如果预编译成功，那么久可以取出数据了
            //sqlite3_setp表示取出一行数据，如果返回值SQLITE_ROW标示取到了
            while sqlite3_step(stmt) == SQLITE_ROW {
                // 3.1得到每一列的数据
                let dict = self.recodeWithStmt(stmt!)
                // 3.2添加到数组中
                dicts.append(dict)
            }
            
            //一定要释放句柄
            sqlite3_finalize(stmt)
            //返回字典数组
            DispatchQueue.main.async {
                callback(dicts)
            }
            
        }
    }
    ///数据库对象
    static private var dbBase : OpaquePointer? = nil
    
    //    MARK - Child Thread
    /*
     1 一个唯一的对列名
     */
    static let dbQueue = DispatchQueue(label: "com.itc.database")
    
    /// 打开数据库
    ///
    /// - Parameter DBName: 数据库名称
    @discardableResult
    public class func openDB(DBName: String) -> Bool {
        
        //1、拿到数据库路径
        let path = DBName.documentDir()
        //打印路径，以便拿到数据文件
        print(path)
        
        //2、转化为c字符串
        let cPath = path.cString(using: String.Encoding.utf8)
        /*
         参数一：c字符串，文件路径
         参数二：OpaquePointer 一个数据库对象的地址
         
         注意Open方法的特性：如果指定的文件路径已有对应的数据库文件会直接打开，如果没有则会创建在打开
         使用Sqlite_OK判断
         sqlite3_open(cPath, &dbBase)
         */
        /*
         #define SQLITE_OK           0   /* Successful result */
         */
        if sqlite3_open(cPath, &TCDB.dbBase) != SQLITE_OK{
            print("数据库打开失败")
            return false
        }
        return true
    }
    
    /// 拿到每一列的数据
    ///
    /// - Parameter stmt: 句柄
    /// - Returns: 字典返回
    @discardableResult
    static private func recodeWithStmt(_ stmt : OpaquePointer) -> [String : Any]{
        
        //获取当前的所有列的列数，遍历取值
        let count = sqlite3_column_count(stmt)
        
        //定义一个字典保存数据
        var dict = [String : Any]()
        
        //遍历这一行的每一列
        for index in 0..<count {
            //拿到每一列的名称
            /*
             1、句柄
             2、下标
             */
            let cName = sqlite3_column_name(stmt, index)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)!
            
            // 拿到每列的类型
            let type = sqlite3_column_type(stmt, index)
            /*
             #define SQLITE_INTEGER  1
             #define SQLITE_FLOAT    2
             #define SQLITE_BLOB     4
             #define SQLITE_NULL     5
             #ifdef SQLITE_TEXT
             # undef SQLITE_TEXT
             #else
             # define SQLITE_TEXT     3
             #endif
             #define SQLITE3_TEXT     3
             */
            
            //根据类型取值
            switch type {
            case SQLITE_INTEGER: //整形
                let num = sqlite3_column_int64(stmt, index)
                dict[name] = Int(num)
                
            case SQLITE_FLOAT: //浮点型
                let double = sqlite3_column_double(stmt, index)
                dict[name] = Double(double)
                
            case SQLITE3_TEXT: //text 文本类型
                let cText = String.init(cString: sqlite3_column_text(stmt, index))
                let text = String(cString: cText, encoding: String.Encoding.utf8)!
                dict[name] = text
                
            case SQLITE_NULL: //NULL
                dict[name] = NSNull()
                
            default: //二进制类型
                print("二进制数据")
                
            }
        }
        // 返回数据
        return dict
        
    }
}
extension String{
    /**
     将当前字符串拼接到document目录后面
     */
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
}
