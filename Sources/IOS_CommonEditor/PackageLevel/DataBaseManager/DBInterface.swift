//
//  DBInterface.swift
//  AddWatermark
//
//  Created by zmobile on 22/02/22.
//

import UIKit
import Foundation
import FMDB

public class DBInterface : NSObject {
    
    static public var logger: DBLogger?
    static public var engineConfig: EngineConfiguration?
    
    public let databaseQueue = DispatchQueue(label: "DB_SERIAL_Q")
   var semaphore = DispatchSemaphore(value: 1)
    enum QueryType {
        case insert
        case update
    }
    
    var database: FMDatabase!
    var dB_fileName : String = "LogoMaker_Local.sqlite"
    var db_local_path : String
    

    var dbIsOpen: Bool {
           var isOpen = false
//           databaseQueue.sync {
        semaphore.wait()
               isOpen = database?.open() ?? false
        semaphore.signal()
//           }
           return isOpen
       }

       // ...

       var dBVersion: Int {
           get {
//               var version = 0
               databaseQueue.sync {
//                                      version = getDbVersion()
                   return getDbVersion()
               }
//               return version
               
           }
           set {
               databaseQueue.sync {
                   setDbVersion(Double(newValue))
               }
           }
       }
    
    // MARK: - INITIALISATION
    override init() {
        // assign path for database in local directory
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        self.db_local_path = documentsDirectory.appending("/\(dB_fileName)")
        if FileManager.default.fileExists(atPath: db_local_path) {
            database = FMDatabase(path: db_local_path)
        }
        super.init()
        
    }
    
    /// assigns path for database in local directory

     init(path:URL) {
         self.db_local_path =   path.appendingPathComponent(dB_fileName).path
         if FileManager.default.fileExists(atPath: db_local_path) {
             self.database = FMDatabase(path: db_local_path)
           
         }
         super.init()
        
    }
    

    
    static public func setDBLogger(logger: DBLogger, engineConfig: EngineConfiguration){
        self.logger = logger
        self.engineConfig = engineConfig
    }

    
    // MARK: - PRIVATE METHODS
    
    
    
    
   private func getDbVersion()->Int {
       
       if dbIsOpen {
//            databaseQueue.sync {
               let query = "PRAGMA user_version"
               
               // wait
               do {
                   let results = try runQuery(query, values: nil)
                   if results.next() {
                       let result = Int(results.int(forColumn: "user_version"))
                       semaphore.signal()
                       print("DB Version: \(result)")
                       return result
                   } else {
                       DBInterface.logger?.printLog("db user_version \(database.lastError)")
                       semaphore.signal()
                       return 0
                   }
               } catch   {
                   DBInterface.logger?.printLog("db user_version \(error.localizedDescription)")
                   semaphore.signal()
                   return 0
               }
           semaphore.signal()
               return 0
//           }
           
       }
       semaphore.signal()
        return 0
       
    }
    
  private  func setDbVersion(_ version: Double)  {
      if dbIsOpen {
          semaphore.signal()
//          try databaseQueue.sync {
              let query = "PRAGMA user_version = \(version)"
              
              do {
                  try updateQuery(query, values: nil)
                  semaphore.signal()
                  DBInterface.logger?.printLog("success  !! new DBVersion : \(version)")
              }
              catch {
                  DBInterface.logger?.printLog("error user_version")
                  semaphore.signal()
              }
//          }
          
      }
       
    }
    
    
    
    // MARK: - PUBLIC METHODS
    
    /// runs given query and return array of result in FMResultSet
    func runQuery(_ query : String , values : [Any]!) throws -> FMResultSet {
        var result: FMResultSet?
        if dbIsOpen {
            semaphore.wait()
            do {
                
                //                    try databaseQueue.sync {
                result = try database.executeQuery(query, values: values)
                semaphore.signal()
                //                    }
                return result!
                
                
                
            }
            catch let error {
                
                semaphore.signal()
                DBInterface.logger?.printLog("Execute Query Failed - \(error.localizedDescription)")
//                throw SwiftError.toast("Execute Query Failed - \(error.localizedDescription)")
                throw error
            }
            
        }else{
            semaphore.signal()
            DBInterface.logger?.printLog("Execute Query Failed")
//            throw SwiftError.toast("Execute Query Failed - ")
            throw NSError(domain: "DBInterface", code: -1, userInfo: [NSLocalizedDescriptionKey: "Execute Query Failed - "])
        }
        
        
    }
    
    /// runs given query and return array of result in FMResultSet
    func updateMultipleQuery(_ queries : [String] , arrayOfValues : [[Any]]?) throws {
//        var result: FMResultSet?
        if dbIsOpen {
//            try databaseQueue.sync {
                do {
                    
                    for index in 0...queries.count - 1 {
                        try database.executeUpdate(queries[index], values: arrayOfValues?[index])
                        
                    }
                                semaphore.signal()
                    
                }
                catch {
                    semaphore.signal()
//                    throw SwiftError.toast("Execute Multiple Query Failed - ")
                    DBInterface.logger?.printLog("Execute Multiple Query Failed - ")
                                      
                }
        }
    }
    
    /// runs given query and return array of result in FMResultSet
    func updateQuery(_ query : String , values : [Any]!) throws   {
//        var result: FMResultSet?
        if dbIsOpen {
            semaphore.wait()
                do {
                    
                    _ = try database.executeUpdate(query, values: values)
                                semaphore.signal()
                    return
                    
                    
                }
                catch {
                                semaphore.signal()
                    DBInterface.logger?.printLog("Update Query Failed - ")
//                    throw SwiftError.toast("Update Query Failed - ")
                }
            }
    
        
    }
    
    
    /// intserts new entry to database and return newly generated row ID
    func insertNewEntry(query : String)->Int {
        var result: Int?
        if dbIsOpen {

            semaphore.wait()
                if database.executeStatements(query) {
                   
                    result = Int(database.lastInsertRowId)
                    semaphore.signal()
                    return result!

                    }
            semaphore.signal()
                return 0

        }
       
        return 0
    }
    
    
    /// intserts new entry to database and return newly generated row ID
    func insertMultipleNewEntry(queries : [String])->Bool {
       
        if dbIsOpen {
            semaphore.wait()
            
                for query in queries {
                    let didSuccedd =  database.executeStatements(query)
                    if !didSuccedd {
                      semaphore.signal()
                        return false
                    }
                }
                
            semaphore.signal()
                return true
            }
        
        semaphore.signal()
        return false
    }
    
 
    
    
    
    func buildInsertQueryFor(tableName : String , tableColumnNames : String , tableColoumnValues : String ) -> String {
        semaphore.wait()
        var result: String?
         result =  "insert into \(tableName) (\(tableColumnNames)) values (\(tableColoumnValues));"
        semaphore.signal()
            return result!
    }
    
    
    
    func executeQuery(query: String) -> Bool {
         var success = false
         if dbIsOpen {
             semaphore.wait()
             defer {
                 semaphore.signal()
             }
             if database.executeStatements(query) {
                 success = true
             } else {
                 print("Error executing query: \(query)")
             }
         } else {
             print("Database is not open.")
         }
         return success
     }
   
    
}


