// Importa o framework Express (servidor web)
import express from "express";

// Importa a conexão com o banco de dados
import pool from "./config/db.js";

// Importa módulos para trabalhar com caminhos de arquivos
import path from "path";
import { fileURLToPath } from "url";

import cors from "cors";
import dotenv from "dotenv";

import authRoutes from "./routes/authRoutes.js";

dotenv.config();

// Cria a aplicação Express
const app = express();

// Permite que o servidor receba JSON nas requisições
app.use(express.json());

/*
========================================
CONFIGURAÇÃO DE CAMINHOS DE PASTA
========================================

Como estamos usando ES Modules (import/export),
precisamos recriar o __dirname manualmente.
*/

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/*
========================================
PASTA DO FRONTEND
========================================

Seu frontend está fora do backend:

CANTINHOSENCANTADOS
   backend/src/server.js
   frontend/index.html

Então precisamos voltar duas pastas e entrar no frontend
*/

const frontendPath = path.join(__dirname, "../public");
const indexPath = path.join(frontendPath, "index.html");

/*
========================================
SERVIR ARQUIVOS ESTÁTICOS
========================================

Isso permite acessar arquivos como:

/css/banner.css
/js/script.js
/img/logo.png
*/

app.use(express.static(frontendPath));

/*
========================================
ROTA PRINCIPAL DO SITE
========================================

Quando alguém abrir:

https://seusite.com

o servidor envia o index.html
*/

app.get("/", (req, res) => {
  res.sendFile(indexPath);
});

/*
========================================
ROTA DE TESTE DA API
========================================

Serve apenas para verificar se o servidor está online
*/

app.get("/api/status", (req, res) => {
  res.json({
    status: "API online"
  });
});

/*
========================================
TESTE DE CONEXÃO COM O BANCO
========================================

Essa rota executa um comando SQL
e retorna as tabelas existentes
*/

app.get("/api/teste-banco", async (req, res) => {
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

/*
========================================
PORTA DO SERVIDOR
========================================

Railway define automaticamente a porta,
por isso usamos process.env.PORT
*/

const PORT = process.env.PORT || 3000;

/*
========================================
INICIAR SERVIDOR
========================================
*/

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});


app.use(cors());

app.use("/auth", authRoutes);

app.listen(process.env.PORT, () => {
 console.log(`Servidor rodando na porta ${process.env.PORT}`);
});

/* Criando rota protegida para testar o middleware de autenticação */
import { verificarToken } from "./middlewares/authMiddleware.js";

app.get("/perfil", verificarToken, (req, res) => {

 res.json({
  message: "Usuário autenticado",
  user: req.user
 });

});
