//
//  FlickrNetworking.swift
//  VirtualTourist
//
//  Created by joel johnson on 9/2/17.
//  Copyright © 2017 joel johnson. All rights reserved.
//

import Foundation
import UIKit

class FlickrNetworking{
    static let sharedInstance = FlickrNetworking()
    private let flickrEndpoint  = "https://api.flickr.com/services/rest/"
    private let flickrAPIKey    = "535a419ca6d5279703d6202365341df6 "
    private let flickrSearch    = "flickr.photos.search"
    private let format          = "json"
    private let searchRangeKM = 20
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func retrievePhotoData(latitude: Double, longitude: Double, completion: @escaping (_ success: Bool, _ error: String, _ photos:[Photo]?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(flickrEndpoint)?method=\(flickrSearch)&format=\(format)&api_key=\(flickrAPIKey)&lat=\(latitude)&lon=\(longitude)&radius=\(searchRangeKM)")!)
        print("\(flickrEndpoint)?method=\(flickrSearch)&format=\(format)&api_key=\(flickrAPIKey)&lat=\(latitude)&lon=\(longitude)&radius=\(searchRangeKM)")
        let session = URLSession.shared
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                completion(false, "error", nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Your request returned a status code other than 2xx", nil)
                return
            }
            
            guard let data = data else {
                completion(false, "No data was returned by the request", nil)
                return
            }
            
            var parsedResult: [String:Any]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let photoJson = parsedResult["photos"] as? [String:Any]
                let photoData = photoJson?["photo"] as? [[String:Any]]
                var index = 1
                for photo in photoData! {
                    let urlstring = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!).jpg"
                    let url = URL(string: urlstring)
                    //let data = try Data(contentsOf: url!)
                    Photo(index: index, imageurl: urlstring, image: try Data(contentsOf: url!) as NSData, context: self.delegate.stack.context)
                    index = index + 1
                }

            } catch {
                completion(false, "Could not parse the data as JSON", nil)
                return
            }
            return
        }
        
    }
}
