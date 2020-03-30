import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/"

    private init() {
    }

    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endPoint = baseUrl + "users/\(username)/followers?per_page=100&page\(page)"

        guard let url = URL(string: endPoint) else {
            completed(nil, "Error at url request😪")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(nil, "Unable to complete your request. Please check your internet connection")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server, Please try again 🤷")
                return

            }

            guard let data = data else {
                completed(nil, "Invalid data from the server, Please try again 🤷")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "Unable to complete your request. Please check your internet connection")
            }
        }
        task.resume()
    }
}
