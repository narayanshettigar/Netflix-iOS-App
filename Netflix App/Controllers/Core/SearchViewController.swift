//
//  SearchViewController.swift
//  Netflix App
//
//  Created by Cumulations on 31/05/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()

    
    private let searchTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.indentifier)
        return table
    }()

    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or a TV show".uppercased()
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        fetchDiscoverMovies()
    
        searchController.searchResultsUpdater = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
}


extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.indentifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unknown name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else { return
        }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
                
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview!))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultsController.delegate = self
//
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    

    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {

        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
