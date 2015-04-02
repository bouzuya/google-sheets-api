coffee = require 'gulp-coffee'
del = require 'del'
gulp = require 'gulp'
run = require 'run-sequence'

gulp.task 'build', ->
  gulp.src './src/**/*.coffee'
    .pipe coffee(bare: true)
    .pipe gulp.dest './lib'

gulp.task 'clean', (done) ->
  del [
    './lib'
  ], done

gulp.task 'default', (done) ->
  run.apply run, [
    'clean'
    'build'
    done
  ]
