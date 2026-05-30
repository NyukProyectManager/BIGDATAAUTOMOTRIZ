USE DatamartAutoMotors
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO

/* Corregir tamaños de columnas UNA SOLA VEZ */
ALTER TABLE stg_canal
ALTER COLUMN nombreCanal VARCHAR(100)
GO

ALTER TABLE dim_canal
ALTER COLUMN nombreCanal VARCHAR(100)
GO

ALTER TABLE stg_metodoPago
ALTER COLUMN nombreMetodo VARCHAR(100)
GO

ALTER TABLE dim_metodoPago
ALTER COLUMN nombreMetodo VARCHAR(100)
GO

/* Limpiar tablas */
DELETE FROM fac_ventas
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('fac_ventas', RESEED, 0)
GO

DELETE FROM dim_vehiculo
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_vehiculo', RESEED, 0)
GO

DELETE FROM dim_cliente
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_cliente', RESEED, 0)
GO

DELETE FROM dim_vendedor
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_vendedor', RESEED, 0)
GO

DELETE FROM dim_canal
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_canal', RESEED, 0)
GO

DELETE FROM dim_metodoPago
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_metodoPago', RESEED, 0)
GO

DELETE FROM dim_tiempo
GO

TRUNCATE TABLE stg_operacionVenta
GO

TRUNCATE TABLE stg_canal
GO

TRUNCATE TABLE stg_metodoPago
GO

/* ETL */


USE DatamartAutoMotors
GO

EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1; RECONFIGURE;
GO

DELETE FROM fac_ventas
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('fac_ventas', RESEED, 0)
GO

DELETE FROM dim_vehiculo
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_vehiculo', RESEED, 0)
GO

DELETE FROM dim_cliente
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_cliente', RESEED, 0)
GO

DELETE FROM dim_vendedor
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_vendedor', RESEED, 0)
GO

DELETE FROM dim_canal
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_canal', RESEED, 0)
GO

DELETE FROM dim_metodoPago
IF @@ROWCOUNT <> 0
    DBCC CHECKIDENT ('dim_metodoPago', RESEED, 0)
GO

DELETE FROM dim_tiempo
GO

TRUNCATE TABLE stg_operacionVenta
GO

TRUNCATE TABLE stg_canal
GO

TRUNCATE TABLE stg_metodoPago
GO


/* Cargar dimension CLIENTE
   Extrae clientes del sistema OLTP AutoMotors.
   Se incluye tipo de cliente (natural/empresa) y departamento
   del vendedor que atendio al cliente como referencia geografica. */
USE AutoMotors
GO

INSERT INTO DatamartAutoMotors.dbo.dim_cliente
SELECT
    C.IdCliente        AS pk_cliente,
    C.RazonSocial      AS nombre,
    TC.DesTipoCliente  AS tipo_cliente,
    D.NombreDepartamento AS departamento
FROM Ventas.Clientes C
JOIN Ventas.TiposCliente TC ON TC.IdTipoCliente = C.IdTipoCliente
JOIN Personal.Vendedores VND ON VND.IdVendedor = (
    SELECT TOP 1 IdVendedor
    FROM Ventas.VentasCabe VC
    WHERE VC.IdCliente = C.IdCliente
    ORDER BY VC.FechaVenta
)
JOIN Personal.Departamentos D ON D.IdDepartamento = VND.IdDepartamento
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_cliente
GO


/* Cargar dimension VEHICULO
   Extrae el catalogo de vehiculos del OLTP con la informacion
   de marca y segmento, que son los atributos mas relevantes
   para el analisis comercial.*/
INSERT INTO DatamartAutoMotors.dbo.dim_vehiculo
SELECT
    V.IdVehiculo      AS pk_vehiculo,
    V.NombreVehiculo  AS nombre,
    M.NombreMarca     AS marca,
    S.NombreSegmento  AS segmento,
    V.Anio            AS anio,
    V.Transmision     AS transmision
FROM Inventario.Vehiculos V
JOIN Inventario.Marcas M   ON M.IdMarca    = V.IdMarca
JOIN Inventario.Segmentos S ON S.IdSegmento = V.IdSegmento
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_vehiculo
GO


/* Cargar dimension VENDEDOR
   Extrae el equipo de ventas del OLTP con su puesto y
   departamento para analizar rendimiento geografico e
   individual del equipo comercial.*/
