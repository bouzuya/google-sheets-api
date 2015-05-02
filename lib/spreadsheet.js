var Spreadsheet, Worksheet, baseUrl, projections, visibilities;

Worksheet = require('./worksheet').Worksheet;

baseUrl = require('./base-url');

projections = require('./projections');

visibilities = require('./visibilities');

Spreadsheet = (function() {
  function Spreadsheet(arg) {
    this.client = arg.client, this.key = arg.key;
  }

  Spreadsheet.prototype.getWorksheet = function(id) {
    return new Worksheet({
      client: this.client,
      spreadsheet: this,
      id: id
    });
  };

  Spreadsheet.prototype.getWorksheetIds = function() {
    var url;
    url = this._getWorksheetsUrl({
      key: this.key,
      visibilities: visibilities["private"],
      projections: projections.basic
    });
    return this.client.request({
      url: url
    }).then(this.client.parseXml.bind(this.client)).then(function(data) {
      var ids, ref;
      ids = (ref = data.feed.entry) != null ? ref.map(function(i) {
        var u;
        u = i.id[0];
        if (u.indexOf(url) !== 0) {
          throw new Error();
        }
        return u.replace(url + '/', '');
      }) : void 0;
      return ids != null ? ids : [];
    });
  };

  Spreadsheet.prototype._getWorksheetsUrl = function(arg) {
    var key, path, projections, visibilities;
    key = arg.key, visibilities = arg.visibilities, projections = arg.projections;
    path = "/worksheets/" + key + "/" + visibilities + "/" + projections;
    return baseUrl + path;
  };

  return Spreadsheet;

})();

module.exports.Spreadsheet = Spreadsheet;
