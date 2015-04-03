# google-sheets-api

A [Google Sheets API](https://developers.google.com/google-apps/spreadsheets/) client (unofficial).

# Installation

```
$ npm install https://github.com/bouzuya/google-sheets-api/archive/master.tar.gz
```

or

```
$ npm install https://github.com/bouzuya/google-sheets-api/archive/{VERSION}.tar.gz
```

# Example

```coffee
newClient = require 'google-sheets-api'

email = '...@developer.gserviceaccount.com'
key = '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n'

client = newClient({ email, key })
spreadsheet = client.getSpreadsheet('...')
spreadsheet.getWorksheetIds()
.then (worksheetIds) ->
  spreadsheet.getWorksheet(worksheetIds[0])
.then (w) -> worksheet = w
.then ->
  worksheet.getValue({ row: 1, col: 1 })
.then (value) ->
  worksheet.setValue({ row: 1, col: 1, value: value })
.then ->
  worksheet.getCells({ row: 1 })
.then (cells) ->
  console.log cells.filter (i) -> i.col is 1
.catch (e) ->
  console.error e
```

# License

[MIT](LICENSE)

# Author

[bouzuya][user] &lt;[m@bouzuya.net][mail]&gt; ([http://bouzuya.net][url])

[user]: https://github.com/bouzuya
[mail]: mailto:m@bouzuya.net
[url]: http://bouzuya.net
