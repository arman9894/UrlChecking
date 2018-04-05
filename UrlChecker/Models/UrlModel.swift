//
//  UrlModel.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/5/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UrlModel: NSObject {

    enum UrlStatus: Int {
        case unknown, valid, invalid, checking
    }

    var urlAddress: String
    var status = UrlStatus.unknown
    var requestDuration: Double = 0
    
    init(url: String) {
        urlAddress = url
    }
}

extension UrlModel {

    func checkStatus(completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: urlAddress) else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3.0
        
        status = UrlStatus.checking

        let startDate = Date()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.requestDuration = -startDate.timeIntervalSinceNow
            if let error = error {
                print("\(error.localizedDescription)")
                self.status = UrlStatus.invalid
                completion(false)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                self.status = UrlStatus.valid
                completion(true)
            }
        }
        task.resume()
    }
}
