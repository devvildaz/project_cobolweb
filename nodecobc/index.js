const express = require('express');

const app = express();

const PORT = 8080;

app.get('/', (req,res) => {
    res.send('API VERSION 2');
});

app.listen(PORT, () => {
    console.log(`Server deployed on port ${PORT}`)
});
