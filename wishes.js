function sendBirthdayGreetings() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var birthSheet = spreadsheet.getSheetByName("BirthList");
  var wishesSheet = spreadsheet.getSheetByName("Поздравления");
  
  var today = new Date();
  var currentYear = today.getFullYear();
  
  var employees = birthSheet.getRange(2, 1, birthSheet.getLastRow() - 1, 4).getValues();
  var greetings = wishesSheet.getRange(2, 2, wishesSheet.getLastRow() - 1, 4).getValues();
  
  for (var i = 0; i < employees.length; i++) {
    var employee = employees[i];
    var employeeName = employee[0];
    var birthdate = new Date(employee[2]);
    birthdate.setFullYear(currentYear); // Установка текущего года для даты рождения
    if (isSameDate(today, birthdate)) {
      var emailBody = createEmailBody(employeeName, greetings);
      var emailSubject = "С Днем Рождения, " + employeeName + "!";
      var employeeEmail = employee[3];
      
      MailApp.sendEmail(employeeEmail, emailSubject, emailBody);
    }
  }
}

function isSameDate(date1, date2) {
  return (
    date1.getDate() === date2.getDate() &&
    date1.getMonth() === date2.getMonth()
  );
}

function createEmailBody(employeeName, greetings) {
  var emailBody = "Дорогой " + employeeName + ",\n\n";
  emailBody += "С Днем Рождения! Желаем вам счастья, здоровья и успехов в работе.\n\n";
  
  emailBody += "Вот поздравления от ваших коллег:\n";
  
  for (var i = 0; i < greetings.length; i++) {
    var greeting = greetings[i];
    var birthdayPerson = greeting[0];
    var message = greeting[1];
    var sender = greeting[2];
    
    if (birthdayPerson === employeeName) {
      emailBody += "- " + message + " (от " + sender + ")\n";
    }
  }
  
  emailBody += "\nС наилучшими пожеланиями,\nВаша команда";
  
  return emailBody;
}
