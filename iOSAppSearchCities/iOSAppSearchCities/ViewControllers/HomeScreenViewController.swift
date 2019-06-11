//
//  HomeScreenViewController.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    let indexingUC = IndexingUsecase.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        indexingUC.indexing()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
