function getUpcomingBirthdays() {
  var spreadsheet = SpreadsheetApp.openById("13N-sl98Xc1s4QDPXoppMZ5LIt9D9ZWHpZjK9XgA3RiE");
  var sheet = spreadsheet.getSheetByName("Sheet1"); // Замените "Sheet1" на имя вашего листа с данными о сотрудниках
  var birthListSheet = spreadsheet.getSheetByName("BirthList"); // Замените "BirthList" на имя вашего листа для списка дней рождений

  var today = new Date();
  var startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
  var endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 7);

  var dataRange = sheet.getRange("A2:Q"); // Замените "A2:Q" на диапазон, где хранятся данные о сотрудниках
  var data = dataRange.getValues();

  var birthdays = [];
  
  for (var i = 0; i < data.length; i++) {
    var birthday = new Date(data[i][11]); // Индекс 11 соответствует столбцу L, где хранятся даты рождения
    var birthday_search = new Date(today.getFullYear(), birthday.getMonth(), birthday.getDate());
    if (birthday_search >= startDate && birthday_search <= endDate) {
      var name = data[i][1]; // Индекс 1 соответствует столбцу B, где хранятся ФИО сотрудников
      var department = data[i][2]; // Индекс 2 соответствует столбцу C, где хранятся подразделения
      var email = data[i][16]; // Индекс 15 соответствует столбцу, где хранятся почты
      var moderation = '-'
      var added_date = today
      birthdays.push([name, department, birthday, email, moderation, added_date]);
    }
  }

  // Сортировка списка по ФИО сотрудников
  birthdays.sort(function(a, b) {
    var nameA = a[0].toLowerCase();
    var nameB = b[0].toLowerCase();
    if (nameA < nameB) {
      return -1;
    }
    if (nameA > nameB) {
      return 1;
    }
    return 0;
  });

  if (birthdays.length > 0) {
    var lastRow = birthListSheet.getLastRow();
    var startRow = lastRow + 1; // Add new data starting from the next row after the last one

    var range = birthListSheet.getRange(startRow, 1, birthdays.length, birthdays[0].length);
    range.setValues(birthdays);
  }
}
