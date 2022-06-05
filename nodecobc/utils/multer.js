const {paths: staticPaths}  = require("./constants");
const multer = require('multer');
const short = require('short-uuid');
const translator = short();

const storage = multer.diskStorage({
    destination: staticPaths.files,
    filename: function(req,file,cb){
        cb(null, translator.new());
    }
})
const upload = multer({ storage });


module.exports = upload;
