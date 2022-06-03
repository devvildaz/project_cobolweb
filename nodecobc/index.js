const express = require('express');
const multer = require('multer');
const path = require('path');
const db = require('./models/index');

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
    
});

(async () => {
    await db.sequelize.authenticate();
    await db.sequelize.sync();
    app.listen(PORT, () => {
        console.log("Deployed on port number",PORT)
    });
})().then(() => {
    console.log("Deployed with also database");
})
.catch(() => {
    console.log("Error with the connection of database");
})

