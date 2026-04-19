SET NAMES utf8mb4;
SET time_zone = "+00:00";
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS eventos_registros;
DROP TABLE IF EXISTS registros;
DROP TABLE IF EXISTS eventos;
DROP TABLE IF EXISTS ponentes;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS regalos;
DROP TABLE IF EXISTS paquetes;
DROP TABLE IF EXISTS horas;
DROP TABLE IF EXISTS dias;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(60) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE dias (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(30) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE horas (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  hora VARCHAR(20) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE paquetes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(60) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE regalos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  apellido VARCHAR(80) NOT NULL,
  email VARCHAR(120) NOT NULL,
  password VARCHAR(255) NOT NULL,
  confirmado TINYINT(1) NOT NULL DEFAULT 0,
  token VARCHAR(20) NOT NULL DEFAULT '',
  admin TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ponentes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  apellido VARCHAR(80) NOT NULL,
  ciudad VARCHAR(80) NOT NULL,
  pais VARCHAR(80) NOT NULL,
  imagen VARCHAR(32) NOT NULL,
  tags TEXT NOT NULL,
  redes TEXT NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE eventos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(120) NOT NULL,
  descripcion TEXT NOT NULL,
  disponibles INT UNSIGNED NOT NULL DEFAULT 0,
  categoria_id INT UNSIGNED NOT NULL,
  dia_id INT UNSIGNED NOT NULL,
  hora_id INT UNSIGNED NOT NULL,
  ponente_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  KEY idx_eventos_categoria (categoria_id),
  KEY idx_eventos_dia (dia_id),
  KEY idx_eventos_hora (hora_id),
  KEY idx_eventos_ponente (ponente_id),
  CONSTRAINT fk_eventos_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id),
  CONSTRAINT fk_eventos_dia FOREIGN KEY (dia_id) REFERENCES dias(id),
  CONSTRAINT fk_eventos_hora FOREIGN KEY (hora_id) REFERENCES horas(id),
  CONSTRAINT fk_eventos_ponente FOREIGN KEY (ponente_id) REFERENCES ponentes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE registros (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  paquete_id INT UNSIGNED NOT NULL,
  pago_id VARCHAR(100) NOT NULL DEFAULT '',
  token CHAR(8) NOT NULL,
  usuario_id INT UNSIGNED NOT NULL,
  regalo_id INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id),
  UNIQUE KEY uq_registros_token (token),
  UNIQUE KEY uq_registros_usuario (usuario_id),
  KEY idx_registros_paquete (paquete_id),
  KEY idx_registros_regalo (regalo_id),
  CONSTRAINT fk_registros_paquete FOREIGN KEY (paquete_id) REFERENCES paquetes(id),
  CONSTRAINT fk_registros_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CONSTRAINT fk_registros_regalo FOREIGN KEY (regalo_id) REFERENCES regalos(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE eventos_registros (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  evento_id INT UNSIGNED NOT NULL,
  registro_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_evento_registro (evento_id, registro_id),
  KEY idx_eventos_registros_registro (registro_id),
  CONSTRAINT fk_eventos_registros_evento FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE,
  CONSTRAINT fk_eventos_registros_registro FOREIGN KEY (registro_id) REFERENCES registros(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

START TRANSACTION;

INSERT INTO categorias (id, nombre) VALUES
  (1, 'Conferencias'),
  (2, 'Workshops');

INSERT INTO dias (id, nombre) VALUES
  (1, 'Viernes'),
  (2, 'Sabado');

INSERT INTO horas (id, hora) VALUES
  (1, '09:00 AM'),
  (2, '10:00 AM'),
  (3, '11:00 AM'),
  (4, '12:00 PM'),
  (5, '01:00 PM'),
  (6, '02:00 PM'),
  (7, '03:00 PM'),
  (8, '04:00 PM');

INSERT INTO paquetes (id, nombre) VALUES
  (1, 'Presencial'),
  (2, 'Virtual'),
  (3, 'Gratis');

INSERT INTO regalos (id, nombre) VALUES
  (1, 'Paquete Stickers'),
  (2, 'Camiseta'),
  (3, 'Taza'),
  (4, 'Libreta');

INSERT INTO usuarios (id, nombre, apellido, email, password, confirmado, token, admin) VALUES
  (1, 'Admin', 'DevWebCamp', 'admin@devwebcamp.test', '$2y$10$vXL8gTDYR3iJu3ABYgtlDul8iLiNsUgvKgMSdYM/Ggc5nfpJwkEf2', 1, '', 1),
  (2, 'Ana', 'Asistente', 'ana@devwebcamp.test', '$2y$10$vXL8gTDYR3iJu3ABYgtlDul8iLiNsUgvKgMSdYM/Ggc5nfpJwkEf2', 1, '', 0);

INSERT INTO ponentes (id, nombre, apellido, ciudad, pais, imagen, tags, redes) VALUES
  (1, 'Juan', 'Lopez', 'Quito', 'Ecuador', '0012c51057d1da108500b2d2dc607490', 'PHP,Laravel,MySQL', '{"twitter":"https://x.com/codigoconjuan","github":"https://github.com"}'),
  (2, 'Maria', 'Perez', 'Bogota', 'Colombia', '06c3972d0b88f5ef25707058e884fc66', 'JavaScript,Node.js,TypeScript', '{"instagram":"https://instagram.com","github":"https://github.com"}'),
  (3, 'Carlos', 'Gomez', 'Lima', 'Peru', '0ce9a8963fdd9ddb8514c7b2c08cc4e7', 'UX,UI,Design Systems', '{"youtube":"https://youtube.com","tiktok":"https://tiktok.com"}');

INSERT INTO eventos (id, nombre, descripcion, disponibles, categoria_id, dia_id, hora_id, ponente_id) VALUES
  (1, 'Laravel para APIs', 'Buenas practicas para construir APIs robustas con Laravel.', 40, 1, 1, 1, 1),
  (2, 'Escalando Node.js', 'Patrones y arquitectura para aplicaciones Node.js en produccion.', 35, 1, 1, 2, 2),
  (3, 'Diseno de interfaces modernas', 'Principios practicos para mejorar experiencia de usuario.', 30, 2, 1, 3, 3),
  (4, 'Clean Architecture en PHP', 'Aplicando arquitectura limpia en proyectos reales.', 50, 1, 2, 2, 1),
  (5, 'Testing de extremo a extremo', 'Estrategias para pruebas funcionales y de integracion.', 25, 2, 2, 4, 2),
  (6, 'Sistema de diseno desde cero', 'Workshop para construir y documentar un design system.', 20, 2, 2, 6, 3);

INSERT INTO registros (id, paquete_id, pago_id, token, usuario_id, regalo_id) VALUES
  (1, 1, 'PAY-DEVWEBCAMP-DEMO-001', 'A1B2C3D4', 2, 2);

INSERT INTO eventos_registros (id, evento_id, registro_id) VALUES
  (1, 1, 1),
  (2, 3, 1);

COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
