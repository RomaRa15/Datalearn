function sendBirthdayGreetings() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var birthSheet = spreadsheet.getSheetByName("BirthList");
  var wishesSheet = spreadsheet.getSheetByName("Поздравления");

  // Check if there are any rows in the BirthList sheet
  if (birthSheet.getLastRow() < 2) {
    // If there are no rows (excluding headers), return early and do nothing
    return;
  }

  var today = new Date();
  var currentYear = today.getFullYear();

  var employees = birthSheet.getRange(2, 1, birthSheet.getLastRow() - 1, 5).getValues();
  var greetings = wishesSheet.getLastRow() > 1 ? wishesSheet.getRange(2, 2, wishesSheet.getLastRow() - 1, 4).getValues() : [];

  for (var i = 0; i < employees.length; i++) {
    var employee = employees[i];
    var employeeName = employee[0];
    var birthdate = new Date(employee[2]);
    var status = employee[4];

    birthdate.setFullYear(currentYear);

    if (isSameDate(today, birthdate) && status === "1") {
      var emailBody = createEmailBody(employeeName, greetings);
      var emailSubject = "С Днем Рождения, " + employeeName + "!";
      var employeeEmail = employee[3];

      MailApp.sendEmail({
        to: employeeEmail,
        subject: emailSubject,
        htmlBody: emailBody,
      });

      birthSheet.getRange(i + 2, 5).setValue("Отправлено");
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
  var emailBody = '<head>' +
    '<meta charset="UTF-8">' +
    '<meta name="viewport" content="width=device-width, initial-scale=1.0">' +
    '<title>Document</title>' +
    '</head>' +
    '<body>' +
    '<div style="color: white; background-color: #4C20C8; width: 700px; margin: auto;">' +
    '<img src="https://drive.google.com/uc?id=1wCIgoyKfJJXvGKROL2DqOcA_MLqHPra4" alt="Поздравительная открытка" style="display: block; margin: 0 auto;">' +
    '<div style="margin: auto; color: white; text-align: center; width: 700px;"><h1 style="font-family: Arial, sans-serif; margin: 0 auto;">' + employeeName + '</h1>' +
    '<div style="width: 500px; margin: 10px auto;">От всей души поздравляем вас с Днем Рождения! Пусть этот особенный день принесет вам радость и счастье, а также запоминающиеся моменты. Желаем вам успехов во всех начинаниях, вдохновения для достижения новых высот и постоянного развития. Вы являетесь непреодолимым источником знаний и вдохновения для нас, вашей команды. Мы ценим ваш вклад в наш университет и благодарны за ваше посвящение работе. Ваше стремление к постоянному росту и достижению новых целей вдохновляет нас всех. Пусть каждый шаг, который вы совершаете, будет направлен к успеху, и каждый день будет полон радости и удовлетворения. Желаем вам благополучия, здоровья и долгих лет успешной карьеры.</div>' +
    '</div>' +
    '<br>' +
    '<h2 style="text-align: center;">Примите искренние поздравления от ваших коллег!</h2>' +
    '<div style="color: black; background-color: white; border-radius: 10px; width: 500px; height: max-content; padding: 10px; margin: auto;">';
  for (var i = 0; i < greetings.length; i++) {
    var greeting = greetings[i];
    var birthdayPerson = greeting[0];
    var message = greeting[1];
    var sender = greeting[2];

    if (birthdayPerson === employeeName) {
      emailBody += '<strong style="margin: 0;">' + sender + '</strong>' +
        '<p style="margin-top: 10px; font-style: italic;">' + message + '</p>';
    }
  }

  emailBody += '</div>' +
    '<img src="https://drive.google.com/uc?id=17YHUSPuj91csu-B-8qRNrJ-RdeRrqBGn" alt="Поздравительная открытка" style="display: block; margin: 0 auto;">'+
    '</div>' +
    '</body>';

  return emailBody;
}
