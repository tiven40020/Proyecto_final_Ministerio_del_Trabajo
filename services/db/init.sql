-- ============================================================
--  init.sql — Base de datos Ministerio del Trabajo
-- ============================================================

CREATE DATABASE IF NOT EXISTS mintrabajo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mintrabajo_db;

-- Tabla de PQRS ciudadanas
CREATE TABLE IF NOT EXISTS pqrs (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ciudadano  VARCHAR(150) NOT NULL,
    tipo              ENUM('Petición', 'Queja', 'Reclamo', 'Sugerencia') NOT NULL,
    descripcion       TEXT NOT NULL,
    estado            ENUM('Pendiente', 'En trámite', 'Resuelto') DEFAULT 'Pendiente',
    fecha_creacion    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de inspecciones laborales
CREATE TABLE IF NOT EXISTS inspecciones (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    empresa          VARCHAR(200) NOT NULL,
    nit              VARCHAR(20)  NOT NULL,
    inspector        VARCHAR(150) NOT NULL,
    tipo_inspeccion  VARCHAR(100),
    resultado        ENUM('Favorable', 'Con observaciones', 'Sancionable') DEFAULT 'Favorable',
    fecha_visita     DATE NOT NULL,
    observaciones    TEXT
);

-- Datos de prueba — PQRS
INSERT INTO pqrs (nombre_ciudadano, tipo, descripcion, estado) VALUES
('Carlos Andrés López Ríos',    'Petición',    'Solicito información sobre el proceso de registro de contrato de trabajo.', 'En trámite'),
('María Fernanda Gómez',        'Queja',       'Mi empleador no me ha pagado las prestaciones sociales del último trimestre.', 'Pendiente'),
('Jorge Alberto Vargas',        'Reclamo',     'Fui despedido sin justa causa y no he recibido liquidación completa.', 'Resuelto'),
('Luisa Alejandra Martínez',    'Sugerencia',  'Propongo habilitar un canal de atención prioritaria para adultos mayores.', 'Pendiente'),
('Andrés Felipe Castillo',      'Petición',    'Requiero certificado de afiliación al Sistema de Seguridad Social.', 'En trámite');

-- Datos de prueba — Inspecciones
INSERT INTO inspecciones (empresa, nit, inspector, tipo_inspeccion, resultado, fecha_visita, observaciones) VALUES
('Textiles del Pacífico S.A.S.',   '900123456-1', 'Dra. Ana Rojas',     'Condiciones laborales',   'Con observaciones', '2025-03-15', 'Se encontraron irregularidades en los horarios de descanso.'),
('Constructora Los Andes Ltda.',   '800654321-2', 'Dr. Pedro Salinas',  'Seguridad industrial',    'Favorable',         '2025-04-02', 'La empresa cumple con todas las normas de seguridad.'),
('Supermercados El Ahorro S.A.',   '901234567-3', 'Dra. Gloria Henao',  'Nómina y prestaciones',   'Sancionable',       '2025-04-18', 'Irregularidades graves en el pago de horas extras.');
