var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
const { resolve } = require('path');
const { rejects } = require('assert');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// app.use('/', indexRouter);
// app.use('/users', usersRouter);

app.get("/sensorStatus", async (req,res)=>{
  var sensor_status;
  var obj = {};
  try{
    await new Promise((resolve,reject)=>{
    tcp_con.write("1");
    tcp_con.on('data',async (d)=>{
    sensor_status = d.split(",");
    let sum = 0;
    for(var i = 0;i<sensor_status.length;i++)
    {
      sum+=parseInt(sensor_status[i]);
      if(sum == 0)
      {
        reject();
      }
      else
      {
        for(var i =0;i<sensor_status.length;i++)
        {
          if(sensor_status[i]>15 || sensor_status[i] == 0)
            sensor_status[i] = false;
          else
            sensor_status[i] = true;
          obj[i] = { sensor_id : i+1, value: sensor_status[i] };
        }
        resolve();
      }
    }
  })
});
}catch(e)
  {
    res.send({error:"Sensors not responding"});
  }
  res.send(obj);
})

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
