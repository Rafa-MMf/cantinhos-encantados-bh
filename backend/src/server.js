import express from "express";
import pool from "./config/db.js";

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ status: "API online" });
});

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