var Client;

Client = require('./client').Client;

module.exports = function(credentials) {
  return new Client(credentials);
};
