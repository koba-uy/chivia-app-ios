//
//  ViewController.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 10/18/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import LGButton
import MapboxDirections
import MapboxNavigation

class HomeViewController: UIViewController, HomeMapViewDelegate {

    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var homeMapView: HomeMapView!
    @IBOutlet var reportButton: LGButton!
    @IBOutlet var reportButtonConstraint: NSLayoutConstraint!
    
    private var reportButtonConstraintDefaultConstant: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        homeMapViewSetup()
        reportButtonSetup()
    }
    
    private func homeMapViewSetup() {
        homeMapView.delegate = self
    }
    
    public func homeMapView(homeMapView: HomeMapView, routeDetected route: Route) {
        //
    }
    
    public func homeMapView(homeMapView: HomeMapView, routePreferencesPanel opened: Bool) {
        reportButtonConstraint.constant = opened ? reportButtonConstraintDefaultConstant : 12.0
    }
    
    public func homeMapView(homeMapView: HomeMapView, routeReadyForNavigation route: MapboxDirections.Route) {
        present(NavigationViewController(for: route), animated: true, completion: nil)
    }
    
    private func reportButtonSetup() {
        reportButtonConstraintDefaultConstant = reportButtonConstraint.constant
        reportButtonConstraint.constant = 12.0
    }
    
    @IBAction func findBestRouteButton(_ _: UIButton) {
        destinationTextField.endEditing(true)
        findAddressCoordinatesAndSetDestination(address: destinationTextField.text!)
    }
    
    private func findAddressCoordinatesAndSetDestination(address: String) {
        ChiviaService
            .singleton()
            .geocoding
            .get(address: address)
            .then {
                self.homeMapView.setDestination(destination: $0)
            }
    }
    
}
