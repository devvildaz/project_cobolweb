const util = require('util');
const {paths: staticPaths} = require('../utils/constants');
const db = require('../models/index');
const exec = util.promisify(require('child_process').exec);

const configDbAndCobol = async () => {
    await db.sequelize.authenticate();
    await db.sequelize.drop();
    await db.sequelize.sync();
    console.log("")
    console.log(staticPaths.ocesqlScripts)
    let output = await exec(`ocesql ${staticPaths.ocesqlScripts}/BatchFile.cbl ${staticPaths.ocesqlScripts}/BatchFile.cob`);
    console.log(output.stdout);
    output = await exec(`cobc -x -lpq -locesql ${staticPaths.ocesqlScripts}/BatchFile.cob -o ${staticPaths.ocesqlExec}/BatchFile`);
    console.log(output.stdout);
}

module.exports = configDbAndCobol;