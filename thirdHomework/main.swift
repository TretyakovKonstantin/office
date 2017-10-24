import Foundation

class OfficeManager {
    func checkOffice(office: Office) throws {
        do {
            try office.getCookiesCount()
            try office.checkSink()
            try office.checkDirtLevel()
            try office.checkPayments()
            try office.checkTerroristAttack()
            try office.checkMailLanguage()
        }
        catch officeProblems.cookiesAbsence {
            addCookies(office: office, count: 15)
        } catch officeProblems.sinkLeakage {
            Plumber().repairSink(sink: office.sink)
        } catch officeProblems.dirtyOffice {
            office.cleanOffice(cleaner: Cleaner())
        } catch officeProblems.paymentInvoice {
            try office.owner.payForOffice(office: office)
        } catch officeProblems.newMailInAForeinLanguage {
            Translator().translate(mail: office.mail!)
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
    private var cookies:[Cookie]?
    private var dirtLevel = 0
    private var isTerroristAttackHappening = false
    
    private(set) var officeManager:OfficeManager
    private(set) var owner:OfficeOwner

    var mail:Mail?
    var officeDebt:Int = 0
    var sink: Sink = Sink()
    
    func checkMailLanguage() throws {
        if mail?.language != .russian {
            throw officeProblems.newMailInAForeinLanguage
        }
    }
    
    func checkTerroristAttack() throws {
        if isTerroristAttackHappening {
            throw officeProblems.actOfTerrorism
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
        if sink.isLeaking {
            throw officeProblems.sinkLeakage
        }
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
    
    init(manager: OfficeManager, owner: OfficeOwner) {
        self.officeManager = manager
        self.owner = owner
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
    func repairSink(sink: Sink) {
        if (sink.isLeaking) {
            sink.isLeaking = false
        }
    }
}

class Cleaner {
    func clean(office: Office) {
        return
    }
}

class OfficeOwner {
    var money = 10000
    func payForOffice(office:Office) throws {
        if money >= office.officeDebt {
            money -= office.officeDebt
            office.officeDebt = 0
        } else {
            throw officeProblems.paymentInvoice
        }
        
    }
}

class Translator {
    func translate(mail: Mail) {
        guard mail.language != .russian else {
            return
        }
        mail.text? = mail.text! + " Translated"
    }
}

class Mail {
    var text:String?
    var language = languages.russian
    
    enum languages {
        case russian
        case english
    }
}

class Sink {
    var isLeaking = false
}

