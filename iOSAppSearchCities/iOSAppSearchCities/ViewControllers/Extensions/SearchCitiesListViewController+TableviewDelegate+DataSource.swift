//
//  HomeScreenViewController+TableviewDelegate+DataSource.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

extension SearchCitiesListViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Tableview DataSource
    func setUpTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.registerCells([SearchCitiesListTableViewCell.self], bundle: Bundle.main)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.stringFromClass(SearchCitiesListTableViewCell.self), for: indexPath)
        
        if let homeScreenCell = cell as? SearchCitiesListTableViewCell,
            let cityData = self.viewModel.getCityDetail(forIndex: indexPath.row)  {
            homeScreenCell.setUp(data: cityData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getTotalCitiesCount()
    }
    
    
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.viewModel.getMapViewModel(forIndex: indexPath.row)
            .map(self.navigateToMapView(withViewModel:))
    }
    
    private func navigateToMapView(withViewModel vm: MapScreenViewModel) -> Unit {
        self.navigationController?.pushViewController(MapScreenViewController(viewModel: vm), animated: true)
        
        return Unit(symbol: "Navigated to MapView")
    }
}
