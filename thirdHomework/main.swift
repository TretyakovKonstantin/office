import Foundation

class OfficeManager {
    func checkOffice(office: Office) throws {
        try office.getCookiesCount()
    }
    
    func addCookies(office: Office, count: Int) {
        var newCookies:[Cookie] = []
        for _ in 0...count {
            newCookies += [Cookie()]
        }
        office.addCookies(cookies:newCookies)
    }
}


class Office {
    private var officeManager: OfficeManager?
    private var cookies:[Cookie]?
    
    
    func getCookiesCount() throws -> (Int) {
        guard cookies != nil && cookies!.count > 0 else {
            throw officeProblems.cookiesAbsence
        }
        return cookies!.count
    }
    
    func addCookies(cookies: [Cookie]) {
        if self.cookies == nil {
            self.cookies = []
        }
        self.cookies! += cookies
    }
    
    init(manager: OfficeManager) {
        self.officeManager = manager
    }
    
    func checkOfficeProblems() {
        do {
            try officeManager?.checkOffice(office: self)
        } catch officeProblems.cookiesAbsence {
            officeManager?.addCookies(office: self, count: 15)
        } catch {
            
        }
    }
}

enum officeProblems: Error {
    case paymentInvoice
    case sinkLeakage
    case mudInTheRoom
    case cookiesAbsence
    case newMailInAForeinLanguage
    case actOfTerrorism
}

class Cookie {
    
}
