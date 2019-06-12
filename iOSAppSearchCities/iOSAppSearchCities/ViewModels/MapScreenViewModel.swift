//
//  MapScreenViewModel.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import MapKit

class MapScreenViewModel {
    let cityDetails: CityDetail
    let mapRegionSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let newPin = MKPointAnnotation()
    
    init(cityDetail detail: CityDetail) {
        self.cityDetails = detail
    }
    
    func getTitle() -> String {
        return cityDetails.name
    }
    
    func getCurrentRegion() -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: cityDetails.coordinate.lat, longitude: cityDetails.coordinate.lon)
        let region = MKCoordinateRegion(center: center, span: mapRegionSpan)
        
        return region
    }
    
    func getCurrentMapPin() -> MKPointAnnotation {
        let center = CLLocationCoordinate2D(latitude: cityDetails.coordinate.lat, longitude: cityDetails.coordinate.lon)
        newPin.coordinate = center
        return newPin
    }
}
