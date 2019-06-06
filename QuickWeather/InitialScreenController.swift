//
//  InitialScreenController.swift
//  QuickWeather
//
//  Created by m2sar on 29/05/2019.
//  Copyright © 2019 m2sar. All rights reserved.
//

import UIKit

class InitialScreenController: UIViewController {

    
    @IBAction func goToSearch() {
        self.performSegue(withIdentifier: "SearchSegue", sender: self)
    }
    @IBAction func goToFavorites() {
        self.performSegue(withIdentifier: "FavoriteSegue", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
