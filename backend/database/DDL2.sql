-- =========================================================
-- 1) PESSOAS E ACESSO
-- =========================================================
CREATE TABLE usuarios (
  id_usuario        BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(120)          NOT NULL,
  email             VARCHAR(180)          NOT NULL UNIQUE,
  senha_hash        VARCHAR(255)          NOT NULL,
  tipo              ENUM('COMUM','PROPRIETARIO','ADMIN') NOT NULL DEFAULT 'COMUM',
  criado_em         DATETIME              NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em     DATETIME              NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================================
-- 2) CATÁLOGO DE CAFETERIAS
-- =========================================================
CREATE TABLE cafeterias (
  id_cafeteria      BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(150)          NOT NULL,
  descricao         TEXT                  NULL,
  endereco          VARCHAR(200)          NULL,
  bairro            VARCHAR(100)          NULL,
  cidade            VARCHAR(80)           NOT NULL DEFAULT 'Belo Horizonte',
  estado            CHAR(2)               NOT NULL DEFAULT 'MG',
  faixa_preco       ENUM('BAIXO','MEDIO','ALTO') NULL,
  telefone          VARCHAR(20)           NULL,
  site              VARCHAR(200)          NULL,
  instagram         VARCHAR(100)          NULL,
  ativo             TINYINT(1)            NOT NULL DEFAULT 1,
  criado_em         DATETIME              NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em     DATETIME              NULL ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_bairro (bairro),
  INDEX idx_faixa_preco (faixa_preco),
  INDEX idx_ativo (ativo)
) ENGINE=InnoDB;

-- =========================================================
-- PROPRIETÁRIO X CAFETERIA
-- =========================================================
CREATE TABLE proprietario_cafeteria (
  id_usuario        BIGINT NOT NULL,
  id_cafeteria      BIGINT NOT NULL,
  criado_em         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_cafeteria),
  CONSTRAINT fk_pc_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_pc_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria)
) ENGINE=InnoDB;

-- =========================================================
-- FAVORITOS
-- =========================================================
CREATE TABLE favoritos (
  id_usuario        BIGINT NOT NULL,
  id_cafeteria      BIGINT NOT NULL,
  criado_em         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_cafeteria),
  CONSTRAINT fk_fav_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_fav_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),

  INDEX idx_fav_cafeteria (id_cafeteria)
) ENGINE=InnoDB;

-- =========================================================
-- 3) TAXONOMIAS
-- =========================================================
CREATE TABLE categorias (
  id_categoria      BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE estilos (
  id_estilo         BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE tipos_cardapio (
  id_tipo           BIGINT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE cafeteria_categoria (
  id_cafeteria      BIGINT NOT NULL,
  id_categoria      BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_categoria),
  FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
) ENGINE=InnoDB;

CREATE TABLE cafeteria_estilo (
  id_cafeteria      BIGINT NOT NULL,
  id_estilo         BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_estilo),
  FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_estilo)    REFERENCES estilos(id_estilo)
) ENGINE=InnoDB;

CREATE TABLE cafeteria_tipo_cardapio (
  id_cafeteria      BIGINT NOT NULL,
  id_tipo           BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_tipo),
  FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_tipo)      REFERENCES tipos_cardapio(id_tipo)
) ENGINE=InnoDB;

-- =========================================================
-- 4) VÍDEOS
-- =========================================================
CREATE TABLE videos (
  id_video              BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria          BIGINT NOT NULL,
  id_usuario            BIGINT NULL,
  plataforma            ENUM('TIKTOK','INSTAGRAM','YOUTUBE','OUTRO') NOT NULL,
  url                   VARCHAR(300) NOT NULL,
  status                ENUM('PENDENTE','APROVADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  destaque              TINYINT(1) NOT NULL DEFAULT 0,
  id_admin_aprovador    BIGINT NULL,
  aprovado_em           DATETIME NULL,
  criado_em             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_usuario)         REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),

  INDEX idx_vid_status (status),
  INDEX idx_vid_cafe_status (id_cafeteria, status),
  INDEX idx_vid_cafe_data (id_cafeteria, criado_em)
) ENGINE=InnoDB;

-- =========================================================
-- 5) CUPONS
-- =========================================================
CREATE TABLE cupons (
  id_cupom             BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria         BIGINT NOT NULL,
  titulo               VARCHAR(120) NOT NULL,
  descricao            VARCHAR(255) NOT NULL,
  codigo               VARCHAR(40) NOT NULL,
  data_inicio          DATETIME NOT NULL,
  data_fim             DATETIME NOT NULL,
  limite_total         INT NULL,
  limite_por_usuario   INT NOT NULL DEFAULT 1,
  status               ENUM('RASCUNHO','PENDENTE','APROVADO','ATIVO','EXPIRADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  id_proprietario      BIGINT NOT NULL,
  id_admin_aprovador   BIGINT NULL,
  aprovado_em          DATETIME NULL,
  criado_em            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_proprietario)    REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),

  UNIQUE KEY uq_codigo_por_cafe (id_cafeteria, codigo),
  INDEX idx_cpn_cafe_status (id_cafeteria, status),
  INDEX idx_cpn_cafe_periodo (id_cafeteria, data_inicio, data_fim)
) ENGINE=InnoDB;

CREATE TABLE resgates_cupons (
  id_resgate       BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cupom         BIGINT NOT NULL,
  id_usuario       BIGINT NOT NULL,
  resgatado_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (id_cupom)   REFERENCES cupons(id_cupom),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),

  UNIQUE KEY uq_resgate_unico (id_cupom, id_usuario),
  INDEX idx_resg_cupom (id_cupom),
  INDEX idx_resg_data (resgatado_em)
) ENGINE=InnoDB;

-- =========================================================
-- 6) DESTAQUES
-- =========================================================
CREATE TABLE destaques (
  id_destaque          BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria         BIGINT NOT NULL,
  id_proprietario      BIGINT NOT NULL,
  plano                ENUM('BASICO','PLUS','PREMIUM') NOT NULL,
  data_inicio          DATETIME NOT NULL,
  data_fim             DATETIME NOT NULL,
  status               ENUM('PENDENTE','APROVADO','ATIVO','EXPIRADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  referencia_pagamento VARCHAR(100) NULL,
  id_admin_aprovador   BIGINT NULL,
  aprovado_em          DATETIME NULL,
  criado_em            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_proprietario)    REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),

  INDEX idx_dst_cafe_status (id_cafeteria, status),
  INDEX idx_dst_cafe_periodo (id_cafeteria, data_inicio, data_fim)
) ENGINE=InnoDB;

-- =========================================================
-- 7) AVALIAÇÕES
-- =========================================================
CREATE TABLE avaliacoes (
  id_avaliacao     BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria     BIGINT NOT NULL,
  id_usuario       BIGINT NOT NULL,
  valor            TINYINT NOT NULL CHECK (valor IN (0,1)),
  criado_em        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),

  UNIQUE KEY uq_avaliacao_unica (id_cafeteria, id_usuario),
  INDEX idx_av_cafe_valor (id_cafeteria, valor),
  INDEX idx_av_cafe_data (id_cafeteria, criado_em)
) ENGINE=InnoDB;

SHOW TABLES;