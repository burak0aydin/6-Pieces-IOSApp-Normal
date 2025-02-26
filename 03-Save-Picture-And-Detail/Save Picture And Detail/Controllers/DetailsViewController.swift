//
//  DetailsViewController.swift
//  Save Picture And Detail
//
//  Created by Burak Aydın on 20.08.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var selectedName = ""
    var selectedUUID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDetailsImage()
        
        // Ekranın herhangi biryerine tıklanınca klavyenin kapatılmasını sağlar
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(closeTheKeyboard))
        
        // View içine ekledik klavyenin kapanma talimatını
        view.addGestureRecognizer(gestureRecognizer)
        
        //resime tıklanınca yeni resim seç komutu
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        
        // image viewe atadık resim üstteki komutu
        imageView.addGestureRecognizer(imageGestureRecognizer)
        

    }
    
    // close keybord action func
    @objc func closeTheKeyboard () {
        view.endEditing(true)
    }
    
    //resim seçme
    @objc func selectImage () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // resim seçildikten sonra kapat komutu
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        saveButton.isEnabled = true
        
        self.dismiss(animated: true)
    }

    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: context)
        
        shoppingList.setValue(nameTextField.text, forKey: "name")
        shoppingList.setValue(bodyTextField.text, forKey: "body")
        
        if let price = Int(priceTextField.text!) {
            shoppingList.setValue(price, forKey: "price")
        }
        
        // UUID() universal unique ıd oluşturacak her seferinde
        shoppingList.setValue(UUID(), forKey: "id")
        
        // image resmi dataya çeviriyor sıkıştırıyor
        let dataImage = imageView.image?.jpegData(compressionQuality: 0.5)
        shoppingList.setValue(dataImage, forKey: "image")
        
        // aldığım bilgileri core dataya en son kaydetme
        do {
            try context.save()
            print("Data has been recorded")
        }
        catch {
                print("There is an Error")
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func showDetailsImage() {
        
        // core data seçilen ürünün bilgilerini göster
        if selectedName != "" {
            saveButton.isHidden = true
            
            if let uuidString = selectedUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
                //coredatadan çekeceğim şeyleri filtreler "id = %@"
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let data = try context.fetch(fetchRequest)
                    if data.count > 0 {
                        for aData in data as! [NSManagedObject] {
                            
                            if let name = aData.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            if let price = aData.value(forKey: "price") as? Int {
                                priceTextField.text = String(price)
                            }
                            if let body = aData.value(forKey: "body") as? String {
                                bodyTextField.text = body
                            }
                            if let image = aData.value(forKey: "image") as? Data {
                                let image = UIImage(data: image)
                                imageView.image = image
                            }
                            
                                
                        }
                       
                    }

                } catch {
                    print("Error occurred while capturing data")
                }
            }
            
        } else {
            nameTextField.text = ""
            priceTextField.text = ""
            bodyTextField.text = ""
            saveButton.isEnabled = false
        }
    }
    
}
