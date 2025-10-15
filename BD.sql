CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nombre_usuario VARCHAR(30) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('ADMINISTRADOR', 'DOCENTE', 'ESTUDIANTE')),
    
    -- Campos adicionales útiles
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP,
    estado BOOLEAN DEFAULT TRUE,  -- true = activo, false = inactivo/baneado
    
    -- Seguridad / Auditoría
    verificado BOOLEAN DEFAULT FALSE,     -- si el correo fue verificado
    token_recuperacion VARCHAR(255)       -- para recuperación de contraseña
);
