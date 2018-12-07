//
//  protocols.swift
//  LetsBuild
//
//  Created by vir on 01/12/18.
//  Copyright © 2018 vir. All rights reserved.
//
import UIKit
import Foundation

public extension FileManager {
	static var documentsDirectoryURL: URL {
		return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}
}

public protocol FileDownloader {
	
	func ImageDownload(serverURL: URL, localURL: URL) -> Bool
	func ImageDownload(serverURL: URL, fileNameWithExtension cacheName: String) -> Bool
	func ImageDownload(serverURL: URL, localFolder: String, GlobalDirectory directory: FileManager.SearchPathDirectory, fileNameWithExtension fileName: String) -> Bool
}

public extension FileDownloader {
	
	func ImageDownload(serverURL: URL, fileNameWithExtension cacheName: String) -> Bool {
		let didDownload = ImageDownload(serverURL: serverURL, fileNameWithExtension: "profilePic.png")
		return didDownload
	}
	
	func ImageDownload(serverURL: URL, localFolder: String = "FileDownloader", GlobalDirectory directory: FileManager.SearchPathDirectory = .cachesDirectory , fileNameWithExtension fileName: String = "ImageDownload.png") -> Bool {
		
		print(#function)
		let dataDownloaded = try? Data(contentsOf: serverURL)
		
		guard let data = dataDownloaded, let image = UIImage(data: data) else {
			return false
		}
		guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
			return false
		}
		let fileManager = FileManager.default
		
		let localURL = fileManager.urls(for: directory, in: .userDomainMask)[0].appendingPathComponent(localFolder).appendingPathComponent(fileName)
		try? fileManager.createDirectory(at: localURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		try? imageData.write(to: localURL, options: .atomic)
		
		return true
	}
/// MARK - Deprecated method
	func ImageDownload(serverURL: URL, localURL: URL) -> Bool {
		print(#function)
		let dataDownloaded = try? Data(contentsOf: serverURL)
		
		let fileManager = FileManager.default
		
		guard let data = dataDownloaded, let image = UIImage(data: data) else {
			return false
		}
		guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
			return false
		}
		try? fileManager.createDirectory(at: localURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		try? imageData.write(to: localURL, options: .atomic)
		
		return true
		}
}

extension UIImageView: FileDownloader {
	
	func setImage(localFolder: String = "FileDownloader", GlobalDirectory directory: FileManager.SearchPathDirectory = .cachesDirectory , fileNameWithExtension fileName: String = "ImageDownload.png") {
		
		let localURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0].appendingPathComponent(localFolder).appendingPathComponent(fileName)
		image = UIImage(contentsOfFile: localURL.path)
		isHidden = false
	}
	
///	This function takes ServerURL into consideration, and downloads too
	func setImage(serverURL: URL, localFolder: String = "FileDownloader", GlobalDirectory directory: FileManager.SearchPathDirectory = .cachesDirectory , fileNameWithExtension fileName: String = "ImageDownload.png") {
		
		_ = ImageDownload(serverURL: serverURL, localFolder: localFolder, GlobalDirectory: directory, fileNameWithExtension: fileName)
		let fileManager = FileManager.default
		let localURL = fileManager.urls(for: directory, in: .userDomainMask)[0].appendingPathComponent(localFolder).appendingPathComponent(fileName)
		
		setImage(localURL: localURL)
	}
	///	Deprecated methods
	func setImage(localURL: URL) {
		image = UIImage(contentsOfFile: localURL.path)
		isHidden = false
	}
	func setImage(fileNameWithExtension cacheName: String) {
		let localURL = FileManager.documentsDirectoryURL.appendingPathComponent("cache").appendingPathComponent(cacheName)
		image = UIImage(contentsOfFile: localURL.path)
		isHidden = false
	}
}