INSERT INTO DatamartAutoMotors.dbo.dim_vendedor
SELECT
    VND.IdVendedor AS pk_vendedor,
    VND.NombreVendedor + ' ' + VND.ApellidoVendedor AS nombre,
    P.DesPuesto    AS puesto,
    D.NombreDepartamento AS departamento
FROM Personal.Vendedores VND
JOIN Personal.Puestos P       ON P.IdPuesto      = VND.IdPuesto
JOIN Personal.Departamentos D ON D.IdDepartamento = VND.IdDepartamento
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_vendedor
GO


/* Cargar dimension TIEMPO
   Genera un registro por cada dia del rango de ventas del OLTP.
   Usa un bucle WHILE para poblar todos los dias consecutivos
   con sus atributos de calendario (anio, mes, trimestre, etc).
*/
DECLARE @inicio DATE, @fin DATE

SELECT
    @inicio = MIN(CAST(FechaVenta AS DATE)),
    @fin    = MAX(CAST(FechaVenta AS DATE))
FROM Ventas.VentasCabe

WHILE (@inicio <= @fin)
BEGIN
    INSERT INTO DatamartAutoMotors.dbo.dim_tiempo
    SELECT
        @inicio AS fecha,
        DATEPART(yyyy, @inicio) AS anio,
        DATEPART(m,    @inicio) AS mes,
        DATEPART(d,    @inicio) AS diaMes,
        CASE DATEPART(dw, @inicio)
            WHEN 1 THEN 'Domingo'
            WHEN 2 THEN 'Lunes'
            WHEN 3 THEN 'Martes'
            WHEN 4 THEN 'Miercoles'
            WHEN 5 THEN 'Jueves'
            WHEN 6 THEN 'Viernes'
            WHEN 7 THEN 'Sabado'
        END AS diaSemana,
        DATEPART(q, @inicio) AS trimestre,
        CASE DATEPART(m, @inicio)
            WHEN 1  THEN 'Enero'
            WHEN 2  THEN 'Febrero'
            WHEN 3  THEN 'Marzo'
            WHEN 4  THEN 'Abril'
            WHEN 5  THEN 'Mayo'
            WHEN 6  THEN 'Junio'
            WHEN 7  THEN 'Julio'
            WHEN 8  THEN 'Agosto'
            WHEN 9  THEN 'Setiembre'
            WHEN 10 THEN 'Octubre'
            WHEN 11 THEN 'Noviembre'
            WHEN 12 THEN 'Diciembre'
        END AS nomMes

    SET @inicio = DATEADD(d, 1, @inicio)
END
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_tiempo
GO


/* Cargar STAGING de operacion de venta
   El archivo operacionVenta_auto.txt contiene el metodo de pago
   y canal de venta de cada transaccion. Esta informacion no
   existe en el OLTP y proviene de un sistema externo. */
USE AutoMotors
GO

