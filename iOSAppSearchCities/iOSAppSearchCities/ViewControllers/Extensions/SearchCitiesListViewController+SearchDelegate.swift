//
//  HomeScreenViewController+SearchDelegate.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 11/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

extension SearchCitiesListViewController: UISearchBarDelegate {
    func setUpSearch() {
        self.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Loader.show(blockingLoader: false)
        self.viewModel.search(forKeyword: searchText.lowercased())
            .observe { result in
                
                self.checkAndResetDetailView()
                _ = result.mapError(self.handleError(error:))
                _ = result.map(self.handleSuccess(success:))
        }
    }
    
    private func checkAndResetDetailView() {
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            DispatchQueue.main.async {
                // reset the selected value
                self.showDetailViewController(NothingSelectedViewController(nibName: String.stringFromClass(NothingSelectedViewController.self), bundle: Bundle.main), sender: nil)
            }
        default:
            break
        }
    }
    
    private func handleSuccess(success: Bool) -> Bool {
        reloadAndHide()
        return success
    }
    
    private func handleError(error: Error) -> Error {
        (error as? HomeScreenViewModelError)
            .flatMap { err -> Void in
                if err == .noData
                {
                    reloadAndHide()
                }
        }
        
        return error
    }
    
    private func reloadAndHide() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            Loader.hide()
        }
    }
}
