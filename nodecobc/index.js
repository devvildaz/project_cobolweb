const express = require('express');
const multer = require('multer');
const path = require('path');
const db = require('./models/index');
const {paths : staticPaths} = require("./utils/constants");
const env = process.env.NODE_ENV || 'development';
const configDb = require(__dirname + '/config/config.json')[env];

const util = require('util');
const router = require('./controllers');
const exec = util.promisify(require('child_process').exec);

const app = express();

const PORT = 8080;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/v1/', router);

(async () => {
    await db.sequelize.authenticate();
    await db.sequelize.drop();
    await db.sequelize.sync();
    console.log("")
    console.log(staticPaths.ocesqlScripts)
    let output = await exec(`ocesql ${staticPaths.ocesqlScripts}/BatchFile.cbl ${staticPaths.ocesqlScripts}/BatchFile.cob`);
    console.log(output.stdout);
    output = await exec(`cobc -x -lpq -locesql ${staticPaths.ocesqlScripts}/BatchFile.cob -o ${staticPaths.ocesqlExec}/BatchFile`);
    console.log(output.stdout);
})().then(() => {
    app.listen(PORT, () => {
        console.log("Deployed on port number",PORT)
        console.log("rootproject:",staticPaths.rootProject)
        console.log("Environment:",env);
    });
})
.catch((err) => {
    console.log(err);
    console.log("Error with the connection of database");
})

