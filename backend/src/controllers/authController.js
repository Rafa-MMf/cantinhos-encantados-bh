import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import {
 criarUsuario,
 buscarPorEmail
} from "../models/userModel.js";

export async function cadastro(req, res) {

 try {

  const { nome, email, senha, tipo } = req.body;

  const senhaHash = await bcrypt.hash(senha, 10);

  await criarUsuario(
   nome,
   email,
   senhaHash,
   tipo || "usuario"
  );

  res.json({
   message: "Usuário criado com sucesso"
  });

 } catch (error) {

  res.status(500).json(error);

 }

}

export async function login(req, res) {

 try {

  const { email, senha } = req.body;

  const usuario = await buscarPorEmail(email);

  if (!usuario) {

   return res.status(404).json({
    message: "Usuário não encontrado"
   });

  }

  const senhaValida = await bcrypt.compare(
   senha,
   usuario.senha_hash
  );

  if (!senhaValida) {

   return res.status(401).json({
    message: "Senha inválida"
   });

  }

  const token = jwt.sign(

   {
    id: usuario.id_usuario,
    tipo: usuario.tipo
   },

   process.env.JWT_SECRET,

   { expiresIn: "1d" }

  );

  res.json({
   token,
   usuario
  });

 } catch (error) {

  res.status(500).json(error);

 }

}