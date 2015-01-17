var gulp           = require('gulp');
var bower          = require('gulp-bower');
var gulpBowerFiles = require('gulp-bower-files');
var concat         = require('gulp-concat');
var coffee         = require('gulp-coffee');
var eco            = require('gulp-eco');
var uglify         = require('gulp-uglify');
var sass           = require('gulp-sass');

var debug = true;

var paths = {
  js:     [ 'app/javascripts/vendor/**/*.js', 'app/javascripts/**/*.js' ],
  sass:   [ 'app/stylesheets/application.sass', 'app/stylesheets/**/*.css' ],
  coffee: [ 'app/coffee/*.coffee', 'app/coffee/**/*.coffee' ],
  eco:    [ 'app/templates/*.eco', 'app/templates/**/*.eco' ]
};

gulp.task('bower-files', ['bower'], function() {
  return gulpBowerFiles().pipe(gulp.dest("./app/javascripts/vendor"));
});

gulp.task('bower', function() {
  return bower();
});

gulp.task('coffee', function() {
  return gulp.src(paths.coffee).pipe(coffee()).pipe(concat('application.js')).pipe(gulp.dest("./app/javascripts/"));
});

gulp.task('eco', function() {
  var eco_options = {
    basePath: 'app/templates'
  };
  return gulp.src(paths.eco).pipe(eco(eco_options)).pipe(concat('templates.js')).pipe(gulp.dest("./app/javascripts/"));
});

gulp.task('javascript', ['coffee'], function() {
  var js = gulp.src(paths.js).pipe(concat('application.js'));

  if (debug == false)
    js = js.pipe(uglify());
  return js.pipe(gulp.dest("../server/public/javascripts/"));
});

gulp.task('stylesheets', function() {
  return gulp.src(paths.sass).pipe(sass()).pipe(concat('application.css')).pipe(gulp.dest("../server/public/stylesheets/"));
});

gulp.task('watch', function() {
  gulp.watch('./bower.json', ['bower-files']);
  gulp.watch(paths.js,     ['javascript']);
  gulp.watch(paths.sass,   ['stylesheets']);
  gulp.watch(paths.coffee, ['coffee']);
  gulp.watch(paths.eco,    ['eco']);
});

gulp.task('default', ['bower-files', 'watch']);
