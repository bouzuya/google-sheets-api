var Worksheet, baseUrl, projections, visibilities;

baseUrl = require('./base-url');

projections = require('./projections');

visibilities = require('./visibilities');

Worksheet = (function() {
  function Worksheet(arg) {
    this.client = arg.client, this.spreadsheet = arg.spreadsheet, this.id = arg.id;
  }

  Worksheet.prototype.getValue = function(position) {
    var col, ref, row, url;
    ref = this._parsePosition(position), row = ref.row, col = ref.col;
    url = this._getCellUrl({
      key: this.spreadsheet.key,
      worksheetId: this.id,
      visibilities: visibilities["private"],
      projections: projections.full,
      row: row,
      col: col
    });
    return this.client.request({
      url: url,
      method: 'GET',
      headers: {
        'GData-Version': '3.0',
        'Content-Type': 'application/atom+xml'
      }
    }).then(this.client.parseXml.bind(this.client)).then(function(data) {
      return data.entry.content[0];
    });
  };

  Worksheet.prototype.getCells = function() {
    var url;
    url = this._getCellsUrl({
      key: this.spreadsheet.key,
      worksheetId: this.id,
      visibilities: visibilities["private"],
      projections: projections.full
    });
    return this.client.request({
      url: url,
      method: 'GET',
      headers: {
        'GData-Version': '3.0',
        'Content-Type': 'application/atom+xml'
      }
    }).then(this.client.parseXml.bind(this.client)).then((function(_this) {
      return function(data) {
        return data.feed.entry.map(function(i) {
          var _, col, colName, ref, row, rowString;
          ref = i.title[0].match(/^([A-Z]+)(\d+)$/), _ = ref[0], colName = ref[1], rowString = ref[2];
          row = parseInt(rowString, 10);
          col = _this._parseColumnName(colName);
          return {
            row: row,
            col: col,
            value: i.content[0]
          };
        });
      };
    })(this));
  };

  Worksheet.prototype.setValue = function(positionAndValue) {
    var col, ref, row, url, value;
    ref = this._parsePosition(positionAndValue), row = ref.row, col = ref.col;
    value = positionAndValue.value;
    url = this._getCellUrl({
      key: this.spreadsheet.key,
      worksheetId: this.id,
      visibilities: visibilities["private"],
      projections: projections.full,
      row: row,
      col: col
    });
    return this.client.request({
      url: url,
      method: 'GET',
      headers: {
        'GData-Version': '3.0',
        'Content-Type': 'application/atom+xml'
      }
    }).then(this.client.parseXml.bind(this.client)).then((function(_this) {
      return function(data) {
        var contentType, xml;
        contentType = 'application/atom+xml';
        xml = "<entry xmlns=\"http://www.w3.org/2005/Atom\"\n    xmlns:gs=\"http://schemas.google.com/spreadsheets/2006\">\n  <id>" + url + "</id>\n  <link rel=\"edit\" type=\"" + contentType + "\" href=\"" + url + "\"/>\n  <gs:cell row=\"" + row + "\" col=\"" + col + "\" inputValue=\"" + value + "\"/>\n</entry>";
        return _this.client.request({
          url: url,
          method: 'PUT',
          headers: {
            'GData-Version': '3.0',
            'Content-Type': contentType,
            'If-Match': data.entry.$['gd:etag']
          },
          body: xml
        });
      };
    })(this)).then(this.client.parseXml.bind(this.client));
  };

  Worksheet.prototype.deleteValue = function(position) {
    var col, ref, row, url;
    ref = this._parsePosition(position), row = ref.row, col = ref.col;
    url = this._getCellUrl({
      key: this.spreadsheet.key,
      worksheetId: this.id,
      visibilities: visibilities["private"],
      projections: projections.full,
      row: row,
      col: col
    });
    return this.client.request({
      url: url,
      method: 'GET',
      headers: {
        'GData-Version': '3.0',
        'Content-Type': 'application/atom+xml'
      }
    }).then(this.client.parseXml.bind(this.client)).then((function(_this) {
      return function(data) {
        var contentType;
        contentType = 'application/atom+xml';
        return _this.client.request({
          url: url,
          method: 'DELETE',
          headers: {
            'GData-Version': '3.0',
            'Content-Type': contentType,
            'If-Match': data.entry.$['gd:etag']
          }
        });
      };
    })(this)).then(this.client.parseXml.bind(this.client));
  };

  Worksheet.prototype._getCellUrl = function(arg) {
    var col, key, path, projections, row, visibilities, worksheetId;
    key = arg.key, worksheetId = arg.worksheetId, visibilities = arg.visibilities, projections = arg.projections, row = arg.row, col = arg.col;
    path = "/cells/" + key + "/" + worksheetId + "/" + visibilities + "/" + projections + "/R" + row + "C" + col;
    return baseUrl + path;
  };

  Worksheet.prototype._getCellsUrl = function(arg) {
    var key, path, projections, visibilities, worksheetId;
    key = arg.key, worksheetId = arg.worksheetId, visibilities = arg.visibilities, projections = arg.projections;
    path = "/cells/" + key + "/" + worksheetId + "/" + visibilities + "/" + projections;
    return baseUrl + path;
  };

  Worksheet.prototype._parsePosition = function(arg) {
    var _, col, r1c1, ref, row;
    row = arg.row, col = arg.col, r1c1 = arg.r1c1;
    if ((row != null) && (col != null)) {
      return {
        row: row,
        col: col
      };
    }
    if ((row != null) || (col != null)) {
      throw new Error();
    }
    if (r1c1 == null) {
      throw new Error();
    }
    ref = r1c1.match(/^R(\d+)C(\d+)$/), _ = ref[0], row = ref[1], col = ref[2];
    return {
      row: row,
      col: col
    };
  };

  Worksheet.prototype._getColumnName = function(col) {
    return String.fromCharCode('A'.charCodeAt(0) + col - 1);
  };

  Worksheet.prototype._parseColumnName = function(colName) {
    return colName.charCodeAt(0) - 'A'.charCodeAt(0) + 1;
  };

  return Worksheet;

})();

module.exports.Worksheet = Worksheet;
