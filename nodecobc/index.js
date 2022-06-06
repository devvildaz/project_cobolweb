require('dotenv').config();
const express = require('express');
const multer = require('multer');
const path = require('path');
const cors = require("cors");
const https = require("https");
const db = require('./models/index');
const {paths : staticPaths} = require("./utils/constants");
const env = process.env.NODE_ENV || 'development';
const configDb = require(__dirname + '/config/config.json')[env];
const fs = require("fs");


const util = require('util');
const router = require('./controllers');
const exec = util.promisify(require('child_process').exec);

const app = express();

app.use(cors());
const PORT = 8080;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/v1/', router);

const sslServer = https.createServer({
    key: fs.readFileSync(path.join(__dirname, 'cert', 'key.pem')),
    cert : fs.readFileSync(path.join(__dirname, 'cert', 'cert.pem')),
}, app);



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
    sslServer.listen(PORT, () => {
        console.log("Deployed on port number",PORT)
        console.log("rootproject:",staticPaths.rootProject)
        console.log("Environment:",env);
    });
})
.catch((err) => {
    console.log(err);
    console.log("Error with the connection of database");
})

