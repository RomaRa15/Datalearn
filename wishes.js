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
      
      MailApp.sendEmail({
      to: employeeEmail,
      subject: emailSubject,
      htmlBody: emailBody
    });
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
  var emailBody = '<img src="https://drive.google.com/uc?id=1rkhpRfFHzquc81B6JeOxkhKdZk6Xkx3a" alt="Поздравительная открытка">\n\n';
  emailBody += '<div style="text-align: center;"><h1 style="font-family: Arial, sans-serif;">Дорогой ' + employeeName + ',</h1></div>\n\n';
  emailBody += "С Днем Рождения! Желаем вам счастья, здоровья и успехов в работе.\n\n";
  
  emailBody += "Вот поздравления от ваших коллег:\n";
  
  for (var i = 0; i < greetings.length; i++) {
    var greeting = greetings[i];
    var birthdayPerson = greeting[0];
    Logger.log(birthdayPerson)
    var message = greeting[1];
    Logger.log(message)
    var sender = greeting[2];
    Logger.log(sender)
    
    if (birthdayPerson === employeeName) {
      emailBody += '<div style="background-color: gainsboro; width: 400px; height: max-content; padding: 10px;"><strong>' + sender + '</strong><br>' + message + '</div>'
    }
  }
  
  emailBody += "\nС наилучшими пожеланиями,\nВаша команда";
  
  return emailBody;
}
