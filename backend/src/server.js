/*const express = require('express');
const cors = require('cors');
require('dotenv').config();
require('./config/db');

const app = express();

app.use(cors({
    origin: [
        'https://Rafa-MMf.github.io' // Substituir URL real do GitHub Pages
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}));

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Servidor Cantinhos Encantados rodando!');
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});*/

import express from "express";
import pool from "./config/db.js";

const app = express();
app.use(express.json());

app.get("/teste-banco", async (req, res) => {
  try {
    const [rows] = await pool.query("SHOW TABLES");
    res.json({
      status: "Banco conectado com sucesso",
      tabelas: rows
    });
  } catch (error) {
    res.status(500).json({
      erro: error.message
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
