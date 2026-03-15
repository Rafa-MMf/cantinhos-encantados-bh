import pool from "../config/db.js";

export async function criarUsuario(nome, email, senhaHash, tipo) {

 const [result] = await pool.execute(
  `
  INSERT INTO usuarios (nome, email, senha_hash, tipo)
  VALUES (?, ?, ?, ?)
  `,
  [nome, email, senhaHash, tipo]
 );

 return result;

}

export async function buscarPorEmail(email) {

 const [rows] = await pool.execute(
  `
  SELECT *
  FROM usuarios
  WHERE email = ?
  `,
  [email]
 );

 return rows[0];

}