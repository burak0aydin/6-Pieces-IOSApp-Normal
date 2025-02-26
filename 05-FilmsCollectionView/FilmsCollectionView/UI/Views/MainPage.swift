//
//  ViewController.swift
//  FilmsCollectionView
//
//  Created by Burak Aydın on 19.09.2023.
//

import UIKit

class MainPage: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    var filmsList = [Films]()

    // Called when the view is loaded.
    // Görünüm yüklendiğinde çağrılır.
    override func viewDidLoad()
    {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        // Adding film objects to the list.
        // Film nesnelerini listeye ekler.
        let f1 = Films(id: 1, name: "Django", image: "django", price: 24)
        let f2 = Films(id: 2, name: "Interstellar", image: "interstellar", price: 32)
        let f3 = Films(id: 3, name: "Inception", image: "inception", price: 16)
        let f4 = Films(id: 4, name: "The Hateful Eight", image: "thehatefuleight", price: 28)
        let f5 = Films(id: 5, name: "The Pianist", image: "thepianist", price: 18)
        let f6 = Films(id: 6, name: "Anadoluda", image: "anadoluda", price: 10)

        filmsList.append(contentsOf: [f1, f2, f3, f4, f5, f6])

        designOfCollectionView()
    }
}

extension MainPage: UICollectionViewDelegate, UICollectionViewDataSource, cellProtocol
{
    // Returns the number of items in the section.
    // Bölümdeki öğe sayısını döndürür.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return filmsList.count
    }

    // Configures and returns a cell for a given index path.
    // Belirtilen index path için bir hücreyi yapılandırır ve döndürür.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let film = filmsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmsCell", for: indexPath) as! filmsCell

        cell.filmsImageView.image = UIImage(named: film.image!)
        cell.filmsPriceTextLabe.text = "\(film.price!) ₺"

        // Cell styling.
        // Hücre tasarımı.
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor(white: 0.96, alpha: 1)

        cell.cellProtocol = self
        cell.indexPath = indexPath

        return cell
    }

    // Configures the layout of the collection view.
    // Koleksiyon görünümünün düzenini yapılandırır.
    func designOfCollectionView()
    {
        let design = UICollectionViewFlowLayout()
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.minimumInteritemSpacing = 10
        design.minimumLineSpacing = 10

        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2

        design.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.65)
        collectionView.collectionViewLayout = design
    }

    // Handles item selection and navigates to the detail page.
    // Öğeye tıklandığında detay sayfasına yönlendirme işlemi.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let film = filmsList[indexPath.row]
        print("\(film.name!)")
        performSegue(withIdentifier: "toDetailsVC", sender: film)
    }

    // Prepares data before navigating to the detail page.
    // Detay sayfasına gitmeden önce verileri hazırlar.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toDetailsVC", let film = sender as? Films
        {
            let toVC = segue.destination as! DetailsPage
            toVC.film = film
        }
    }

    // Adds a selected film to the list.
    // Seçilen filmi listeye ekler.
    func addToList(indexPath: IndexPath)
    {
        let film = filmsList[indexPath.row]
        print("\(film.name!) added to list")
    }
}
