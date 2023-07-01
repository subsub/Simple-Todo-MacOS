//
//  JiraController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

private let issueDetailPath = "/rest/api/2/issue/"

class JiraController: ObservableObject {
    static let instance = JiraController()
    
    private let preferenceController = PreferenceController.instance
    
    func loadStatuses() {
        
    }
    
    func loadIssueDetail(by id: String, _ completion: @escaping (JiraCardDetail?) -> Void) {
        guard let host = preferenceController.preference.jiraServerUrl, let auth = preferenceController.preference.jiraAuthenticationKey else {
            return
        }
        guard let url = URL(string: "\(host)\(issueDetailPath)\(id)") else { fatalError("Missing URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
           if response.statusCode == 200 {
               guard let data = data else {
                   completion(nil)
                   return
               }
               DispatchQueue.main.async {
                   let cardDetail = JiraCardDetail(from: data)
                   completion(cardDetail)
                   return
               }
           }
            completion(nil)
        }
        dataTask.resume()
    }
}
