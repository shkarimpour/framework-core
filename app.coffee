module.exports = ->
	express = require 'express'
	path = require 'path' 
	favicon = require 'static-favicon' 
	logger = require 'morgan' 
	cookieParser = require 'cookie-parser' 
	bodyParser = require 'body-parser' 
	config = require '../config' 

	app = express()
	app.locals.routes = {}

	# view engine setup
	app.set 'views', path.join __dirname+"/../", config.autoload.viewsPath
	app.set 'view engine', 'jade' 

	app.use favicon() 
	app.use logger('dev') 
	app.use bodyParser.json() 
	app.use bodyParser.urlencoded() 
	app.use cookieParser() 
	app.use express.session
		key:"shk-framework"
		secret:"your-secret-key"

	app.use express.static path.join __dirname, 'public'   
	app.use app.router 

	app