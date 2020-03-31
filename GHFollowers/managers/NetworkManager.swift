import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/"

    private init() {
    }

    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        let endPoint = baseUrl + "users/\(username)/followers?per_page=100&page\(page)"

        guard let url = URL(string: endPoint) else {
            completed(nil, ErrorMessage.invalidUserName)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(nil, ErrorMessage.unableToComplete)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, ErrorMessage.invalidResponse)
                return

            }

            guard let data = data else {
                completed(nil, ErrorMessage.invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, ErrorMessage.invalidData)
            }
        }
        task.resume()
    }
}
