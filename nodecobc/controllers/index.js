const router = require('express').Router();
const {paths: staticPaths}  = require("../utils/constants");
const upload = require('../utils/multer');
const { unlink } = require("fs/promises");
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const { app_client, balance, sequelize } = require('../models/index');
const env = process.env.NODE_ENV || 'development';
const configDb = require(__dirname + '/../config/config.json')[env];

router.get('/', (req,res) => {
    res.status(200).json({ info: "COBOL WEB API V1"})
})

router.post(`/upload`, upload.single('file'), async (req,res) => {
    let filepath = req.file.path;
    let commandvalues = `"${configDb.database.concat("@",configDb.host).padEnd(32," ")}""${filepath.padEnd(48, " ")}"`;
    await exec(`./BatchFile ${commandvalues}`, { cwd: staticPaths.ocesqlExec })
    await unlink(req.file.path);

    res.redirect('/api/v1/client?summarize=true');
});

router.get('/client', async(req,res) => {
    if(req.query?.full == 'true') {
        res.status(200).json(await app_client.findAll({include: balance }));
    } 
    else if (req.query?.summarize == 'true'){
        let query = await sequelize
            .query("SELECT A.dni, A.name, SUM(COALESCE(B.amount,0.00)) as balance FROM app_clients AS A LEFT JOIN balances AS B ON A.dni = B.dni GROUP BY a.dni", { type: sequelize.QueryTypes.SELECT });
        res.status(200).json(query);
    }
    else {
        res.status(200).json(await app_client.findAll());
    }
});

router.post('/client', async (req,res) => {
    try {
       let n_client = await app_client.build({ dni: req.body.dni, name: req.body.name, created_at: (new Date()).toISOString().slice(0,19) });
       await n_client.save();
       res.status(200).json(n_client);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.post('/balance', async (req,res) => {
    try {
       let n_balance = await balance.build({ dni: req.body.dni, amount: req.body.amount, created_at: (new Date()).toISOString().slice(0,19) });
       await n_balance.save();
       res.status(200).json(n_balance);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

router.post('/balance/query', async(req,res) => {
    let options = req.body || {};

    res.status(200).json(await balance.findAll(options));
});

router.use((err, req, res, next) => {
    res.status(500).json(err);
});

router.delete('/client', async(req,res) => {
    try{
        await balance.destroy({ where: {dni: req.body.dni} });
        await app_client.destroy({where : { dni: req.body.dni }});
        res.status(200).json({ info: "Eliminacion exitosa" });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})


module.exports = router;