del = require 'del'
gulp = require 'gulp'

gulp.task 'clean', (done) ->
  del [
    './lib'
  ], done

gulp.task 'default', ['clean']
