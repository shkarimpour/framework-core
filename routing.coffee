module.exports = (di)->

	routing = 
		#main path of route
		path : "/"

		#routing filters
		filters : []

		#getting route path
		route:(name)-> di.routes[name]

		#define route for app
		get :(path,obj)->
			#assign path of route
			path = @path+path

			#check type of obj
			if di._.isFunction obj
				#if is function simply make a get for it
				di.app.get path,obj
				return true

			#as
			if obj.as and di._.isString obj.as
				di.routes[obj.as] = path

			#if group has filters assign it
			if  obj.filters and di._.isArray obj.filters
				filters = @getFilters obj.filters
			else
				filters = @getFilters()

			#controller
			task = null
			if obj.uses
				if di._.isFunction obj.uses
					di.app.get path,filters,obj.uses
					return true	
				else if di._.isString obj.uses
					task = obj.uses.split '@'
					if task.length isnt 2 or not di.controllers[task[0]] or not di.controllers[task[0]][task[1]]
						task = null

			#matching them all
			if task
				di.app.get path,filters,di.controllers[task[0]][task[1]]
				return true

			return false

		post : (path,obj)->
			#assign path of route
			path = @path+path

			#check type of obj
			if di._.isFunction obj
				#if is function simply make a get for it
				di.app.post path,obj	
				return true

			#as
			if obj.as and di._.isString obj.as
				di.routes[obj.as] = path

			#if group has filters assign it
			if  obj.filters and di._.isArray obj.filters
				filters = @getFilters obj.filters
			else
				filters = @getFilters()

			#controller
			task = false
			if obj.uses
				if di._.isFunction obj.uses
					di.app.post path,filters,obj.uses
					return true	
				else if di._.isString obj.uses
					task = obj.uses.split '@'
					if task.length isnt 2 or not di.controllers[task[0]] or not di.controllers[task[0]][task[1]]
						task = null

			#matching them all
			if task isnt off
				di.app.post path,filters,di.controllers[task[0]][task[1]]
				return true
			return false

		group:(obj)->
			#if routes isnt defined return false
			if not obj.routes and not di._.isFunction obj.routes then false

			#clone a routing object for group
			r = di._.clone @

			#if group has a prefix assign it
			if  obj.prefix and di._.isString obj.prefix
				r.path += obj.prefix

			#if group has filters assign it
			if  obj.filters and di._.isArray obj.filters
				r.filters = di._.union r.filters,obj.filters

			obj.routes r

		getFilters:(fs)->
			fils = if fs then fs else []

			#merge given filters with routes filters
			fils = di._.union @filters,fils
			
			filters = []

			(filters.push di.filters[filter] if di.filters[filter]) for filter in fils
			
			filters


	di.app.locals.route = routing.route
	di.routing = routing

	routing