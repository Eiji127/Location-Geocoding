//
//  ViewController.swift
//  LocationNames
//
//  Created by 白数叡司 on 2021/01/20.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        title = "Home"
        LocationManager.shared.getUserLocation { [weak self] location in //Weak selfはメモリリークを防ぐため
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.7,
                                            longitudeDelta: 0.7
                                         )
        ),
                      animated: true)
        map.addAnnotation(pin)
        
        LocationManager.shared.resolveLocationName(with: location) { [weak self] LocationName in
            self?.title = LocationName
        }
    }


}

