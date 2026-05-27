<?php
// ============================================================
//  Portal Ciudadano — Ministerio del Trabajo
//  Módulo PQRS con conexión a MySQL
// ============================================================

$host   = 'mysql-db';
$user   = 'mintrabajo';
$pass   = 'mintrabajo123';
$db     = 'mintrabajo_db';

$conn = new mysqli($host, $user, $pass, $db);

$mensaje = '';
$tipo_msg = '';

// Insertar nueva PQRS
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['nombre'])) {
    $nombre      = $conn->real_escape_string($_POST['nombre']);
    $tipo        = $conn->real_escape_string($_POST['tipo']);
    $descripcion = $conn->real_escape_string($_POST['descripcion']);
    $sql = "INSERT INTO pqrs (nombre_ciudadano, tipo, descripcion) VALUES ('$nombre', '$tipo', '$descripcion')";
    if ($conn->query($sql)) {
        $mensaje  = '✅ PQRS radicada exitosamente.';
        $tipo_msg = 'success';
    } else {
        $mensaje  = '❌ Error al radicar: ' . $conn->error;
        $tipo_msg = 'error';
    }
}

// Consultar PQRS existentes
$pqrs = $conn->query("SELECT * FROM pqrs ORDER BY fecha_creacion DESC LIMIT 10");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>PQRS — Ministerio del Trabajo</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background:#f4f6f9; margin:0; }
        header { background:#003366; color:white; padding:20px 40px; }
        header h1 { font-size:1.4rem; }
        .container { max-width:900px; margin:30px auto; padding:0 20px; }
        .card { background:white; border-radius:8px; padding:25px; margin-bottom:25px;
                box-shadow:0 2px 8px rgba(0,0,0,.1); border-top:4px solid #0055a5; }
        h2 { color:#003366; margin-bottom:15px; }
        label { display:block; margin-bottom:5px; font-weight:600; color:#444; font-size:.9rem; }
        input, select, textarea {
            width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;
            margin-bottom:15px; font-size:.9rem; box-sizing:border-box;
        }
        button { background:#0055a5; color:white; border:none; padding:12px 30px;
                 border-radius:5px; cursor:pointer; font-size:1rem; }
        button:hover { background:#003366; }
        .alert { padding:12px 18px; border-radius:5px; margin-bottom:20px; font-weight:600; }
        .success { background:#d4edda; color:#155724; border:1px solid #c3e6cb; }
        .error   { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
        table { width:100%; border-collapse:collapse; font-size:.88rem; }
        th { background:#003366; color:white; padding:10px; text-align:left; }
        td { padding:9px 10px; border-bottom:1px solid #eee; }
        tr:nth-child(even) td { background:#f9f9f9; }
        .badge { padding:3px 10px; border-radius:12px; font-size:.78rem; font-weight:600; color:white; }
        .Petición  { background:#0055a5; }
        .Queja     { background:#dc3545; }
        .Reclamo   { background:#fd7e14; }
        .Sugerencia{ background:#28a745; }
        .db-status { font-size:.82rem; color:#666; margin-bottom:10px; }
        .db-ok  { color:#28a745; }
        .db-err { color:#dc3545; }
    </style>
</head>
<body>
<header>
    <h1>🏛️ Ministerio del Trabajo — Sistema PQRS</h1>
</header>
<div class="container">

    <!-- Estado conexión DB -->
    <p class="db-status">
        Estado BD:
        <?php if ($conn->connect_error): ?>
            <span class="db-err">❌ Sin conexión (<?= $conn->connect_error ?>)</span>
        <?php else: ?>
            <span class="db-ok">✅ Conectado a MySQL (<?= $host ?>)</span>
        <?php endif; ?>
    </p>

    <?php if ($mensaje): ?>
        <div class="alert <?= $tipo_msg ?>"><?= $mensaje ?></div>
    <?php endif; ?>

    <!-- Formulario -->
    <div class="card">
        <h2>📋 Radicar nueva PQRS</h2>
        <form method="POST">
            <label>Nombre completo</label>
            <input type="text" name="nombre" placeholder="Ej: Juan Pérez García" required>
            <label>Tipo de solicitud</label>
            <select name="tipo" required>
                <option value="">— Seleccione —</option>
                <option value="Petición">Petición</option>
                <option value="Queja">Queja</option>
                <option value="Reclamo">Reclamo</option>
                <option value="Sugerencia">Sugerencia</option>
            </select>
            <label>Descripción</label>
            <textarea name="descripcion" rows="4" placeholder="Describa su solicitud..." required></textarea>
            <button type="submit">Radicar PQRS</button>
        </form>
    </div>

    <!-- Tabla PQRS -->
    <div class="card">
        <h2>📂 PQRS Registradas</h2>
        <?php if ($conn->connect_error): ?>
            <p style="color:#dc3545;">No se puede mostrar el listado: sin conexión a la base de datos.</p>
        <?php else: ?>
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Ciudadano</th><th>Tipo</th><th>Descripción</th><th>Fecha</th>
                </tr>
            </thead>
            <tbody>
            <?php while ($row = $pqrs->fetch_assoc()): ?>
                <tr>
                    <td><?= $row['id'] ?></td>
                    <td><?= htmlspecialchars($row['nombre_ciudadano']) ?></td>
                    <td><span class="badge <?= $row['tipo'] ?>"><?= $row['tipo'] ?></span></td>
                    <td><?= htmlspecialchars(substr($row['descripcion'], 0, 80)) ?>...</td>
                    <td><?= $row['fecha_creacion'] ?></td>
                </tr>
            <?php endwhile; ?>
            </tbody>
        </table>
        <?php endif; ?>
    </div>

</div>
</body>
</html>
<?php $conn->close(); ?>
