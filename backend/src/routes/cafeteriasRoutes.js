import express from "express";
import pool from "../config/db.js";

const router = express.Router();


// ✅ CREATE (cadastrar cafeteria)
router.post("/", async (req, res) => {
    const {
        nome,
        descricao,
        endereco,
        bairro,
        faixa_preco,
        telefone,
        site,
        instagram
    } = req.body;

    try {
        const [result] = await pool.execute(`
            INSERT INTO cafeterias 
            (nome, descricao, endereco, bairro, faixa_preco, telefone, site, instagram)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `, [nome, descricao, endereco, bairro, faixa_preco, telefone, site, instagram]);

        res.status(201).json({ id: result.insertId });

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Erro ao cadastrar cafeteria" });
    }
});


// ✅ LISTAGEM PÚBLICA
router.get("/", async (req, res) => {
    try {
        const [rows] = await pool.execute(`
            SELECT * FROM cafeterias
            WHERE ativo = 1
            ORDER BY criado_em DESC
        `);

        res.json(rows);

    } catch (error) {
        res.status(500).json({ error: "Erro ao buscar cafeterias" });
    }
});


// ✅ DETALHE
router.get("/:id", async (req, res) => {
    const { id } = req.params;

    try {
        const [rows] = await pool.execute(
            "SELECT * FROM cafeterias WHERE id_cafeteria = ?",
            [id]
        );

        res.json(rows[0]);

    } catch (error) {
        res.status(500).json({ error: "Erro ao buscar cafeteria" });
    }
});

export default router;