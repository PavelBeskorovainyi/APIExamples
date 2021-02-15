//
//  WeatherViewController.swift
//  ExchangeTableViewTest
//
//  Created by Павел Бескоровайный on 10.02.2021.
//

import UIKit
import PromiseKit
import TextFieldEffects


class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mainTemperatureLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    private var weatherDataFormServer: GetWeather?
    
    private var chosenCity: String?
    private var chosenUnits: String?
    private var chosenLanguage: String?
    
    private enum ChosenPicker {
        case city
        case units
        case language
    }
    private var picker = UIPickerView()
    private var podlozhka = UIImageView(image: UIImage(named: "choose"))
    
    
    @IBAction func putDataFromServerToUI(_ sender: UIButton) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.picker.delegate = self
        self.picker.dataSource = self
        
        [self.cityTextField, self.unitsTextField, self.languageTextField].forEach({
            $0?.inputView = self.picker;
            $0?.inputAccessoryView = self.toolBar;
            if $0?.isSelected == true {$0?.becomeFirstResponder(); $0?.reloadInputViews()}
        })
        self.view.addSubview(podlozhka)
        setupUnderImage()
        registerKeyboardNotifications ()
        
    }
    
    private func setupUnderImage () {
        self.podlozhka.frame = self.view.frame
        self.podlozhka.alpha = 0.9
        self.podlozhka.isHidden = true
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}

// MARK: - picker & toolbar setup
extension WeatherViewController {
    
    private var chosenPickerVariable: ChosenPicker? {
        if self.unitsTextField.isEditing {
            self.languageTextField.isUserInteractionEnabled = false
            self.cityTextField.isUserInteractionEnabled = false
            return .units }
        else if self.languageTextField.isEditing {
            self.cityTextField.isUserInteractionEnabled = false
            self.unitsTextField.isUserInteractionEnabled = false
            return  .language }
        else {
            self.languageTextField.isUserInteractionEnabled = false
            self.unitsTextField.isUserInteractionEnabled = false
            return .city }
    }
    
    private var toolBar: UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, space, saveButton], animated: false)
        return toolbar
    }
    
    @objc private func cancelButtonTapped () {
        [self.cityTextField, self.unitsTextField, self.languageTextField].forEach({$0?.resignFirstResponder(); $0?.isUserInteractionEnabled = true})
        
    }
    
    @objc private func saveDate () {
        [self.cityTextField, self.unitsTextField, self.languageTextField].forEach({$0?.resignFirstResponder(); $0?.isUserInteractionEnabled = true})
    }
}

// MARK: - picker delegate & data source
extension WeatherViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch chosenPickerVariable {
        case .city: return Cities.allCases.count
        case .units: return TemperatureUnits.allCases.count
        case .language: return Languages.allCases.count
        default: return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch chosenPickerVariable {
        case .city: return Cities.allCases[row].rawValue
        case .units: return TemperatureUnits.allCases[row].rawValue
        case .language: return Languages.allCases[row].nameInPicker
        default: return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch chosenPickerVariable {
        case .city:  chosenCity = Cities.allCases[row].rawValue
            self.cityTextField.text = chosenCity
        case .units: chosenUnits = TemperatureUnits.allCases[row].rawValue
            self.unitsTextField.text = chosenUnits
        case .language: chosenLanguage = Languages.allCases[row].rawValue
            self.languageTextField.text = chosenLanguage
        default: break
        }
    }
}

// MARK: - get data functions
extension WeatherViewController {
    private func getData () {
        firstly {
            Provider.getWeatherData(city: chosenCity ?? "London", units: chosenUnits ?? "metric", language: chosenLanguage ?? "en")
        }.done { [weak self] (response) in
            guard let self = self else {return}
            self.weatherDataFormServer = response
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                self.countryLabel.text = self.weatherDataFormServer?.sys.country ?? "country"
                self.mainTemperatureLabel.text = "temp: \(Int(self.weatherDataFormServer?.main.temp ?? 0))"
                self.minTempLabel.text = "min: \(Int(self.weatherDataFormServer?.main.tempMin ?? 0))"
                self.maxTempLabel.text = "max: \(Int(self.weatherDataFormServer?.main.tempMax ?? 0))"
                self.mainDescriptionLabel.text = self.weatherDataFormServer?.name ?? ""
                self.descriptionLabel.text = self.weatherDataFormServer?.weather.first?.weatherDescription ?? ""
                self.feelsLikeLabel.text = "feels like \(Int(self.weatherDataFormServer?.main.feelsLike ?? 0))"
            }
        }
        .catch { (error) in
            debugPrint(error.localizedDescription)
    }

    }
}
// MARK: - KEYBOARD OBSERVERS
extension WeatherViewController {
private func registerKeyboardNotifications () {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

}
    
    @objc private func keyboardWillHide() {
        self.podlozhka.isHidden = true
    }
    @objc private func keyboardWillShow () {
        self.podlozhka.isHidden = false
    }
    
    private func removeKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
