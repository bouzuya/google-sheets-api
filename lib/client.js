var Client, Promise, Spreadsheet, Worksheet, google, parseString;

google = require('googleapis');

Promise = require('es6-promise').Promise;

parseString = require('xml2js').parseString;

Spreadsheet = require('./spreadsheet').Spreadsheet;

Worksheet = require('./worksheet').Worksheet;

Client = (function() {
  function Client(arg) {
    this.email = arg.email, this.key = arg.key;
  }

  Client.prototype.getSpreadsheet = function(key) {
    return new Spreadsheet({
      client: this,
      key: key
    });
  };

  Client.prototype.request = function(options) {
    return this._authorize({
      email: this.email,
      key: this.key
    }).then(function(client) {
      return new Promise(function(resolve, reject) {
        return client.request(options, function(err, data) {
          if (err != null) {
            return reject(err);
          } else {
            return resolve(data);
          }
        });
      });
    });
  };

  Client.prototype._authorize = function(arg) {
    var email, key;
    email = arg.email, key = arg.key;
    return new Promise(function(resolve, reject) {
      var jwt, scope;
      scope = ['https://spreadsheets.google.com/feeds'];
      jwt = new google.auth.JWT(email, null, key, scope, null);
      return jwt.authorize(function(err) {
        if (err != null) {
          return reject(err);
        } else {
          return resolve(jwt);
        }
      });
    });
  };

  Client.prototype.parseXml = function(xml) {
    return new Promise(function(resolve, reject) {
      return parseString(xml, function(err, parsed) {
        if (err != null) {
          return reject(err);
        } else {
          return resolve(parsed);
        }
      });
    });
  };

  return Client;

})();

module.exports.Client = Client;
