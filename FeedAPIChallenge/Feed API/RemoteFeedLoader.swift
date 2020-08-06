//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            switch result {
            case let .success((data, response)):
                completion((self?.mapSuccessResult(data, response))!)
            default:
                completion(.failure(Error.connectivity))
                break
            }
        }
    }
    
    private func mapSuccessResult(_ data: Data, _ response: HTTPURLResponse) -> FeedLoader.Result {
        guard response.statusCode == 200, let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return .failure(Error.invalidData)
        }
        return .success([])
    }
}