BEGIN
    DECLARE @archivo VARCHAR(200)
    SET @archivo = 'C:\txt\operacionVenta_auto.txt'

    DECLARE @sql VARCHAR(MAX)
    SET @sql = 'BULK INSERT DatamartAutoMotors.dbo.stg_operacionVenta' +
               ' FROM ''' + @archivo + ''' WITH (FIELDTERMINATOR =''|'', ROWTERMINATOR = ''\n'', FIRSTROW = 2)'
    EXEC(@sql)
END
GO

SELECT * FROM DatamartAutoMotors.dbo.stg_operacionVenta
GO


/* Cargar dimension CANAL desde archivo plano
   El archivo canales_auto.txt define los canales de venta.
   Se carga primero en staging y luego se pasa a la dimension.
   */
BULK INSERT DatamartAutoMotors.dbo.stg_canal
FROM 'C:\txt\canales_auto.txt'
WITH (FIRSTROW = 1, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

INSERT INTO DatamartAutoMotors.dbo.dim_canal
SELECT * FROM DatamartAutoMotors.dbo.stg_canal
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_canal
GO


/* Cargar dimension METODO DE PAGO desde archivo plano
   El archivo metodopago_auto.txt define las formas de pago.*/
BULK INSERT DatamartAutoMotors.dbo.stg_metodoPago
FROM 'C:\txt\metodopago_auto.txt'
WITH (FIRSTROW = 1, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

INSERT INTO DatamartAutoMotors.dbo.dim_metodoPago
SELECT * FROM DatamartAutoMotors.dbo.stg_metodoPago
GO

SELECT * FROM DatamartAutoMotors.dbo.dim_metodoPago
GO


/* Cargar TABLA DE HECHOS fac_ventas
   Cruza los datos del OLTP (ventas y detalle) con todas las
   dimensiones. Agrupa por las claves dimensionales para obtener
   las medidas consolidadas: cantidad, subtotal, descuento, total.*/
USE AutoMotors
GO

INSERT INTO DatamartAutoMotors.dbo.fac_ventas
SELECT
    D_CL.id_cliente,
    D_VH.id_vehiculo,
    D_VND.id_vendedor,
    D_CA.id_canal,
    D_MP.id_metodoP,
    CAST(VC.FechaVenta AS DATE)                          AS fecha,
    SUM(VD.Cantidad)                                     AS cantidad,
    SUM(VD.Cantidad * VD.PrecioVenta)                    AS subTotal,
    SUM(VD.Cantidad * VD.PrecioVenta * VD.Descuento)     AS descuento,
    SUM(VD.Cantidad * VD.PrecioVenta * (1 - VD.Descuento)) AS total
FROM Ventas.VentasCabe VC
JOIN DatamartAutoMotors.dbo.stg_operacionVenta OP ON OP.idVenta     = VC.IdVenta
JOIN Ventas.VentasDeta VD                         ON VD.IdVenta     = VC.IdVenta
JOIN DatamartAutoMotors.dbo.dim_vehiculo  D_VH    ON D_VH.pk_vehiculo = VD.IdVehiculo
JOIN DatamartAutoMotors.dbo.dim_cliente   D_CL    ON D_CL.pk_cliente  = VC.IdCliente
JOIN DatamartAutoMotors.dbo.dim_vendedor  D_VND   ON D_VND.pk_vendedor = VC.IdVendedor
JOIN DatamartAutoMotors.dbo.dim_canal     D_CA    ON D_CA.pk_canal    = OP.canal
JOIN DatamartAutoMotors.dbo.dim_metodoPago D_MP   ON D_MP.pk_metodoP  = OP.metodoPago
GROUP BY
    D_CL.id_cliente, D_VH.id_vehiculo, D_VND.id_vendedor,
    D_CA.id_canal, D_MP.id_metodoP, CAST(VC.FechaVenta AS DATE)
GO

SELECT * FROM DatamartAutoMotors.dbo.fac_ventas
GO


/*Consultas analiticas sobre el datamart*/
USE DatamartAutoMotors
GO

-- Indicador 1: Ventas e ingresos totales por segmento de vehiculo
SELECT
    DV.segmento,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_vehiculo DV ON DV.id_vehiculo = FV.id_vehiculo
GROUP BY DV.segmento
ORDER BY MontoTotal DESC
GO

-- Indicador 2: Ventas por canal de atencion
SELECT
    DC.nombreCanal,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_canal DC ON DC.id_canal = FV.id_canal
GROUP BY DC.nombreCanal
ORDER BY MontoTotal DESC
GO

-- Indicador 3: Evolucion de ventas por año y trimestre
SELECT
    DT.anio,
    DT.trimestre,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_tiempo DT ON DT.fecha = FV.fecha
GROUP BY DT.anio, DT.trimestre
ORDER BY DT.anio, DT.trimestre
GO

-- Indicador 4: Top 5 vendedores por monto total generado
SELECT TOP 5
    DVN.nombre      AS Vendedor,
    DVN.puesto,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_vendedor DVN ON DVN.id_vendedor = FV.id_vendedor
GROUP BY DVN.nombre, DVN.puesto
ORDER BY MontoTotal DESC
GO

-- Indicador 5: Preferencia por metodo de pago
SELECT
    DMP.nombreMetodo,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_metodoPago DMP ON DMP.id_metodoP = FV.id_metodoP
GROUP BY DMP.nombreMetodo
ORDER BY MontoTotal DESC
GO

-- Indicador 6: Ventas por marca de vehiculo
SELECT
    DV.marca,
    COUNT(*)        AS NumVentas,
    SUM(FV.total)   AS MontoTotal
FROM fac_ventas FV
JOIN dim_vehiculo DV ON DV.id_vehiculo = FV.id_vehiculo
GROUP BY DV.marca
ORDER BY MontoTotal DESC
GO