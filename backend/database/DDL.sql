-- === Base de dados ===
CREATE DATABASE IF NOT EXISTS cantinhos_bh
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE cantinhos_bh;

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

-- vínculo N:N (proprietário x cafeteria)
CREATE TABLE proprietario_cafeteria (
  id_usuario        BIGINT NOT NULL,
  id_cafeteria      BIGINT NOT NULL,
  criado_em         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_cafeteria),
  CONSTRAINT fk_pc_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_pc_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria)
) ENGINE=InnoDB;

-- favoritos (N:N usuário x cafeteria)
CREATE TABLE favoritos (
  id_usuario        BIGINT NOT NULL,
  id_cafeteria      BIGINT NOT NULL,
  criado_em         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_cafeteria),
  CONSTRAINT fk_fav_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_fav_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria)
) ENGINE=InnoDB;

-- =========================================================
-- 3) TAXONOMIAS (FILTROS)
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

-- ligações N:N
CREATE TABLE cafeteria_categoria (
  id_cafeteria      BIGINT NOT NULL,
  id_categoria      BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_categoria),
  CONSTRAINT fk_cc_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_cc_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
) ENGINE=InnoDB;

CREATE TABLE cafeteria_estilo (
  id_cafeteria      BIGINT NOT NULL,
  id_estilo         BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_estilo),
  CONSTRAINT fk_ce_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_ce_estilo    FOREIGN KEY (id_estilo)    REFERENCES estilos(id_estilo)
) ENGINE=InnoDB;

CREATE TABLE cafeteria_tipo_cardapio (
  id_cafeteria      BIGINT NOT NULL,
  id_tipo           BIGINT NOT NULL,
  PRIMARY KEY (id_cafeteria, id_tipo),
  CONSTRAINT fk_ctc_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_ctc_tipo      FOREIGN KEY (id_tipo)      REFERENCES tipos_cardapio(id_tipo)
) ENGINE=InnoDB;

-- =========================================================
-- 4) CONTEÚDO EM VÍDEO (EMBEDS) + APROVAÇÃO
-- =========================================================
CREATE TABLE videos (
  id_video              BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria          BIGINT           NOT NULL,
  id_usuario            BIGINT           NULL, -- quem enviou
  plataforma            ENUM('TIKTOK','INSTAGRAM','YOUTUBE','OUTRO') NOT NULL,
  url                   VARCHAR(300)     NOT NULL,
  status                ENUM('PENDENTE','APROVADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  destaque              TINYINT(1)       NOT NULL DEFAULT 0,
  id_admin_aprovador    BIGINT           NULL,
  aprovado_em           DATETIME         NULL,
  criado_em             DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_vid_cafeteria FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_vid_usuario   FOREIGN KEY (id_usuario)         REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_vid_admin     FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),
  INDEX idx_vid_status (status),
  INDEX idx_vid_plataforma (plataforma),
  INDEX idx_vid_dest (destaque)
) ENGINE=InnoDB;

-- =========================================================
-- 5) CUPONS E RESGATES
-- =========================================================
CREATE TABLE cupons (
  id_cupom             BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria         BIGINT           NOT NULL,
  titulo               VARCHAR(120)     NOT NULL,
  descricao            VARCHAR(255)     NOT NULL,
  codigo               VARCHAR(40)      NOT NULL,
  data_inicio          DATETIME         NOT NULL,
  data_fim             DATETIME         NOT NULL,
  limite_total         INT              NULL,
  limite_por_usuario   INT              NOT NULL DEFAULT 1,
  status               ENUM('RASCUNHO','PENDENTE','APROVADO','ATIVO','EXPIRADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  id_proprietario      BIGINT           NOT NULL,
  id_admin_aprovador   BIGINT           NULL,
  aprovado_em          DATETIME         NULL,
  criado_em            DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cpn_cafeteria FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_cpn_propriet  FOREIGN KEY (id_proprietario)    REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_cpn_admin     FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),
  UNIQUE KEY uq_codigo_por_cafe (id_cafeteria, codigo),
  INDEX idx_cpn_status (status),
  INDEX idx_cpn_inicio (data_inicio),
  INDEX idx_cpn_fim (data_fim)
) ENGINE=InnoDB;

CREATE TABLE resgates_cupons (
  id_resgate       BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cupom         BIGINT NOT NULL,
  id_usuario       BIGINT NOT NULL,
  resgatado_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_resg_cupom  FOREIGN KEY (id_cupom)   REFERENCES cupons(id_cupom),
  CONSTRAINT fk_resg_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  UNIQUE KEY uq_resgate_unico (id_cupom, id_usuario) -- garante 1 resgate por usuário
) ENGINE=InnoDB;

-- =========================================================
-- 6) DESTAQUE PAGO (PATROCÍNIO)
-- =========================================================
CREATE TABLE destaques (
  id_destaque          BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria         BIGINT        NOT NULL,
  id_proprietario      BIGINT        NOT NULL,
  plano                ENUM('BASICO','PLUS','PREMIUM') NOT NULL,
  data_inicio          DATETIME      NOT NULL,
  data_fim             DATETIME      NOT NULL,
  status               ENUM('PENDENTE','APROVADO','ATIVO','EXPIRADO','REJEITADO') NOT NULL DEFAULT 'PENDENTE',
  referencia_pagamento VARCHAR(100)  NULL,
  id_admin_aprovador   BIGINT        NULL,
  aprovado_em          DATETIME      NULL,
  criado_em            DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_dst_cafeteria FOREIGN KEY (id_cafeteria)       REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_dst_propriet  FOREIGN KEY (id_proprietario)    REFERENCES usuarios(id_usuario),
  CONSTRAINT fk_dst_admin     FOREIGN KEY (id_admin_aprovador) REFERENCES usuarios(id_usuario),
  INDEX idx_dst_status (status),
  INDEX idx_dst_inicio (data_inicio),
  INDEX idx_dst_fim (data_fim)
) ENGINE=InnoDB;

-- =========================================================
-- 7) FEEDBACK (LIKE/DISLIKE)
-- =========================================================
CREATE TABLE avaliacoes (
  id_avaliacao     BIGINT PRIMARY KEY AUTO_INCREMENT,
  id_cafeteria     BIGINT     NOT NULL,
  id_usuario       BIGINT     NOT NULL,
  valor            TINYINT    NOT NULL,  -- 1 = curtiu, 0 = não curtiu
  criado_em        DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_av_cafeteria FOREIGN KEY (id_cafeteria) REFERENCES cafeterias(id_cafeteria),
  CONSTRAINT fk_av_usuario   FOREIGN KEY (id_usuario)   REFERENCES usuarios(id_usuario),
  UNIQUE KEY uq_avaliacao_unica (id_cafeteria, id_usuario)
) ENGINE=InnoDB;
