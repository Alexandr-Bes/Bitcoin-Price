//
//  PriceViewController.swift
//  BitcoinPrice
//
//  Created by Alexandr on 1/31/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PriceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    let firstURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    var currencySelected = ""


    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.delegate = self
        currencyPicker.dataSource = self

        getBitcoinPrice(url: firstURL)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        getBitcoinPrice(url: finalURL)

    }


        //MARK: - Networking
        /***************************************************************/

        func getBitcoinPrice(url: String) {

            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {

                        let priceJSON: JSON = JSON(response.result.value!)

                        self.updatePriceBTC(json: priceJSON)

                    } else {
                        print("Error: \(String(describing: response.result.error))")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                }

        }




        //MARK: - JSON Parsing
        /***************************************************************/

        func updatePriceBTC(json: JSON) {

            if let priceResult = json["ask"].double {
                bitcoinPriceLabel.text = currencySelected + String(priceResult)
            } else {
                bitcoinPriceLabel.text = "Price Unavailable"
            }

        }



}

