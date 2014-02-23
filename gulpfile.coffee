gulp = require("gulp")
gutil = require("gulp-util")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
less = require("gulp-less")
haml = require("gulp-haml")

gulp.task("copy", () ->
  gulp.src('public/**/*')
  .pipe(gulp.dest("dist")))

gulp.task('less', ->
  gulp.src(['src/css/**/*.less', '!src/css/**/_*.less'])
  .pipe(less())
  .pipe(concat("app.css"))
  .pipe(gulp.dest("dist")))

gulp.task 'coffee', ->
  gulp.src(["src/js/**/*.coffee"])
  .pipe(coffee())
  .pipe(concat("app.js"))
  .pipe(gulp.dest("dist"))

gulp.task 'haml', ->
  gulp.src(["src/**/*.haml", "!src/**/_*.haml"])
  .pipe(haml())
  .pipe(gulp.dest("dist"))

gulp.task 'default', ->
  gulp.run 'copy', 'less', 'coffee', 'haml'

gulp.task 'watch', ->
  gulp.run 'default'
  gulp.watch 'public/**/*', -> gulp.run 'copy'
  gulp.watch 'src/**/*.haml', -> gulp.run 'haml'
  gulp.watch 'src/css/**/*.less', -> gulp.run 'less'
  gulp.watch 'src/js/**/*.coffee', -> gulp.run 'coffee'