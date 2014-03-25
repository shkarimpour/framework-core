module.exports = (di)->
	paths = require '../config/autoload'
	autoload paths.controllersPath,di,initController
	autoload paths.modelsPath,di,initModel
	autoload paths.filtersPath,di,initFilter
	autoload paths.routesPath,di,initRoute
	di

autoload = (path,di,init)->
	fs = require 'fs'
	files = fs.readdirSync path
	name = ""
	for file in files
		name = (file.split '.' )[0]
		init di,(require "../#{path}/#{name}"),name
	true

initController = (di,controller,name)->
	controller = controller di
	di.controllers[name] = controller
	true

initModel = (di,model,name)->
	model = model(di)
	di.models[name] = model
	true

initRoute = (di,route,name)->
	route di.routing,di
	true

initFilter = (di,filter,name)->
	(di.filters[filterName] = fn) for filterName,fn of (filter di)
	true