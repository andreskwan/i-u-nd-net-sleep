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
        let urlParameters = [
            Constants.FlickrParameterKeys.Method:Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.GalleryID:Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras:Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format:Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback:Constants.FlickrParameterValues.DisableJSONCallback]
        
        let urlGetGalleryPhotosParams = escapedParameters(urlParameters)
        let urlGetGalleryPhotos = "\(Constants.Flickr.APIBaseURL)" + urlGetGalleryPhotosParams
        
        // TODO: Write the network code here!
        let url = NSURL(string: urlGetGalleryPhotos)
        
        print("url:" + url!.absoluteString)
        //after retrieve the image
        setUIEnabled(true)
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