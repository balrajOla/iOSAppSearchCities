//
//  HomeScreenTableViewCell.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

class SearchCitiesListTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(data: City) {
        self.cityLabel.text = "City: \(data.detail.name), "
        self.countryLabel.text = "Country: \(data.detail.country)"
        self.coordinateLabel.text = "Latitude: \(data.detail.coordinate.lat), Longitude: \(data.detail.coordinate.lon)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
