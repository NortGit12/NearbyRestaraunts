//
//  MapAndListViewController.swift
//  NearbyRestarants
//
//  Created by Jeff Norton on 8/31/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit
import MapKit

class MapAndListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    //==================================================
    // MARK: - General
    //==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //==================================================
    // MARK: - UITableViewDataSource
    //==================================================
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
