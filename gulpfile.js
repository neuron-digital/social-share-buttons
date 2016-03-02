var gulp = require('gulp');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var coffeelint = require('gulp-coffeelint');
var concat = require('gulp-concat');
var runSequence = require('run-sequence');
var del = require('del');

var paths = {
  // JavaScript
  COFFEE_SOURCE: 'vendor/assets/javascripts/**/*.coffee',
  JS_DEST: 'dist/',
};

gulp.task('coffee', ['coffee:clean'], function() {
  return gulp.src(paths.COFFEE_SOURCE)
    .pipe(coffee())
    .pipe(concat('jquery.socialShareButtons.js'))
    .pipe(gulp.dest(paths.JS_DEST))
    .on('error', gutil.log);
});

gulp.task('coffee:clean', function() {
  return del(paths.JS_DEST);
});

gulp.task('lint', function() {
  return gulp.src(paths.COFFEE_SOURCE)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter());
});

gulp.task('clean', function() {
  return del(['static']);
});

gulp.task('default', function() {
  runSequence('clean', ['coffee', 'lint']);
});
