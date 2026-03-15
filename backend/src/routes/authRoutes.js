import express from "express";

import {
 cadastro,
 login
} from "../controllers/authController.js";

const router = express.Router();

router.post("/cadastro", cadastro);

router.post("/login", login);

export default router;