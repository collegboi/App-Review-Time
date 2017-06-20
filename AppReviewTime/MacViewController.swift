//
//  MacViewController.swift
//  AppReviewTime
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class MacViewController: NSViewController {
    
    @IBOutlet weak var macLabel: NSTextField!
    
    @IBOutlet weak var appReviewGraph: AppReviewGraph!
    
    var appViewController: AppViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appViewController = AppViewController()
        self.getMacDayValue()
    }
    
    override func viewDidAppear() {
        self.getMacRawDayValue()
    }
    
    func getMacDayValue() {
        
        appViewController?.scrapeAppReviewTime(for: .appReview, postCompleted: { (complete, data) in
            if complete {
                self.macLabel.stringValue = self.appViewController!.parseHTML(html: data, for: .mac)
            }
        })
    }
    
    func getMacRawDayValue() {
        
        appViewController?.scrapeAppReviewTime(for: .macRaw, postCompleted: { (complete, data) in
            if complete {
                let allReviews = self.appViewController?.parseHTMLRawData(html: data)!
                
                self.appReviewGraph.setChart("Mac", values: allReviews!)
            }
        })
    }
    
}
