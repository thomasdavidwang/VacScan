//
//  ScanManager.swift
//  VacScan
//
//  Created by Thomas Wang on 2/17/24.
//

import Foundation
import UIKit
import Amplify

class ScanManager: ObservableObject {
    init() {
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveScansToBackend(scans: [UIImage], provider: Provider) async{
        let encounter = Encounter(provider: provider)
        do {
            let result = try await Amplify.API.mutate(request: .create(encounter))
            switch result {
            case .success(let encounter):
                print("Successfully created todo: \(encounter)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        for scan in scans {
            if let data = scan.pngData() {
                var scan = Scan(encounter: encounter)
                scan.fileName = "\(encounter.id)/\(scan.id).png"
                let filename = getDocumentsDirectory().appendingPathComponent("\(scan.id).png")
                
                do {
                    try data.write(to: filename)
                    
                    let uploadTask = Amplify.Storage.uploadFile(
                        key: "\(encounter.id)/\(scan.id).png",
                        local: filename
                    )

                    Task {
                        for await progress in await uploadTask.progress {
                            print("Progress: \(progress)")
                        }
                    }
                } catch {
                    print("Error uploading")
                    continue
                }
                
                do {
                    let result = try await Amplify.API.mutate(request: .create(scan))
                    switch result {
                    case .success(let encounter):
                        print("Successfully created todo: \(encounter)")
                    case .failure(let error):
                        print("Got failed result with \(error.errorDescription)")
                    }
                } catch {
                    print("Error creating scan object in backend: \(error)")
                    continue
                }
            }
        }
        
        
    }
}
