//
//  HomeScreenViewController.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 09/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet weak var indexingLbl: UILabel!
    
    let indexingUC = IndexingUsecase.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        indexingLbl.isHidden = false
        indexingUC.indexing()
            .observe {_ in
                DispatchQueue.main.async {
                   self.indexingLbl.isHidden = true
                }
        }
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
