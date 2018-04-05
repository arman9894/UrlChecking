//
//  UrlModel.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/5/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

enum UrlStatus: Int32 {
    case unknown, valid, invalid, checking
}

extension UrlManagedModel {

    func checkStatus(completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: urlAddress ?? "") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3.0
        
        status = UrlStatus.checking.rawValue

        let startDate = Date()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.requestDuration = -startDate.timeIntervalSinceNow
            if let error = error {
                print("\(error.localizedDescription)")
                self.status = UrlStatus.invalid.rawValue
                completion(false)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                self.status = UrlStatus.valid.rawValue
                completion(true)
            }
        }
        task.resume()
    }
}
