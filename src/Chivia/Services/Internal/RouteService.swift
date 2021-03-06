//
//  File.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/21/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Alamofire
import CoreLocation
import PromiseKit
import SwiftyJSON

class RouteService {
    
    let ROUTE_SERVICE_URL = "https://chivia.herokuapp.com/route"
    
    func get(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Promise<Route> {
        print("\(ROUTE_SERVICE_URL)?from=\(from.latitude),\(from.longitude)&to=\(to.latitude),\(to.longitude)")
        return Promise { fulfill, reject in
            Alamofire
                .request("\(ROUTE_SERVICE_URL)?from=\(from.longitude),\(from.latitude)&to=\(to.longitude),\(to.latitude)")
                .validate()
                .responseJSON { response in
                    if response.result.isSuccess, let data = response.data {
                        let route = Route(json: JSON(data: data))
                        fulfill(route)
                    }
                    else if let data = response.data {
                        let json = JSON(data: data)
                        reject(GenericError(message: json["message"].stringValue))
                    }
                    else if let err = response.error {
                        reject(err)
                    }
            }
        }
    }
    
}
