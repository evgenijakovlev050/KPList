//
//  MoviesCollectionList.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 21.03.2024.
//

struct KPList: ResponseType {
    let category: String
    let name: String
    let slug: String
    let cover: UrlToImage
    
    static var type = "list"
}
