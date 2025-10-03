import Foundation

struct User : Identifiable {
    let id: Int64
    var fullName: String
    var email: String
    var password: String
    var profileImage: String?
}
 
