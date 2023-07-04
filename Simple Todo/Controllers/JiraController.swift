//
//  JiraController.swift
//  Simple Todo
//
//  Created by Subkhan Sarif on 01/07/23.
//

import SwiftUI

private let issueDetailPath = "/rest/api/2/issue/"
private let getTransitionsPath = "/rest/api/2/issue/{issue-id}/transitions"
private let updateStatusPath = "/rest/api/2/issue/{issue-id}/transitions"
private let listAssignedTaskPath = "/rest/api/2/search?jql=assignee=currentuser() and status != done ORDER BY created DESC"

class JiraController: ObservableObject {
    static let instance = JiraController()
    
    private let preferenceController = PreferenceController.instance
    
    func loadTransition(by taskId: String, _ completion: @escaping ([JiraTransition]?) -> Void) {
        let path = getTransitionsPath.replacing("{issue-id}", with: taskId)
        
        guard let host = preferenceController.preference.jiraServerUrl, let url = URL(string: "\(host)\(path)") else {
            completion(nil)
            return
        }
        
        
        doRequest(url: url) { success, data in
            guard let data = data, success else {
                completion(nil)
                return
            }
            
            let cardDetail = JiraTransition.from(data)
            completion(cardDetail)
        }
    }
    
    func updateIssueStatus(by taskId: String, to transition: JiraTransition, _ completion: @escaping (Bool)->Void) {
        print("updating to \(transition.name)")
        let path = updateStatusPath.replacing("{issue-id}", with: taskId)
        
        guard let host = preferenceController.preference.jiraServerUrl, let url = URL(string: "\(host)\(path)") else {
            print(">> error no host/url")
            completion(false)
            return
        }
        
        let dict: [String: Any] = [
            "transition": [
                "id": transition.id
            ]
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: dict) else {
            print(">> error parse data")
            completion(false)
            return
        }
                
        doRequest(url: url, method: "POST", body: body) { success, _ in
            print(">> updateStatus doRequest completion: \(success)")
            completion(success)
        }
    }
    
    func loadIssueDetail(by id: String, _ completion: @escaping (JiraCardDetail?) -> Void) {
        guard let host = preferenceController.preference.jiraServerUrl, let url = URL(string: "\(host)\(issueDetailPath)\(id)") else {
            completion(nil)
            return
        }
        
        doRequest(url: url) { success, data in
            guard let data = data, success else {
                completion(nil)
                return
            }
            
            let cardDetail = JiraCardDetail(from: data)
            completion(cardDetail)
        }
    }
    
    private func doRequest(url: URL, method: String = "GET", body: Data? = nil, _ completion: @escaping(Bool, Data?) -> Void) {
        guard let auth = preferenceController.preference.jiraAuthenticationKey else {
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(">> erroring \(error)")
                completion(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode >= 200 && response.statusCode < 300 {
                guard let data = data else {
                    print(">> no data")
                    completion(true, nil)
                    return
                }
                DispatchQueue.main.async {
                    print(">> but true")
                    completion(true, data)
                    return
                }
            } else {
                completion(false, nil)
            }
        }
        dataTask.resume()
    }
}
