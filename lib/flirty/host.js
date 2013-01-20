"use strict";

var express;

express = require('express');

module.exports = function(folder, password) {
  var app;
  app = express();
  if (folder != null) {
    app.use(express["static"](folder));
  }
  return app;
};
