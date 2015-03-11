gulp = require 'gulp'
fs = require("fs")
path = require('path')
gulp.task('server', ->
  require('./app')
)

gulp.task('default', ['server'])
