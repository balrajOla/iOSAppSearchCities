//
//  MapScreenViewController.swift
//  iOSAppSearchCities
//
//  Created by Balraj Singh on 12/06/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import UIKit
import MapKit

class MapScreenViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let viewModel: MapScreenViewModel
    
    init(viewModel: MapScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String.stringFromClass(MapScreenViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = viewModel.getTitle()
        self.addInfoButton()
        self.setUpMap()
    }

    private func addInfoButton() {
        let info = UIBarButtonItem(title: "Info",
                                   style: UIBarButtonItem.Style.plain,
                                   target: self,
                                   action: #selector(infoTapped))
        navigationItem.rightBarButtonItems = [info]
    }
    
    @objc func infoTapped (sender:UIButton) {
        let aboutViewController = AboutViewController()
        let presenter = Presenter(view: aboutViewController, model: self.viewModel.getAboutModelInfo())
        aboutViewController.presenter = presenter
        self.navigationController?.pushViewController(aboutViewController, animated: true)
    }

    private func setUpMap() {
        mapView.setRegion(self.viewModel.getCurrentRegion(), animated: true)
        mapView.addAnnotation(self.viewModel.getCurrentMapPin())
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
