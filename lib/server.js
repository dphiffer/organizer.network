module.exports = () => {

	let server, app;

	if (process.env.NODE_ENV &&
	    process.env.NODE_ENV == 'maintenance') {
		console.log(`starting in maintenance mode`);
		app = maintenance_app();
	} else {
		app = require('../app');
	}
	start_app(app);

};

function start_app(app) {

	const fs = require('fs');
	const config = require('../config');

	if ('ssl' in config) {
		// Setup HTTPS server
		let https_options = {};
		for (let key in config.ssl) {
			https_options[key] = fs.readFileSync(`${__dirname}/${config.ssl[key]}`);
		}
		server = require('https').createServer(https_options, app);
	} else {
		// Setup HTTP server
		server = require('http').createServer(app);
	}

	server.listen(config.port, () => {
		console.log(`listening on *:${config.port}`);
	});

	const io = require('socket.io')(server);

	// Setup CORS
	io.origins((origin, callback) => {
		if (config.cors_origins.indexOf('*') !== -1) {
			callback(null, true);
		} else if (config.cors_origins.indexOf(origin) !== -1 ||
		           config.cors_origins.indexOf(origin + '/') !== -1) {
			callback(null, true);
		} else {
			console.log(`CORS blocked origin: ${origin}`);
			return callback('origin not allowed', false);
		}
	});

	return server;

}

function maintenance_app() {
	const express = require('express');
	const app = express();

	app.set('view engine', 'ejs');
	app.use(express.static('public'));
	app.use((req, rsp) => {
		rsp.status(503).render('page', {
			title: 'Maintenance mode',
			view: 'maintenance',
			content: {}
		});
	});

	return app;
}
