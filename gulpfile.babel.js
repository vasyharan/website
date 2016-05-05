import gulp from 'gulp'
import sass from 'gulp-sass'
import sourcemaps from 'gulp-sourcemaps'

gulp.task('build', ['html', 'images', 'sass', 'fonts'])

gulp.task('build:watch', ['build', 'html:watch', 'images:watch', 'sass:watch'])

gulp.task('fonts', () => (
  gulp.src('./node_modules/font-awesome/fonts/*')
    .pipe(gulp.dest('./dist/fonts'))
))

gulp.task('images', () => (
  gulp.src('./src/images/**.jpg')
    .pipe(gulp.dest('./dist/images'))
))

gulp.task('images:watch', ['images'], () => (
  gulp.watch('./src/images/**.jpg', ['images'])
))

gulp.task('html', () => (
  gulp.src('./src/**/*.html')
    .pipe(gulp.dest('./dist'))
))

gulp.task('html:watch', ['html'], () => (
  gulp.watch('./src/**/*.html', ['html'])
))

gulp.task('sass', () => (
  gulp.src('./src/sass/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass({
      "includePaths": [
        "./node_modules/bootstrap/scss",
        "./node_modules/font-awesome/scss/"
      ]
    }).on('error', sass.logError))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./dist/css'))
))

gulp.task('sass:watch', ['sass'], () => (
  gulp.watch('./src/sass/**/*.scss', ['sass'])
))
