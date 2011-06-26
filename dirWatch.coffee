fs = require('fs')
events = require('events')

Array::contains =(file)->
  this.indexOf(file) isnt -1

class DirWatch extends events.EventEmitter

  watch:(path)->
     fs.readdir path, (err, files)->
       @emit("error", err) if err?
       newWatchedFiles = []
       if files?
         for file in @watchedFiles
           @emit("deletedfile", "#{path}/#{file}") if not files.contains(file)
  
         for file in files  when file.match regex
           newWatchedFiles.push(file)  
           @emit('newfile', "#{path}/#{file}") if not @watchedFiles.contains(file)     
         @watchedFiles = newWatchedFiles
  
  constructor:(path,regex, interval)->
    @regex = new RegExp(regex)
    interval = interval || 5000
    @watchedFiles= []
    setInterval((->watch(path)), interval)
         
exports.DirWatch=DirWatch
