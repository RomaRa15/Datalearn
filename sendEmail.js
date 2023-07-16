function sendNewBirthdayReminders() {
  var spreadsheet = SpreadsheetApp.openById("13N-sl98Xc1s4QDPXoppMZ5LIt9D9ZWHpZjK9XgA3RiE");
  var sheet = spreadsheet.getSheetByName("Sheet1");

  var today = new Date();
  var startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
  var endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 7);

  var employees = sheet.getRange("A2:P" + sheet.getLastRow()).getValues();
  var birthdayList = [];

  for (var i = 0; i < employees.length; i++) {
    var employee = employees[i];
    var birthday = new Date(employee[11]);
    var birthday_search = new Date(today.getFullYear(), birthday.getMonth(), birthday.getDate());

    if (birthday_search >= startDate && birthday_search <= endDate) {
      var name = employee[1];
      var department = employee[2];
      var age = today.getFullYear() - birthday.getFullYear();

      var birthdayInfo = {
        name: name,
        department: department,
        age: age,
        birthday: birthday
      };

      birthdayList.push(birthdayInfo);
    }
  }

  // Сортировка списка по возрастанию дня рождения
  birthdayList.sort(function(a, b) {
    var dayA = a.birthday.getDate();
    var dayB = b.birthday.getDate();
    return dayA - dayB;
  });

  if (birthdayList.length > 0) {
    var subject = "Дни рождения на этой неделе";
    var body = "На неделе, с " + formatDate(startDate, "dd.MM.yyyy") + " по " + formatDate(endDate, "dd.MM.yyyy") + ", следующие сотрудники отмечают день рождения:\n\n";

    var currentDay = null;
    var months = [
      "января",
      "февраля",
      "марта",
      "апреля",
      "мая",
      "июня",
      "июля",
      "августа",
      "сентября",
      "октября",
      "ноября",
      "декабря"
    ];

    for (var j = 0; j < birthdayList.length; j++) {
      var birthdayInfo = birthdayList[j];
      var day = formatDate(birthdayInfo.birthday, "dd");
      var month = months[birthdayInfo.birthday.getMonth()];

      if (day !== currentDay) {
        if (currentDay !== null) {
          body += "\n";
        }
        body += day + " " + month + "\n";
        currentDay = day;
      }

      body += birthdayInfo.name + ", " + birthdayInfo.department + " - исполняется " + birthdayInfo.age + " " + getAgeLabel(birthdayInfo.age) + " - " + formatDate(birthdayInfo.birthday, "dd.MM.yyyy") + "\n";
    }

    body += "\n\nОставьте свое поздравление и пожелания для наших именинников по ссылке: https://forms.gle/MqvapuDHu2NLGruA8";
    
    MailApp.sendEmail("roman.rodionov.20@mail.ru", subject, body);
  } else {
    var subject = "Дни рождения на этой неделе";
    var body = "На следующей неделе (" + formatDate(startDate, "dd.MM.yyyy") + " - " + formatDate(endDate, "dd.MM.yyyy") + ")";

    MailApp.sendEmail("roman.rodionov.20@mail.ru", subject, body);
  }
}

function formatDate(date, format) {
  var formattedDate = Utilities.formatDate(date, "Asia/Vladivostok", "yyyy-MM-dd");
  return Utilities.formatDate(new Date(formattedDate), "Asia/Vladivostok", format);
}

function getAgeLabel(age) {
  if (age % 10 === 1 && age !== 11) {
    return "год";
  } else if ((age % 10 === 2 || age % 10 === 3 || age % 10 === 4) && !(age >= 12 && age <= 14)) {
    return "года";
  } else {
    return "лет";
  }
}
