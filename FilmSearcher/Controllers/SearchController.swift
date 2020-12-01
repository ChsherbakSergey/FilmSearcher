//
//  ViewController.swift
//  FilmSearcher
//
//  Created by Sergey on 12/1/20.
//

import UIKit
import SafariServices

class SearchController: UIViewController {
    
    //Views that will be displayed on this controller
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
//        field.borderStyle = .roundedRect
        field.borderStyle = .none
        field.textColor = .label
        field.placeholder = "Search for a movie..."
//        field.layer.borderWidth = 1
//        field.layer.borderColor = UIColor.label.cgColor
        field.layer.cornerRadius = 10
        return field
    }()
    
    private let noFilmsView = NoFilmsView()
    
    //Constants and variables
    var movies = [Movie]()
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the textField
        textField.frame = CGRect(x: 25,
                                 y: view.safeAreaInsets.top + 10,
                                 width: view.frame.size.width - 50,
                                 height: 52)
        //Frame of the tableView
        tableView.frame = CGRect(x: 0, y: textField.frame.origin.y + textField.frame.size.height + 30, width: view.frame.size.width, height: view.frame.size.height - 10 - 52 - 30)
        layoutNoNotificationView()
    }

    ///Sets initial UI
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding Subviews
        view.addSubview(tableView)
        view.addSubview(textField)
        view.addSubview(noFilmsView)
    }
    
    ///Sets the layout of noFilmsView
    private func layoutNoNotificationView() {
//        tableView.isHidden = true
        noFilmsView.frame = CGRect(x: 0, y: 0, width: view.width / 2, height: view.height / 5)
        noFilmsView.center = view.center
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
    }
    
    private func searchForMovies() {
        //To hide the keyboard
        textField.resignFirstResponder()
        //Check for the text of the textField
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        movies.removeAll()
        textField.text = ""
        
//        https://www.omdbapi.com/?apikey=330741c4&s=\(query)&type=movie)
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = URL(string: "https://www.omdbapi.com/?apikey=330741c4&s=\(query)&type=movie")
        guard let url = urlString else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error while getting url occured")
                return
            }
            
            //Convert
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("Error converting")
            }
            
            guard let finalResult = result else {
                return
            }
            
            //Append data to movies array
            let newMovies = finalResult.Search
            self?.movies.append(contentsOf: newMovies)
            
            //Reload data
            DispatchQueue.main.async {
                self?.noFilmsView.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
            
        }).resume()
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Realization

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configureCell(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //show details about the movie
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        presentSafariVC(with: url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    ///Presents Safari VC to be able to see anything with a provided url
    private func presentSafariVC(with url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

//MARK: - UITextFieldDelegate Realization

extension SearchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchForMovies()
        return true
    }
    
}
