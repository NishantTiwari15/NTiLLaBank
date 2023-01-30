//
//  FirstViewModel.swift
//  NishantCaroselDemo
//
//  Created by webwerks on 30/01/23.
//

import Foundation
import UIKit

class ListViewModel {
    
    // MARK: - Property Declaration
    private var caroselArray = [ListModel]()
    private var listArray = [ListModel]()
    private var isSearchActive:Bool = false
    private var searchTerm: String?
    var isSearchEmpty: Bool {
        return searchTerm?.isEmpty ?? true
    }
    
    // get file path and load data
    private func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (_) {
                completion(nil)
            }
        }
    }
    
    // MARK: -  Get all the data from json file and bind with the model
    func getList(completion: @escaping (Bool) -> Void) {
        loadJsonDataFromFile("FirstJson") { (data) in
            if let json = data {
                do {
                    let list = try JSONDecoder().decode([ListModel].self, from: json)
                    self.listArray = list
                    self.caroselArray = list
                    completion(true)
                } catch {
                    completion(false)
                }
            }
        }
    }
    
    func searchText(text: String) {
        searchTerm = text
        if text == "" {
            isSearchActive = false
            listArray = caroselArray
        } else {
            isSearchActive = true
            listArray = caroselArray.filter({(($0.name?.localizedCaseInsensitiveContains(text)))!})
        }
    }
    
    func getListModel(index: Int) -> ListModel {
        return listArray[index]
    }
    
    func getListCount() -> Int {
        return listArray.count
    }
    
    func getCarouselModel(index: Int) -> ListModel {
        return caroselArray[index]
    }
    
    func getCarouselCount() -> Int {
        return caroselArray.count
    }
    
    func refreshData()  {
        listArray = caroselArray.shuffled()
    }
}
