import pool from "../config/db.js";

// ✅ Criar usuário
export async function criarUsuario(nome, email, senhaHash, tipo) {
  try {
    const [result] = await pool.query(
      `
      INSERT INTO usuarios (nome, email, senha_hash, tipo, data_nascimento, telefone)
      VALUES (?, ?, ?, ?, ?, ?)
      `,
      [nome, email, senhaHash, tipo, null, null]
    );

    return result;

  } catch (error) {
    console.error("Erro ao criar usuário:", error);
    throw error;
  }
}

// ✅ Buscar usuário por email
export async function buscarPorEmail(email) {
  try {
    const [rows] = await pool.query(
      `
      SELECT *
      FROM usuarios
      WHERE email = ?
      `,
      [email]
    );

    return rows[0];

  } catch (error) {
    console.error("Erro ao buscar por email:", error);
    throw error;
  }
}

// ✅ Buscar usuário por ID (ESSENCIAL pro perfil)
export async function buscarPorId(id) {
  try {
    const [rows] = await pool.query(
      `
      SELECT nome, tipo, data_nascimento, telefone
      FROM usuarios
      WHERE id_usuario = ?
      `,
      [id]
    );

    return rows[0];

  } catch (error) {
    console.error("ERRO REAL NO BANCO:", error);
    throw error;
  }
}