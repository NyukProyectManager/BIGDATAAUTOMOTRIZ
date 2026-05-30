USE master
GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'DatamartAutoMotors')
BEGIN
    ALTER DATABASE DatamartAutoMotors SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE DatamartAutoMotors
END
GO

CREATE DATABASE DatamartAutoMotors
GO

USE DatamartAutoMotors
GO


/* dim_cliente
   Describe al comprador: nombre, tipo (natural o empresa)
   y departamento. Permite analizar ventas por perfil de cliente. */
CREATE TABLE dim_cliente (
    id_cliente   INT PRIMARY KEY IDENTITY,
    pk_cliente   VARCHAR(10),
    nombre       VARCHAR(150),
    tipo_cliente VARCHAR(30),
    departamento VARCHAR(50)
)
GO

/* dim_vehiculo
   Describe el vehiculo vendido: marca, segmento, año y transmision.
   Permite analizar que tipos de vehiculo tienen mayor demanda. */
CREATE TABLE dim_vehiculo (
    id_vehiculo INT PRIMARY KEY IDENTITY,
    pk_vehiculo INT,
    nombre      VARCHAR(100),
    marca       VARCHAR(50),
    segmento    VARCHAR(50),
    anio        SMALLINT,
    transmision VARCHAR(20)
)
GO

/* dim_vendedor
   Describe al vendedor: nombre, puesto y departamento.
   Permite medir el rendimiento individual del equipo comercial. */
CREATE TABLE dim_vendedor (
    id_vendedor INT PRIMARY KEY IDENTITY,
    pk_vendedor INT,
    nombre      VARCHAR(110),
    puesto      VARCHAR(50),
    departamento VARCHAR(50)
)
GO

/* dim_tiempo
   Dimension de fecha con atributos de calendario.
   Permite analisis por dia, mes, trimestre y año. */
CREATE TABLE dim_tiempo (
    fecha     DATE PRIMARY KEY,
    anio      SMALLINT,
    mes       SMALLINT,
    diaMes    SMALLINT,
    diaSemana VARCHAR(15),
    trimestre SMALLINT,
    nomMes    VARCHAR(15)
)
GO

/* dim_canal
   Canal de venta por el que se origino la transaccion.
   (Sala de Exhibicion, Web, Telefono, WhatsApp)
   Permite evaluar que canal genera mas ingresos. */
CREATE TABLE dim_canal (
    id_canal    INT PRIMARY KEY IDENTITY,
    pk_canal    INT,
    nombreCanal VARCHAR(50)
)
GO

/* dim_metodoPago
   Forma de pago utilizada en la venta.
   (Efectivo, Tarjeta, Transferencia, Financiamiento)
   Permite analizar preferencias de pago por segmento. */
CREATE TABLE dim_metodoPago (
    id_metodoP   INT PRIMARY KEY IDENTITY,
    pk_metodoP   INT,
    nombreMetodo VARCHAR(50)
)
GO


/* TABLAS STAGING
   Reciben datos crudos de archivos planos antes de pasarlos
   a las dimensiones. Son el area de preparacion del ETL.*/

/* stg_operacionVenta
   Recibe el archivo operacionVenta_auto.txt con el canal y
   metodo de pago de cada venta del sistema OLTP. */
CREATE TABLE stg_operacionVenta (
    idVenta    INT PRIMARY KEY,
    metodoPago INT,
    canal      INT
)
GO

/* stg_canal - staging previo a dim_canal */
CREATE TABLE stg_canal (
    pk_canal    INT,
    nombreCanal VARCHAR(50)
)
GO

/* stg_metodoPago - staging previo a dim_metodoPago */
CREATE TABLE stg_metodoPago (
    pk_metodoP   INT,
    nombreMetodo VARCHAR(50)
)
GO


/*TABLA DE HECHOS: fac_ventas
   Almacena las medidas cuantitativas de cada transaccion de venta. */
CREATE TABLE fac_ventas (
    id_venta    INT PRIMARY KEY IDENTITY,
    id_cliente  INT REFERENCES dim_cliente,
    id_vehiculo INT REFERENCES dim_vehiculo,
    id_vendedor INT REFERENCES dim_vendedor,
    id_canal    INT REFERENCES dim_canal,
    id_metodoP  INT REFERENCES dim_metodoPago,
    fecha       DATE REFERENCES dim_tiempo,
    cantidad    INT,
    subTotal    MONEY,
    descuento   MONEY,
    total       MONEY
)
GO
