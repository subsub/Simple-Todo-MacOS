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
private let getCommentsPath = "/rest/api/2/issue/{issue-id}/comment?orderBy=-created"
private let getUserByAccountId = "/rest/api/2/user?accountId={account-id}"
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
    
    func loadIssueComments(by taskId: String, _ completion: @escaping ([TaskComment]?) -> Void) {
        let path = getCommentsPath.replacing("{issue-id}", with: taskId)
        guard let host = preferenceController.preference.jiraServerUrl, let url = URL(string: "\(host)\(path)") else {
            completion(nil)
            return
        }
        
        doRequest(url: url) { success, data in
            guard let data = data, success else {
                completion(nil)
                return
            }
            
            let comments = TaskComment.from(data)
            completion(comments)
        }
    }
    
    func extractCommentsBody(_ comments: [TaskComment]) async -> (Bool, [TaskComment]) {
        guard let host = preferenceController.preference.jiraServerUrl else {
            return (false, comments)
        }
        
        var isUpdated: Bool = false
        
        for comment in comments {
            guard var body = comment.body else {
                continue
            }
            body = await body.findAccountIdAndReplace(host: host, { accountid in
                return await self.getAccountDetailBy(id: accountid)?.displayName ?? accountid
            })
            body = body.findAndReplaceQuote()
                .findAndReplaceLink()
                .findAndReplaceCode()
            comment.body = body
            isUpdated = true
        }
        return (isUpdated, comments)
    }
    
    func getAccountDetailBy(id: String) async -> AccountDetail? {
        let path = getUserByAccountId.replacing("{account-id}", with: id)
        guard let host = preferenceController.preference.jiraServerUrl, let url = URL(string: "\(host)\(path)") else {
            return nil
        }
        
        let (success, data) = await doRequestAsync(url: url)
        guard let data = data, success else {
            return nil
        }
        
        return AccountDetail(from: data)
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
            
            guard let response = response as? HTTPURLResponse else {
                completion(false, nil)
                return
            }
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
    
    
    private func doRequestAsync(url: URL, method: String = "GET", body: Data? = nil) async -> (Bool, Data?) {
        guard let auth = preferenceController.preference.jiraAuthenticationKey else {
            return (false, nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return (false, nil)
            }
            if response.statusCode >= 200 && response.statusCode < 300 {
                return (true, data)
            } else {
                return (false, nil)
            }
        } catch {
            print("erroring \(error)")
            return (false, nil)
        }
        return (false, nil)
    }
}
