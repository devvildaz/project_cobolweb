require('dotenv').config();
const configDbAndCobol = require("./utils/initDbCobol");
var homedir = require('path').join(require('os').homedir());
const green_lock = require('greenlock-express');

var app = require('./index.js');

const instance = require('greenlock-express')
    .init({
        packageRoot: __dirname,

        // where to look for configuration
        configDir: './greenlock.d',
        maintainerEmail: "diegovilca_dev@hotmail.com",
        hotsnames: ['localhost'],
        // whether or not to run at cloudscale
        cluster: false
    })
    // Serves on 80 and 443
    // Get's SSL certificates magically!
configDbAndCobol().then(() => {
  instance.serve(app);
  console.log('listening');
});
