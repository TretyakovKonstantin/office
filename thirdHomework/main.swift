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
            Cleaner().clean(dirt: office.dirt)
        } catch officeProblems.paymentInvoice {
            try office.owner.payForOffice(office: office)
        } catch officeProblems.newMailInAForeinLanguage {
            Translator().translate(mail: office.mail!)
        }
    }
    
    func addCookies(office: Office, count: Int) {
        if office.cookies == nil {
            office.cookies = []
        }
        office.cookies! += Array(0...count).map {return Cookie(in:$0)}
    }
}

class Office {
    var cookies:[Cookie]?
    private var isTerroristAttackHappening = false
    
    private(set) var officeManager:OfficeManager
    private(set) var owner:OfficeOwner

    var mail:Mail?
    var officeDebt:Int = 0
    var sink = Sink()
    var dirt = Dirt()
    
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
    
    func checkDirtLevel() throws {
        if dirt.degree > 3 {
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
    init(in: Int) {
        
    }
}

class Plumber {
    func repairSink(sink: Sink) {
        if (sink.isLeaking) {
            sink.isLeaking = false
        }
    }
}

class Cleaner {
    func clean(dirt: Dirt) {
        dirt.degree = 0
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

class Dirt {
    var degree:Int = 0
}
