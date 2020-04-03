import Foundation

enum GFError: String, Error {
    case invalidUserName = "Invalid username request😪"
    case unableToComplete = "Unable to complete your request. Please check your internet connection 💻🚀"
    case invalidResponse = "Invalid response from the server, Please try again 🤷"
    case invalidData = "Invalid data from the server, Please try again 🤷"
    case unableToFavorite   = "There was an error favoriting this user. Please try again. 🤷‍️"
    case alreadyInFavorites = "You've already favorited this user. 😅You must REALLY like them!"
}
