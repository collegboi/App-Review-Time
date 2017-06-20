//
//  MacViewController.swift
//  AppReviewTime
//
//  Created by Timothy Barnard on 20/06/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

class MacViewController: UIViewController {
    
    @IBOutlet weak var macLabel: UILabel!
    @IBOutlet weak var graphView: ReviewGraphView!
    
    var appViewController: AppViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.graphView.drawGraph()
        appViewController = AppViewController()
        
        self.loadLabel()
        self.loadGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func loadLabel() {
        
        appViewController?.scrapeAppReviewTime(for: .appReview, postCompleted: { (complete, htmtl) in
            if complete {
                self.macLabel.text = "Mac " + self.appViewController!.parseHTML(html: htmtl, for: .mac)
            }
        })
    }
    
    func loadGraph() {
        
        appViewController?.scrapeAppReviewTime(for: .macRaw, postCompleted: { (complete, html) in
            if complete {
                let reviews = self.appViewController!.parseHTMLRawData(html: html)!
                self.graphView.setChart("Mac", values: reviews!)
            }
        })
    }

}
