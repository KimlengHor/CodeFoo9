//
//  Service.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/9/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit

class Service {
    
     static let shared = Service()
    
    func fetchTheData(completion: @escaping ([DataResults], Error?) -> ()) {
        let urlString = "https://ign-apis.herokuapp.com/content?startIndex=30&count=15"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch data ", error)
                completion([], nil)
                return
            }
            
            guard let data = data else { return }
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(results.data, nil)
            } catch let error {
                print("Failed to decode ", error)
                completion([], nil)
            }
            }.resume()
    }
    
    func fetchTheComment(idsString: String, completion: @escaping ([Content], Error?) -> ()) {
        let urlString = "https://ign-apis.herokuapp.com/comments?ids=\(idsString)"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch comments ", error)
                completion([], nil)
                return
            }
            
            guard let data = data else { return }
            do {
                let comments = try JSONDecoder().decode(CommentResult.self, from: data)
                completion(comments.content, nil)
            } catch let error {
                print("Failed to decode ", error)
                completion([], nil)
            }
            }.resume()
    }
}
