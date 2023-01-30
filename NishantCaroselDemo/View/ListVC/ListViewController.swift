//
//  ListViewController.swift
//  NishantCaroselDemo
//
//  Created by webwerks on 30/01/23.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Outlet Declaration
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var caroselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var searchview: UISearchBar!
    
    // MARK: - ViewModel Binding
    private var viewModel = ListViewModel()
    private var isAnimationInProgress = false

    // MARK: - Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setupInitialValue()
    }
    
    // MARK: - Private function declaration
    private func setupInitialValue() {
        viewModel.getList { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                    self.pageControl.numberOfPages = self.viewModel.getCarouselCount()
                    self.caroselCollectionView.reloadData()
                }
            }
        }
        self.caroselCollectionView.contentInsetAdjustmentBehavior = .never
        
    }
    
    func configuration() {
        self.searchview.delegate = self
        caroselCollectionView.collectionViewLayout = CustomCollectionViewFlowLayout()
        listTableView.separatorColor = UIColor.clear
        listTableView.rowHeight = UITableView.automaticDimension
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }
    
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
}

// MARK: - Tableview Delegate & DataSource Method
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else { return UITableViewCell() }
        
        let model = viewModel.getListModel(index: indexPath.row)
        cell.configureCell(model)
        
        return cell
    }
}

// MARK: - CollectionView Delegate & Datasource Method
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCarouselCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as? HeaderCollectionViewCell else { return UICollectionViewCell() }
        let model = viewModel.getCarouselModel(index: indexPath.item)
        cell.configureCell(model)
        return cell
    }
    
}

// MARK: - SearchBar Delegate Method
extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText(text: searchText)
        reloadTable()
    }
}

// MARK: - ScrollView method
extension ListViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = caroselCollectionView.indexPathForItem(at: center) {
            pageControl.currentPage = ip.item
            searchview.text = ""
            viewModel.refreshData()
            reloadTable()
        }
    }
}

extension ListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Check if the animation is locked or not
        if !isAnimationInProgress {
            // Check if an animation is required
            if scrollView.contentOffset.y > .zero &&
                !(self.caroselCollectionView.isHidden) {
                self.caroselCollectionView.isHidden = true
                self.pageControl.isHidden = true
                animateCollectionView()
            }
            else if scrollView.contentOffset.y <= .zero
                        && (self.caroselCollectionView.isHidden) && viewModel.isSearchEmpty {
                self.caroselCollectionView.isHidden = false
                self.pageControl.isHidden = false
                animateCollectionView()
            }
        }
    }
    
    // Animate the top view
    private func animateCollectionView() {
        // Lock the animation functionality
        isAnimationInProgress = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] (_) in
            // Unlock the animation functionality
            self?.isAnimationInProgress = false
        }
    }
}
