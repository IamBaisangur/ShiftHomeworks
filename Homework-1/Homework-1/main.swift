import Foundation

struct Car: CustomStringConvertible {
    
    var description: String {
        """
        марка: \(manufacturer)
        модель: \(model)
        кузов: \(body.rawValue)
        год выпуска: \(yearOfIssue?.description ?? "-")
        \(carNumber != nil ? "номер: \(carNumber ?? "" )" : "")
        """
    }
    
    enum EnumBody: String, CaseIterable {
        case sedan = "Седан"
        case universal = "Универсал"
        case hatchback = "Хэтчбек"
        case unknown = "не известно"
    }
    
    var manufacturer: String
    var model: String
    var body: EnumBody
    var yearOfIssue: Int?
    var carNumber: String?
}

var allCars: [Car] = [
    Car(manufacturer: "Toyota", model: "Prius", body: .hatchback, yearOfIssue: 2016, carNumber: "а23уа"),
    Car(manufacturer: "Tesla", model: "Model X", body: .hatchback, yearOfIssue: nil, carNumber: nil)]

func printAllCars(allCars: [Car]){
    
    print("")
    allCars.forEach { print( $0, "\n")}
        
}

func correctReadLine(message: String) -> String {
    
    repeat{
        print(message)
        if let parameter = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), parameter.isEmpty == false {
            return parameter
        }
    } while true
}

func anyDataReadLine(message: String) -> String? {
    
    print(message)
    let data = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
    return data?.isEmpty ?? true ? nil : data
}

func getBody() -> Car.EnumBody {

    let bodyList = buildBodyList()
    var correctBody: String
    var index = 0
    repeat {
        correctBody = correctReadLine(message: bodyList)
        index = Int(correctBody) ?? Car.EnumBody.allCases.count + 1 // если оставить 0, то при вводе текста, сохраняется с нулевым индексом т.е. "Седан"
        
        if Int(correctBody) == nil {
            continue
        }
        
    } while index >= Car.EnumBody.allCases.count || index < 0

    return Car.EnumBody.allCases[index]
}

func buildBodyList() -> String {

    var bodyType = "Тип кузова:"

    for (index, body) in Car.EnumBody.allCases.enumerated(){
        bodyType += "\n\(index) - \(body.rawValue)"
    }
    return bodyType
}

func createNewCar(){
    
    let manufacturer = correctReadLine(message: "Введите марку")
    let model = correctReadLine(message: "Введите модель")
    let body = getBody()
    
    let yearOfIssue: Int?
    if let year = anyDataReadLine(message: "Введите год выпуска"){
        yearOfIssue = Int(year)
    } else {
        yearOfIssue = nil
    }
    
    let carNumber = anyDataReadLine(message: "Введите номер автомобиля")

    let newCar = Car(manufacturer: manufacturer,
                     model: model,
                     body: body,
                     yearOfIssue: yearOfIssue,
                     carNumber: carNumber)

    allCars.append(newCar)
}

func filterByBodyCar(){
    
    let body = getBody()
    let filteredCars = allCars.filter {
        car in car.body == body
    }
    printAllCars(allCars: filteredCars)
}

var menuPoint: Int

repeat {
    print(
        """
        Меню:
        1 - Добавление нового автомобиля
        2 - Вывод списка автомобилей
        3 - Вывод списка автомобилей с использованием фильтра по типу кузова автомобиля
        """)
    menuPoint = Int(readLine() ?? "0") ?? 0
    
    switch menuPoint{
    case 1:
        print("Выполняем добавление авто")
        createNewCar()
        menuPoint = 0
    case 2:
        print("Выполняем просмотр существующих авто")
        printAllCars(allCars: allCars)
        menuPoint = 0
    case 3:
        print("Выполняем просмотр автомобилей с фильтром по типу кузова")
        filterByBodyCar()
        menuPoint = 0
    default:
        print("Введите число соответствующее пунктам меню")

    }
} while menuPoint < 1 || menuPoint > 3
