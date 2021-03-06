var gulp            = require('gulp');
var jasmine         = require('gulp-jasmine');
var coffee          = require('gulp-coffee');
var coffeeSettings  = {
  bare: true
};

gulp.task('scripts', [], function() {
  return gulp.src('./**/*.coffee').pipe(coffee(coffeeSettings)).pipe(gulp.dest('.'));
});

gulp.task('watch', function() {
  gulp.watch('./**/*.coffee', ['scripts']);
});

gulp.task('default', ['watch', 'scripts']);

gulp.task('tests', ['scripts'], function() {
  return gulp.src('./spec/**/*.js').pipe(jasmine());
});

