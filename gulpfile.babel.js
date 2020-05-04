import gulp from 'gulp'
import sass from 'gulp-sass'
import cleancss from 'gulp-clean-css'
import sourcemaps from 'gulp-sourcemaps'
import autoprefixer from 'gulp-autoprefixer'

const files = {
  fontsPath: './node_modules/font-awesome/fonts/*',
  imagesPath: './src/images/**.jpg',
  htmlPath: './src/**/*.html',
  cssPath: './src/sass/**/*.scss',
  jsPath: 'app/js/**/*.js'
}

const fonts = () => (
  gulp.src(files.fontsPath)
    .pipe(gulp.dest('./dist/fonts'))
)

const images = () => (
  gulp.src(files.imagesPath)
    .pipe(gulp.dest('./dist/images'))
)

const html = () => (
  gulp.src(files.htmlPath)
    .pipe(gulp.dest('./dist'))
)

const keybase = () => (
  gulp.src(['./src/keybase.txt'])
    .pipe(gulp.dest('./dist/.well-known'))
)

const css = () => (
  gulp.src(files.cssPath)
    .pipe(sourcemaps.init())
    .pipe(sass({
      "includePaths": [
        "./node_modules"
      ]
    }).on('error', sass.logError))
    .pipe(autoprefixer())
    .pipe(cleancss())
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./dist/css'))
)

const watch = () => {
  gulp.parallel(
    gulp.watch('./src/images/**.jpg', images),
    gulp.watch('./src/**/*.html', html),
    gulp.watch('./src/sass/**/*.scss', css)
  )
}

const build = (done) => {
  gulp.series([html, keybase, images, sass, fonts])
  done()
}

exports.watch = watch;
exports.default = build
