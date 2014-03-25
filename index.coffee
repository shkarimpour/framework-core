module.exports = ->
  
  #shk modules
  app = (require './app')()
  Routing = require './routing'
  config = require '../config'
  autoload = require './autoload'

  #node modules
  Sequelize = require 'sequelize'
  _ = require 'underscore'
  sanitizer = require "sanitizer"
  path = require 'path'

  #define db
  db = (require './db')( Sequelize,config.db)

  #create dependency injector
  di = 
      app:app
      db:db
      DB:Sequelize
      _:_
      routes:app.locals.routes
      filters:{}
      controllers:{}
      models:{}
      config:config
      sanitizer:sanitizer
      xss:sanitizer.sanitize
      e:sanitizer.escape

  #set some views add ons
  di.app.locals.viewsPath = di.viewsPath

  #assign routes
  Routing di


  #connect to db and syn changes
  db
    .authenticate()
    .complete (err)->
        if !!err 
          console.log 'Unable to connect to the database:', err
        else 
          console.log 'Connection has been established successfully.'

          #sync db
          db
            .sync()
            .complete (err)->
               if !!err
                 console.log 'An error occurred while create the table:', err
               else
                 console.log 'It worked!'
            
        
    

  #set port of server
  app.set 'port',config.app.port

  #run autoload
  autoload di

  #set di for views
  app.locals.di = di
  app.locals._ = _

  di

