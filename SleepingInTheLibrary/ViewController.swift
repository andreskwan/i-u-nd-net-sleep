//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        let methodParameters = [
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey:Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID:Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback]

        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters)
        
        // TODO: Write the network code here!
        let url = NSURL(string: urlString)!
        
        // I'm not going to make a request using a NSURL instead use a NSURLRequest 
        // NSURLRequest wrapps a NSURL, this allow us to have access to more request options 
        let request = NSURLRequest(URL: url)
        // request.HTTPMethod: type of the request being made - get(default), post, etc 
        // is inmutable, so if we need to change it, better use NSMutableURLRequest
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain({ () -> Void in
                    self.setUIEnabled(true)
                })
            }
            
            guard let data = data else {
                displayError("")
                return
            }
            
            // what about the error validation?
            // if error == nil {
            
            // NSJSONSerialization
            // serialize - conver an object into a stream of bytes
            // deserialize - (convert a stream of bytes into an object)
            // from data to JSON representation
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("")
                return
            }
            guard let photosDictionary = parsedResult[Constants.FlickrParameterKeys.Photos] as? [String:AnyObject] else {
                displayError("")
                return
            }
            guard let photoArray = photosDictionary["photo"] as? [[String:AnyObject]] else {
                displayError("")
                return
            }

            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
            
            guard let imageUrlString = photoDictionary[Constants.FlickrParameterKeys.MediumURL] as? String else {
                displayError("")
                return
            }
            
            guard let photoTitle = photoDictionary[Constants.FlickrParameterKeys.Title] as? String else {
                displayError("")
                return
            }
            
            let imageURL = NSURL(string: imageUrlString)
            //here is safe to unwrap imageURL with (!)
            guard let imageData = NSData(contentsOfURL: imageURL!) else {
                displayError("")
                return
            }
            
            performUIUpdatesOnMain({ () -> Void in
                self.photoImageView.image = UIImage(data: imageData)
                self.photoTitleLabel.text = photoTitle
                self.setUIEnabled(true)
            })
        }
        task.resume()
    }
    
    /// Takes a dictionary
    ///
    /// - parameters:
    ///     - dictionary:
    /// - returns: A String witch represent a list of parameters and their values needed for an API method call for a web service with only safe **ASCII** characters, each pair is separated by an ampersand, and the string begins with **?** to indicate the begining of the request
    ///
    /// - precondition: keys should be valid **ASCII** characters (keys represent names of the parameters of the url functions of the API of the web service)
    ///
    ///
    private func escapedParameters(parameters: [String:AnyObject]) -> String {
        //1 check if any parameter is provided
        if parameters.isEmpty {
            return ""
        } else { // create and array that stores each key value pair as we format it
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                // we assume that the keys are valid **ASCII** characters
                // values should be casted to Strings
                let stringValue = "\(value)"
                // escaoe it
                // convert the string into an **ASCII** compliant version of a string
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                // append it 
                // escapedValue needs to be unwrapped to avoid Optiona(\"characters\")
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        }
    }
}