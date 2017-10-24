import Foundation

class OfficeManager {
    func checkOffice(office: Office) throws {
        do {
            try office.getCookiesCount()
            try office.checkSink()
            try office.checkDirtLevel()
            try office.checkPayments()
        }
        catch officeProblems.cookiesAbsence {
            addCookies(office: office, count: 15)
        } catch officeProblems.sinkLeakage {
            office.repairSink(plumber: Plumber())
        } catch officeProblems.dirtyOffice {
            office.cleanOffice(cleaner: Cleaner())
        } catch officeProblems.paymentInvoice {
            try office.officeOwner?.payForOffice(office: office)
        }
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
    var officeOwner:OfficeOwner?
    private var isSinkWorks:Bool = true
    private var dirtLevel = 0
    private var _officeDebt = 0
    
    var officeDebt:Int {
        get {
            return _officeDebt
        }
    }
    
    func checkPayments() throws {
        if officeDebt > 0 {
            throw officeProblems.paymentInvoice
        }
    }
    
    func cleanOffice(cleaner: Cleaner) {
        cleaner.clean(office: self)
        dirtLevel = 0
    }
    
    func checkDirtLevel() throws {
        if dirtLevel > 3 {
            throw officeProblems.dirtyOffice
        }
    }
    
    func checkSink() throws {
        if !isSinkWorks {
            throw officeProblems.sinkLeakage
        }
    }
    
    func repairSink(plumber: Plumber) {
        plumber.repairSink(office: self)
        isSinkWorks = true
    }
    
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
}

enum officeProblems: Error {
    case paymentInvoice
    case sinkLeakage
    case dirtyOffice
    case cookiesAbsence
    case newMailInAForeinLanguage
    case actOfTerrorism
}

class Cookie {
    
}

class Plumber {
    func repairSink(office: Office) {
        return
    }
}

class Cleaner {
    func clean(office: Office) {
        return
    }
}

class OfficeOwner {
    var money:Int = 10000
    func payForOffice(office:Office) throws {
        if money >= office.officeDebt {
        money -= office.officeDebt
        office.officeDebt == 0
        } else {
            throw officeProblems.paymentInvoice
        }
        
    }
}
