import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dbPath: String = "users.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        createTable()
    }
    
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Base ouverte : \(fileURL.path)")
            return db
        } else {
            print(" Impossible d’ouvrir la base")
            return nil
        }
    }
    
    
    private func createTable() {
        let query = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            email TEXT UNIQUE,
            password TEXT
        );
        """
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print(" Table users prête")
            }
        }
        sqlite3_finalize(statement)
    }
    
    
    func insertUser(fullName: String, email: String, password: String) {
        let query = "INSERT INTO users (fullName, email, password) VALUES (?, ?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (fullName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print(" Utilisateur ajouté : \(email)")
            } else {
                print(" Erreur insertion utilisateur")
            }
        }
        sqlite3_finalize(statement)
    }
    
    
    func validateUser(email: String, password: String) -> Bool {
        let query = "SELECT * FROM users WHERE email = ? AND password = ?;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW {
                sqlite3_finalize(statement)
                return true
            }
        }
        sqlite3_finalize(statement)
        return false
    }
}
