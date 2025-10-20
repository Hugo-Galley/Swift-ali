import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dbPath: String = "users.sqlite"
    private var db: OpaquePointer?
    // Serial queue to ensure all sqlite access happens on the same thread/queue
    private let queue = DispatchQueue(label: "com.hugogalley.swift-ali.db")
    
    private init() {
        // Open DB and run migrations on the dedicated serial queue to avoid
        // illegal multi-threaded access to the sqlite connection.
        queue.sync {
            db = openDatabase()
            migrateIfNeeded()
            createTable()
            createOrdersTable()
        }
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
            if let err = sqlite3_errmsg(db) {
                print("Impossible d’ouvrir la base: \(String(cString: err))")
            } else {
                print(" Impossible d’ouvrir la base")
            }
            return nil
        }
    }

    private func migrateIfNeeded() {
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
            } else if let err = sqlite3_errmsg(db) {
                print("Erreur createTable users: \(String(cString: err))")
            }
        }
        sqlite3_finalize(statement)
    }

    // Création de la table orders
    private func createOrdersTable() {
        let query = """
        CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            itemsJSON TEXT,
            total REAL,
            orderDate REAL,
            deliveryDate REAL
        );
        """

        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print(" Table orders prête")
            }
        }
        sqlite3_finalize(statement)
    }

    
    func insertUser(fullName: String, email: String, password: String, profileImage: String? = nil) {
        queue.sync {
            let query = "INSERT INTO users (fullName, email, password, profileImage) VALUES (?, ?, ?, ?);"
            var statement: OpaquePointer? = nil

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (fullName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (profileImage as NSString? ?? "" as NSString).utf8String, -1, nil)

                if sqlite3_step(statement) == SQLITE_DONE {
                    print(" Utilisateur ajouté : \(email)")
                } else if let err = sqlite3_errmsg(db) {
                    print("Erreur insertion utilisateur: \(String(cString: err))")
                }
            }
            sqlite3_finalize(statement)
        }
    }
    
    func validateUser(email: String, password: String) -> Bool {
        return queue.sync {
            let query = "SELECT * FROM users WHERE email = ? AND password = ?;"
            var statement: OpaquePointer? = nil
            var found = false

            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)

                if sqlite3_step(statement) == SQLITE_ROW {
                    found = true
                }
            }
            sqlite3_finalize(statement)
            return found
        }
    }
    
    func getUserByEmail(email: String) -> User? {
        return queue.sync {
            let query = "SELECT id, fullName, email, password, profileImage FROM users WHERE email= ?;"
            var statement: OpaquePointer? = nil
            var result: User? = nil

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

                    result = User(id: id, fullName: fullName, email: email, password: password, profileImage: profileImage)
                }
            }
            sqlite3_finalize(statement)
            return result
        }
    }
    
    func updateUser(user: User) {
        queue.sync {
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
                } else if let err = sqlite3_errmsg(db) {
                    print (" Erreur update utilisateur: \(String(cString: err))")
                }
            }
            sqlite3_finalize(statement)
        }
    }


    func insertOrder(userId: Int64, itemsJSON: String, total: Double, orderDate: Date, deliveryDate: Date?) {
        let query = "INSERT INTO orders (userId, itemsJSON, total, orderDate, deliveryDate) VALUES (?, ?, ?, ?, ?);"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, userId)
            sqlite3_bind_text(statement, 2, (itemsJSON as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, total)
            sqlite3_bind_double(statement, 4, orderDate.timeIntervalSince1970)
            if let delivery = deliveryDate {
                sqlite3_bind_double(statement, 5, delivery.timeIntervalSince1970)
            } else {
                sqlite3_bind_null(statement, 5)
            }

            if sqlite3_step(statement) == SQLITE_DONE {
                print(" Commande insérée pour userId: \(userId)")
            } else {
                print(" Erreur insertion commande")
            }
        }
        sqlite3_finalize(statement)
    }

    func getOrders(forUser userId: Int64) -> [Order] {
        var orders: [Order] = []
        let query = "SELECT id, userId, itemsJSON, total, orderDate, deliveryDate FROM orders WHERE userId = ? ORDER BY orderDate DESC;"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int64(statement, 1, userId)

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int64(statement, 0)
                let uid = sqlite3_column_int64(statement, 1)
                let itemsCString = sqlite3_column_text(statement, 2)
                let itemsJSON = itemsCString != nil ? String(cString: itemsCString!) : "[]"
                let total = sqlite3_column_double(statement, 3)
                let orderDate = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
                var deliveryDate: Date? = nil
                if sqlite3_column_type(statement, 5) != SQLITE_NULL {
                    deliveryDate = Date(timeIntervalSince1970: sqlite3_column_double(statement, 5))
                }

                let order = Order(id: id, userId: uid, itemsJSON: itemsJSON, total: total, orderDate: orderDate, deliveryDate: deliveryDate)
                orders.append(order)
            }
        }
        sqlite3_finalize(statement)
        return orders
    }
}
