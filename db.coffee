module.exports = (Sequelize,config)->
	dbconf = null

	switch config.db
		when "mysql"
			dbconf = config.mysql;
			dialect = "mysql"

		else 
			dbconf = config.mysql
			

	sequelize = new Sequelize dbconf.database,dbconf.user,dbconf.password,
		dialect:dialect
		port:dbconf.port

	sequelize