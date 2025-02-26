//
//  ViewController.swift
//  mapApp
//
//  Created by Burak Aydın on 3.09.2023.
//

import UIKit
import MapKit //Haritaların çalışması için haritaların kütüphanesi "Mapkit" import ederiz ve "MKMapViewDelegate" şeklinde delegasyonuda yaparız
import CoreLocation //kullanıcadan konum almak için "CoreLocation" import ederiz ve "CLLocationManagerDelegate" ile delegasyonu yaparız
import CoreData

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var locationNoteTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager() // konum yöneticisi
    var latitudeOfTouchedPoint = Double()
    var longitudeOfTouchedPoint = Double()
    
    var selectedName = ""
    var selectedId : UUID?
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegasyonları ViewControllera bildirdik
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // konumu en iyi şekilde bulur
        locationManager.requestWhenInUseAuthorization() // uygulama açıkken konumu kullanır
        locationManager.startUpdatingLocation() // konumu günceller sürekli
        
        // basılı tuttma komutunu ve kordinatları mapview içine entegre ettik
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
        
       
        if selectedName != "" { //core datadan filtreli datayı çektik
            if let uuidString = selectedId?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
                fetchRequest.predicate = NSPredicate(format: "id =%@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            
                            if let name = result.value(forKey: "name") as? String {
                                annotationTitle = name
                                
                                if let note = result.value(forKey: "note") as? String {
                                    annotationSubtitle = note
                                    
                                    if let latitude = result.value(forKey: "latitude") as? Double {
                                        annotationLatitude = latitude
                                        
                                        if let longitude = result.value(forKey: "longitude") as? Double {
                                            annotationLongitude = longitude
                                            
                                            let annotation = MKPointAnnotation()
                                            annotation.title = annotationTitle
                                            annotation.subtitle = annotationSubtitle
                                            let cordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                            annotation.coordinate = cordinate
                                            
                                            mapView.addAnnotation(annotation)
                                            locationNameTextField.text = annotationTitle
                                            locationNoteTextField.text = annotationSubtitle
                                            
                                            locationManager.stopUpdatingLocation()
                                            
                                            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            let region = MKCoordinateRegion(center: cordinate, span: span)
                                            mapView.setRegion(region, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    
                }
            }
        } else { // yeni veri eklemeye geldi
            
        }
    }
    
    // haritada işaretli noktaların nasıl gözükeceğini özelleştirdik
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "myAnnotationId"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if selectedName != "" {
            
           let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarkArray, error) in
                
                if let placemarks = placemarkArray {
                    if placemarks.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemarks[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.annotationTitle
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }

            }
        }
    }
    
    //basılı ttuğumuz konumu kordinatlara çevirdik
    @objc func chooseLocation (gestureRecognizer : UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: mapView)
            let coordinateOfTheTouchedPoint = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
            latitudeOfTouchedPoint = coordinateOfTheTouchedPoint.latitude
            longitudeOfTouchedPoint = coordinateOfTheTouchedPoint.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinateOfTheTouchedPoint
            annotation.title = locationNameTextField.text
            annotation.subtitle = locationNoteTextField.text
            mapView.addAnnotation(annotation)
        }
            }
    
    //kullanıcının enlem ve boylam bilgilerini alır
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if selectedName == "" {
            let location = CLLocationCoordinate2D(
                latitude: locations[0].coordinate.latitude,
                longitude: locations[0].coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // konumu göstereceğim alanın büyüklüğü ,ne kadar zoomlayacak belirler
            let region = MKCoordinateRegion(center:location, span: span) // nerenin konumunu göstereceğini belirler
            mapView.setRegion(region, animated: true) // haritada konumu göster komutu
            
        }

    }
    

    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)
        
        newLocation.setValue(locationNameTextField.text, forKey: "name")
        newLocation.setValue(locationNoteTextField.text, forKey: "note")
        newLocation.setValue(latitudeOfTouchedPoint, forKey: "latitude")
        newLocation.setValue(longitudeOfTouchedPoint, forKey: "longitude")
        newLocation.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("veriler kaydedildi")
        } catch {
            print("hata")
        }
        
        // konumları kaydettikden sonra anlık tableviewda gözükmesi için yaptığımız 1. işlem
        NotificationCenter.default.post(name: NSNotification.Name("createdTheNewLocation"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    

    

    

}

