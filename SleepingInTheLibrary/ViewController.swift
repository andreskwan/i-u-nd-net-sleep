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
        let urlGetGalleryPhotos = "\(Constants.Flickr.APIBaseURL)?" +
            "\(Constants.FlickrParameterKeys.Method)=\(Constants.FlickrParameterValues.GalleryPhotosMethod)&" +
            "\(Constants.FlickrParameterKeys.GalleryID)=\(Constants.FlickrParameterValues.GalleryID)&" +
            "\(Constants.FlickrParameterKeys.Extras)=\(Constants.FlickrParameterValues.MediumURL)&" +
            "\(Constants.FlickrParameterKeys.Format)=\(Constants.FlickrParameterValues.ResponseFormat)&" +
            "\(Constants.FlickrParameterKeys.NoJSONCallback)=\(Constants.FlickrParameterValues.DisableJSONCallback)"
        
        // TODO: Write the network code here!
        let url = NSURL(string: urlGetGalleryPhotos)
        
        print("url:" + url!.absoluteString)
        //after retrieve the image
        setUIEnabled(true)
    }
}