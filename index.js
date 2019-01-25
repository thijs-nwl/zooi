const fs = require('fs')
const spawn = require('child_process').spawn
const express = require('express')
const app = express()
const server = require('http').Server(app)
const io = require('socket.io')(server)
const path = require('path')

const dataDir1 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\1'
const dataDir5 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\5'
const dataDir15 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\15'
const dataDir30 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\30'
const dataDir60 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\60'
const dataDir240 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\240'
const dataDir1440 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\1440'
const dataDir10080 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\10080'
const dataDir43200 = 'C:\\Users\\Thijsd\\AppData\\Roaming\\MetaQuotes\\Terminal\\CC0268A8FC98B4CB75FF9516154E4AB9\\MQL4\\Files\\HistoryAgg\\43200'
var pythonProcess
const port = process.env.PORT || 3000

app.use(express.static('public'))

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/index.html'))
})

function init (dataDir, str) {
  //  console.log('init: ' + str)
  pythonProcess = spawn('python', ['convert.py', dataDir])
  pythonProcess.stdout.on('data', (data) => {
    io.emit(str, JSON.parse(data.toString('utf8')))
    //  console.log('initEmit: ' + str)
    i = 0
  })
};

function testAndSend (dataDir, str) {
  if (i > 58) {
    i = 0
  } else if (i === 58) {
    i++
    //  console.log('testAndSend: ' + str)
    pythonProcess = spawn('python', ['convert.py', dataDir])
    pythonProcess.stdout.on('data', (data) => {
      io.emit(str, JSON.parse(data.toString('utf8')))
      i = 0
      //  console.log('testAndSendEmit: ' + str)
    })
  } else {
    i++
  }
}

io.on('connection', () => {
  init(dataDir1, 'Dir1')
  init(dataDir5, 'Dir5')
  init(dataDir15, 'Dir15')
  init(dataDir30, 'Dir30')
  init(dataDir60, 'Dir60')
  init(dataDir240, 'Dir240')
  init(dataDir1440, 'Dir1440')
  init(dataDir10080, 'Dir10080')
  init(dataDir43200, 'Dir43200')
})

fs.watch(dataDir1, (eventType, file) => {
  var i = 0
  testAndSend(dataDir1, 'Dir1')
})

fs.watch(dataDir5, (eventType, file) => {
  var i = 0
  testAndSend(dataDir5, 'Dir5')
})

fs.watch(dataDir15, (eventType, file) => {
  var i = 0
  testAndSend(dataDir15, 'Dir15')
})

fs.watch(dataDir30, (eventType, file) => {
  var i = 0
  testAndSend(dataDir30, 'Dir30')
})

fs.watch(dataDir60, (eventType, file) => {
  var i = 0
  testAndSend(dataDir60, 'Dir60')
})

fs.watch(dataDir240, (eventType, file) => {
  var i = 0
  testAndSend(dataDir240, 'Dir240')
})

fs.watch(dataDir1440, (eventType, file) => {
  var i = 0
  testAndSend(dataDir1440, 'Dir1440')
})

fs.watch(dataDir10080, (eventType, file) => {
  var i = 0
  testAndSend(dataDir10080, 'Dir10080')
})

fs.watch(dataDir43200, (eventType, file) => {
  var i = 0
  testAndSend(dataDir43200, 'Dir43200')
})

server.listen(port, () => {
  console.log('listening at: ' + port)
})
