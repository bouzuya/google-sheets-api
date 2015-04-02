coffee = require 'gulp-coffee'
del = require 'del'
espower = require 'gulp-espower'
gulp = require 'gulp'
mocha = require 'gulp-mocha'
run = require 'run-sequence'

gulp.task 'build', ->
  gulp.src './src/**/*.coffee'
    .pipe coffee(bare: true)
    .pipe gulp.dest './lib'

gulp.task 'build-test', ->
  gulp.src './test/**/*.coffee'
    .pipe coffee(bare: true)
    .pipe espower()
    .pipe gulp.dest './.tmp'

gulp.task 'clean', (done) ->
  del [
    './.tmp'
    './lib'
  ], done

gulp.task 'default', (done) ->
  run.apply run, [
    'clean'
    'build'
    done
  ]

gulp.task 'test', ['build', 'build-test'], ->
  gulp.src './.tmp/**/*.js'
    .pipe mocha()
