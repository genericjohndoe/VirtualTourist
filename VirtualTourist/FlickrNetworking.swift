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
    private let flickrAPIKey    = "535a419ca6d5279703d6202365341df6"
    private let flickrSearch    = "flickr.photos.search"
    private let format          = "json"
    private let searchRangeKM = 20
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func retrievePhotoData(pin: Pin, page: Int, completion: @escaping (_ success: Bool, _ error: String) -> Void) {
        
        let photoUrlString = "\(flickrEndpoint)?method=\(flickrSearch)&format=\(format)&api_key=\(flickrAPIKey)&lat=\(pin.latitude)&lon=\(pin.longitude)&radius=\(searchRangeKM)&per_page=25&page=\(page)"
        
        print(photoUrlString)
        
        let request = NSMutableURLRequest(url: URL(string: photoUrlString)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                completion(false, "error")
                print("error")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Your request returned a status code other than 2xx")
                print("Your request returned a status code other than 2xx")
                return
            }
            
            guard let data = data else {
                completion(false, "No data was returned by the request")
                print("No data was returned by the request")
                return
            }
            
            let range = Range(uncheckedBounds: (14, data.count - 1))
            let newData = data.subdata(in: range)
            var parsedResult: [String: Any]!
            do {
                //print("data description \(data.description)")
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: Any]
                //print("parsed result \(parsedResult)")
                let photoJson = parsedResult["photos"] as? [String:Any]
                let photoData = photoJson?["photo"] as? [[String:Any]]
                //print(photoData!)
                var index = 1
                for photo in photoData! {
                    let urlstring = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!).jpg"
                    //let url = URL(string: urlstring)
                    let newPhoto =  Photo(index: index, imageurl: urlstring, image: nil, context: self.delegate.stack.context)
                    //let newPhoto =  Photo(index: index, imageurl: urlstring, image: try Data(contentsOf: url!) as NSData, context: self.delegate.stack.context)
                    newPhoto.pin = pin
                    pin.addToPhoto(newPhoto)
                    index = index + 1
                }
                completion(true,"no error")
                return
            } catch {
                completion(false, "Could not parse the data as JSON")
                print("Could not parse the data as JSON")
                return
            }
        }
        task.resume()
        return
    }
    
    func getPhotos(url: String,completion: @escaping (_ success: Bool, _ error: String, _ data: Data?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                completion(false, "error",nil)
                print("error")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Your request returned a status code other than 2xx",nil)
                print("Your request returned a status code other than 2xx")
                return
            }
            
            guard let data = data else {
                completion(false, "No data was returned by the request",nil)
                print("No data was returned by the request")
                return
            }
            completion(true, "", data)
        }
        task.resume()
        return
    }
}
