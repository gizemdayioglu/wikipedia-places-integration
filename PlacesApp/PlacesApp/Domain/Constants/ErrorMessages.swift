import Foundation

enum ErrorMessages {
    static var wikipediaAppNotInstalled: String {
        NSLocalizedString("error.wikipedia.app.not.installed", comment: "Wikipedia app not installed error message")
    }
    
    static var noInternetConnection: String {
        NSLocalizedString("error.no.internet.connection", comment: "No internet connection error message")
    }
}