const express = require('express');
const multer = require('multer');
const path = require('path');
const db = require('./config/db');

const app = express();

const FILES_DIR = path.join(__dirname, "files");

const upload = multer({ dest: FILES_DIR });

const PORT = 8080;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.get('/', (req,res) => {
    res.send('API VERSION 2');
});

app.get('/upload',upload.single('debt_file') ,(req, res) => {
    
})

db.dbConnection.sync();

app.listen(PORT, () => {

});