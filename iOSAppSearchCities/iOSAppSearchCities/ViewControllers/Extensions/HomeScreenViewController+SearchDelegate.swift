//
//  HomeScreenViewController+SearchDelegate.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UISearchBarDelegate {
    func setUpSearch() {
        self.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Loader.show(blockingLoader: false)
        self.viewModel.search(forKeyword: searchText)
            .observe {
                switch $0 {
                case .success(_):
                    // When search completes reload the table
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        Loader.hide()
                    }
                case .failure(_):
                    break
                }
        }
    }
}
