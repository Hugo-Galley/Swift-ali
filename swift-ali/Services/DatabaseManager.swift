import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dbPath: String = "users.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        migrateIfNeeded() // Migration AVANT la création éventuelle
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

    private func migrateIfNeeded() {
        // Vérifie si la colonne profileImage existe déjà
        let checkQuery = "PRAGMA table_info(users);"
        var statement: OpaquePointer? = nil
        var hasProfileImage = false
        
        if sqlite3_prepare_v2(db, checkQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let cString = sqlite3_column_text(statement, 1) {
                    let columnName = String(cString: cString)
                    if columnName == "profileImage" {
                        hasProfileImage = true
                        break
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        
        // Si la colonne n’existe pas, on l’ajoute
        if !hasProfileImage {
            let alterQuery = "ALTER TABLE users ADD COLUMN profileImage TEXT;"
            if sqlite3_exec(db, alterQuery, nil, nil, nil) == SQLITE_OK {
                print("Colonne profileImage ajoutée à la table users.")
            } else {
                print("Erreur lors de l’ajout de la colonne profileImage.")
            }
        }
    }
    
    private func createTable() {
        let query = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullName TEXT,
            email TEXT UNIQUE,
            password TEXT,
            profileImage TEXT
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
    
    func insertUser(fullName: String, email: String, password: String, profileImage: String? = nil) {
        let query = "INSERT INTO users (fullName, email, password, profileImage) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (fullName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (profileImage as NSString? ?? "" as NSString).utf8String, -1, nil)
        
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
    
    func getUserByEmail(email: String) -> User? {
        let query = "SELECT id, fullName, email, password, profileImage FROM users WHERE email= ?;"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text ( statement, 1, (email as NSString).utf8String, -1, nil )
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let fullName = String(cString: sqlite3_column_text(statement, 1))
                let email = String(cString: sqlite3_column_text(statement, 2))
                let password = String(cString: sqlite3_column_text(statement, 3))
                
                // profileImage peut être NULL
                var profileImage: String? = nil
                if let cProfileImage = sqlite3_column_text(statement, 4) {
                    profileImage = String(cString: cProfileImage)
                    if profileImage?.isEmpty == true { profileImage = nil }
                }
                
                sqlite3_finalize(statement)
                return User(id: id, fullName: fullName, email: email, password: password, profileImage: profileImage)
            }
        }
        sqlite3_finalize(statement)
        return nil
    }
    
    func updateUser(user: User) {
        let query =  "UPDATE users SET fullName = ?, email = ?, password = ?, profileImage = ? WHERE id = ?;"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (user.fullName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (user.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (user.password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (user.profileImage as NSString? ?? "" as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(statement, 5, user.id)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print (" Utilisateur mis à jour ")
            } else {
                print (" Erreur update utilisateur")
            }
        }
        sqlite3_finalize(statement)
    }
}
