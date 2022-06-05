const path = require("path");

const rootProject = path.join(path.dirname(__filename), "..");

exports.paths = {
    rootProject,
    ocesqlScripts: path.join(rootProject, "cobol","ocesql"),
    ocesqlExec: path.join(rootProject,"cobol", "ocesql", "exec"),
    files: path.join(rootProject, 'files')
}