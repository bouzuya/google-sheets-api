coffee = require 'gulp-coffee'
del = require 'del'
gulp = require 'gulp'

gulp.task 'build', ->
  gulp.src './src/**/*.coffee'
    .pipe coffee(bare: true)
    .pipe gulp.dest './lib'

gulp.task 'clean', (done) ->
  del [
    './lib'
  ], done

gulp.task 'default', ['clean']
