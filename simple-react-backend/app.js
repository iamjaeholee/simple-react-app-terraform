var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
var dotenv = require("dotenv");

var rootRouter = require("./routes");
var cors = require("cors");

var app = express();

const corsOptions = {
  origin: "*",
};
app.use(cors(corsOptions));
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/editorjs", rootRouter);
// health check
app.use("/", (req, res, next) => {
  res.send("its running on 6449 port");
});

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  console.log(err.message);
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
});

/**
 * env
 */

if (process.env.NODE_ENV === "production") {
  dotenv.config({ path: path.join(__dirname, "/.env.production") });
} else if (process.env.NODE_ENV === "develop") {
  dotenv.config({ path: path.join(__dirname, "/.env.develop") });
}

module.exports = app;
