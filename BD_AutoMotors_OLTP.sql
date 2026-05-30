USE master
GO

IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'AutoMotors')
BEGIN
    ALTER DATABASE AutoMotors SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE AutoMotors
END
GO

CREATE DATABASE AutoMotors
GO

USE AutoMotors
GO

SET DATEFORMAT ymd
GO


CREATE SCHEMA Ventas
GO
CREATE SCHEMA Inventario
GO
CREATE SCHEMA Personal
GO



-- Tabla: Departamentos - ubica geograficamente a los vendedores
CREATE TABLE Personal.Departamentos (
    IdDepartamento INT PRIMARY KEY,
    NombreDepartamento VARCHAR(50) NOT NULL
)
GO

INSERT INTO Personal.Departamentos VALUES (1, 'Lima')
INSERT INTO Personal.Departamentos VALUES (2, 'Arequipa')
INSERT INTO Personal.Departamentos VALUES (3, 'La Libertad')
INSERT INTO Personal.Departamentos VALUES (4, 'Cusco')
INSERT INTO Personal.Departamentos VALUES (5, 'Piura')
GO

-- Tabla: Puestos - jerarquia del personal de ventas
CREATE TABLE Personal.Puestos (
    IdPuesto INT PRIMARY KEY,
    DesPuesto VARCHAR(50) NOT NULL
)
GO

INSERT INTO Personal.Puestos VALUES (1, 'Asesor de Ventas')
INSERT INTO Personal.Puestos VALUES (2, 'Ejecutivo de Ventas')
INSERT INTO Personal.Puestos VALUES (3, 'Supervisor de Ventas')
INSERT INTO Personal.Puestos VALUES (4, 'Gerente Comercial')
GO

-- Tabla: Vendedores - empleados que gestionan las ventas de vehiculos
CREATE TABLE Personal.Vendedores (
    IdVendedor        INT PRIMARY KEY,
    ApellidoVendedor  VARCHAR(50) NOT NULL,
    NombreVendedor    VARCHAR(50) NOT NULL,
    FechaNacimiento   DATETIME NOT NULL,
    DireccionVendedor VARCHAR(100) NOT NULL,
    IdDepartamento    INT REFERENCES Personal.Departamentos,
    TelefonoVendedor  VARCHAR(20) NULL,
    IdPuesto          INT REFERENCES Personal.Puestos,
    FechaIngreso      DATETIME NOT NULL
)
GO

INSERT INTO Personal.Vendedores VALUES (1,'Quispe','Carlos','1985-03-15','Av. Larco 450',1,'987654321',2,'2018-01-10')
INSERT INTO Personal.Vendedores VALUES (2,'Ramirez','Maria','1990-07-22','Jr. Huallaga 123',1,'976543210',1,'2019-03-15')
INSERT INTO Personal.Vendedores VALUES (3,'Torres','Jose','1983-11-08','Av. Salaverry 987',2,'965432109',3,'2017-06-01')
INSERT INTO Personal.Vendedores VALUES (4,'Vargas','Ana','1992-05-30','Calle Lima 234',3,'954321098',1,'2020-02-20')
INSERT INTO Personal.Vendedores VALUES (5,'Flores','Pedro','1988-09-12','Av. Grau 567',4,'943210987',2,'2018-08-05')
INSERT INTO Personal.Vendedores VALUES (6,'Morales','Rosa','1995-01-25','Jr. Callao 890',1,'932109876',1,'2021-04-12')
INSERT INTO Personal.Vendedores VALUES (7,'Gutierrez','Luis','1980-06-18','Av. Javier Prado 345',1,'921098765',4,'2015-09-01')
INSERT INTO Personal.Vendedores VALUES (8,'Chavez','Elena','1993-12-04','Calle Miraflores 678',5,'910987654',1,'2020-11-03')
INSERT INTO Personal.Vendedores VALUES (9,'Mendoza','Oscar','1987-04-27','Av. Colonial 901',1,'999888777',2,'2016-07-20')
GO


-- Tabla: Marcas - fabricantes de vehiculos que comercializa la tienda
CREATE TABLE Inventario.Marcas (
    IdMarca    INT PRIMARY KEY,
    NombreMarca VARCHAR(50) NOT NULL,
    PaisOrigen  VARCHAR(50) NOT NULL
)
GO

INSERT INTO Inventario.Marcas VALUES (1,'Toyota','Japon')
INSERT INTO Inventario.Marcas VALUES (2,'Hyundai','Corea del Sur')
INSERT INTO Inventario.Marcas VALUES (3,'Kia','Corea del Sur')
INSERT INTO Inventario.Marcas VALUES (4,'Chevrolet','Estados Unidos')
INSERT INTO Inventario.Marcas VALUES (5,'Nissan','Japon')
INSERT INTO Inventario.Marcas VALUES (6,'Volkswagen','Alemania')
INSERT INTO Inventario.Marcas VALUES (7,'Ford','Estados Unidos')
INSERT INTO Inventario.Marcas VALUES (8,'Honda','Japon')
INSERT INTO Inventario.Marcas VALUES (9,'Suzuki','Japon')
INSERT INTO Inventario.Marcas VALUES (10,'Mitsubishi','Japon')
GO

-- Tabla: Segmentos - clasificacion del vehiculo por tipo de carroceria
CREATE TABLE Inventario.Segmentos (
    IdSegmento    INT PRIMARY KEY,
    NombreSegmento VARCHAR(50) NOT NULL,
    DescSegmento   VARCHAR(200)
)
GO

INSERT INTO Inventario.Segmentos VALUES (1,'Sedan','Automovil de pasajeros con maletero separado')
INSERT INTO Inventario.Segmentos VALUES (2,'SUV','Vehiculo deportivo utilitario, traccion 4x4 o 4x2')
INSERT INTO Inventario.Segmentos VALUES (3,'Pick Up','Vehiculo de carga con cabina y tolva descubierta')
INSERT INTO Inventario.Segmentos VALUES (4,'Hatchback','Compacto con maletero integrado a la carroceria')
INSERT INTO Inventario.Segmentos VALUES (5,'Van','Vehiculo de pasajeros de mayor capacidad')
INSERT INTO Inventario.Segmentos VALUES (6,'Coupe','Automovil deportivo de dos puertas')
GO

-- Tabla: Vehiculos - catalogo de unidades disponibles para la venta
CREATE TABLE Inventario.Vehiculos (
    IdVehiculo       INT PRIMARY KEY,
    NombreVehiculo   VARCHAR(100) NOT NULL,
    IdMarca          INT REFERENCES Inventario.Marcas,
    IdSegmento       INT REFERENCES Inventario.Segmentos,
    Anio             SMALLINT NOT NULL,
    Motor            VARCHAR(30) NOT NULL,
    Transmision      VARCHAR(20) NOT NULL,
    PrecioLista      DECIMAL(12,2) NOT NULL,
    StockDisponible  INT NOT NULL DEFAULT 0
)
GO

INSERT INTO Inventario.Vehiculos VALUES (1,'Yaris',1,4,2023,'1.5L 4Cil','Manual',62000.00,8)
INSERT INTO Inventario.Vehiculos VALUES (2,'Corolla',1,1,2023,'2.0L 4Cil','Automatico',89000.00,5)
INSERT INTO Inventario.Vehiculos VALUES (3,'Hilux',1,3,2023,'2.8L Diesel','Manual',128000.00,6)
INSERT INTO Inventario.Vehiculos VALUES (4,'RAV4',1,2,2023,'2.5L Hybrid','Automatico',148000.00,3)
INSERT INTO Inventario.Vehiculos VALUES (5,'Tucson',2,2,2023,'2.0L 4Cil','Automatico',109000.00,4)
INSERT INTO Inventario.Vehiculos VALUES (6,'Accent',2,1,2023,'1.4L 4Cil','Manual',57000.00,9)
INSERT INTO Inventario.Vehiculos VALUES (7,'Santa Fe',2,2,2022,'2.4L 4Cil','Automatico',135000.00,2)
INSERT INTO Inventario.Vehiculos VALUES (8,'Sportage',3,2,2023,'2.0L 4Cil','Automatico',105000.00,5)
INSERT INTO Inventario.Vehiculos VALUES (9,'Picanto',3,4,2023,'1.0L 3Cil','Manual',48000.00,10)
INSERT INTO Inventario.Vehiculos VALUES (10,'Rio',3,4,2023,'1.4L 4Cil','Manual',54000.00,7)
INSERT INTO Inventario.Vehiculos VALUES (11,'Onix',4,4,2023,'1.0L Turbo','Manual',58000.00,8)
INSERT INTO Inventario.Vehiculos VALUES (12,'Tracker',4,2,2023,'1.2L Turbo','Automatico',87000.00,6)
INSERT INTO Inventario.Vehiculos VALUES (13,'Colorado',4,3,2022,'2.8L Diesel','Automatico',118000.00,3)
INSERT INTO Inventario.Vehiculos VALUES (14,'Sentra',5,1,2023,'2.0L 4Cil','Automatico',82000.00,5)
INSERT INTO Inventario.Vehiculos VALUES (15,'Kicks',5,2,2023,'1.6L 4Cil','Manual',75000.00,6)
INSERT INTO Inventario.Vehiculos VALUES (16,'Frontier',5,3,2022,'2.5L Diesel','Manual',102000.00,4)
INSERT INTO Inventario.Vehiculos VALUES (17,'Golf',6,4,2022,'1.4L Turbo','Automatico',95000.00,3)
INSERT INTO Inventario.Vehiculos VALUES (18,'Tiguan',6,2,2022,'2.0L Turbo','Automatico',138000.00,2)
INSERT INTO Inventario.Vehiculos VALUES (19,'EcoSport',7,2,2022,'1.5L 3Cil','Manual',71000.00,5)
INSERT INTO Inventario.Vehiculos VALUES (20,'Ranger',7,3,2023,'3.2L Diesel','Manual',132000.00,4)
INSERT INTO Inventario.Vehiculos VALUES (21,'CR-V',8,2,2023,'1.5L Turbo','Automatico',118000.00,3)
INSERT INTO Inventario.Vehiculos VALUES (22,'City',8,1,2023,'1.5L 4Cil','Automatico',76000.00,6)
INSERT INTO Inventario.Vehiculos VALUES (23,'Swift',9,4,2023,'1.2L 4Cil','Manual',52000.00,8)
INSERT INTO Inventario.Vehiculos VALUES (24,'Vitara',9,2,2022,'1.6L 4Cil','Manual',85000.00,4)
INSERT INTO Inventario.Vehiculos VALUES (25,'L200',10,3,2023,'2.4L Diesel','Manual',112000.00,5)
GO



-- Tabla: TiposCliente - diferencia entre persona natural y empresa
CREATE TABLE Ventas.TiposCliente (
    IdTipoCliente  INT PRIMARY KEY,
    DesTipoCliente VARCHAR(30) NOT NULL
)
GO

INSERT INTO Ventas.TiposCliente VALUES (1,'Persona Natural')
INSERT INTO Ventas.TiposCliente VALUES (2,'Empresa')
GO

-- Tabla: Clientes - registro de compradores de la tienda automotriz
CREATE TABLE Ventas.Clientes (
    IdCliente       VARCHAR(8) PRIMARY KEY,
    RazonSocial     VARCHAR(100) NOT NULL,
    DNI_RUC         VARCHAR(15) NOT NULL,
    DireccionCliente VARCHAR(150) NOT NULL,
    TelefonoCliente  VARCHAR(20) NULL,
    EmailCliente     VARCHAR(80) NULL,
    IdTipoCliente    INT REFERENCES Ventas.TiposCliente,
    FechaRegistro    DATETIME NOT NULL DEFAULT GETDATE()
)
GO

INSERT INTO Ventas.Clientes VALUES('CLI0001','Juan Alberto Paredes Torres','45123789','Av. Angamos 231 Miraflores','987001001','jparedes@gmail.com',1,'2022-01-15')
INSERT INTO Ventas.Clientes VALUES('CLI0002','Maria Elena Castillo Rios','52334561','Jr. Independencia 456 Rimac','987001002','mcastillo@hotmail.com',1,'2022-02-20')
INSERT INTO Ventas.Clientes VALUES('CLI0003','Transportes Lima Sur SAC','20501234567','Av. Pachacutec 789 VES','987001003','admin@tlsur.pe',2,'2022-01-25')
INSERT INTO Ventas.Clientes VALUES('CLI0004','Carlos Enrique Vega Palacios','38902345','Calle Las Flores 123 SJM','987001004','cvega@yahoo.com',1,'2022-03-10')
INSERT INTO Ventas.Clientes VALUES('CLI0005','Inversiones Andinas EIRL','20601234560','Av. Industrial 567 Ate','987001005','info@invandinas.pe',2,'2022-03-18')
INSERT INTO Ventas.Clientes VALUES('CLI0006','Ana Sofia Quispe Mamani','71234567','Jr. Puno 890 Breña','987001006','aquispe@gmail.com',1,'2022-04-05')
INSERT INTO Ventas.Clientes VALUES('CLI0007','Roberto Hernan Lara Fuentes','29456781','Av. Brasil 234 Pueblo Libre','987001007','rlara@gmail.com',1,'2022-04-22')
INSERT INTO Ventas.Clientes VALUES('CLI0008','Comercial El Volante SAC','20701234501','Av. Argentina 456 Callao','987001008','ventas@elvolante.pe',2,'2022-05-08')
INSERT INTO Ventas.Clientes VALUES('CLI0009','Pedro Antonio Soto Delgado','40123456','Calle Tacna 567 Chorrillos','987001009','psoto@outlook.com',1,'2022-05-30')
INSERT INTO Ventas.Clientes VALUES('CLI0010','Luisa Fernanda Mejia Salas','63891234','Av. Universitaria 789 SMP','987001010','lfmejia@gmail.com',1,'2022-06-14')
INSERT INTO Ventas.Clientes VALUES('CLI0011','Grupo Constructor Norte SRL','20801234512','Jr. Los Geranios 123 Carabayllo','987001011','gerencia@gcnorte.pe',2,'2022-06-28')
INSERT INTO Ventas.Clientes VALUES('CLI0012','Franco Miguel Abad Garcia','72345891','Av. Benavides 234 Santiago','987001012','fabadg@gmail.com',1,'2022-07-10')
INSERT INTO Ventas.Clientes VALUES('CLI0013','Diana Paola Rojas Bernal','55678912','Calle Los Pinos 345 Comas','987001013','drojas@hotmail.com',1,'2022-07-25')
INSERT INTO Ventas.Clientes VALUES('CLI0014','Agro Servicios Sur EIRL','20901234523','Av. Villaran 456 Surquillo','987001014','ops@agrosur.pe',2,'2022-08-05')
INSERT INTO Ventas.Clientes VALUES('CLI0015','Miguel Angel Torres Ruiz','48765432','Jr. Callao 567 Magdalena','987001015','mtorres@gmail.com',1,'2022-08-20')
INSERT INTO Ventas.Clientes VALUES('CLI0016','Sandra Beatriz Huanca Yupanqui','65432198','Av. Arequipa 678 Lince','987001016','shuanca@gmail.com',1,'2022-09-12')
INSERT INTO Ventas.Clientes VALUES('CLI0017','Logistica Tres Puntos SAC','21001234534','Calle Los Rosales 789 La Molina','987001017','admin@l3puntos.pe',2,'2022-09-28')
INSERT INTO Ventas.Clientes VALUES('CLI0018','Andres Guillermo Pineda Chacon','32198765','Av. Colonial 890 Breña','987001018','apineda@yahoo.com',1,'2022-10-10')
INSERT INTO Ventas.Clientes VALUES('CLI0019','Patricia Consuelo Neyra Rueda','78901234','Jr. Ancash 123 Centro','987001019','pneyra@gmail.com',1,'2022-10-30')
INSERT INTO Ventas.Clientes VALUES('CLI0020','Constructora Lima Nueva EIRL','21101234545','Av. Tomas Valle 234 Independencia','987001020','info@limnueva.pe',2,'2022-11-15')
INSERT INTO Ventas.Clientes VALUES('CLI0021','Jorge Luis Saenz Cano','41567823','Calle Sargento Lores 345 SJL','987001021','jsaenz@gmail.com',1,'2022-11-28')
INSERT INTO Ventas.Clientes VALUES('CLI0022','Carmen Rosa Delgado Valdivia','69234517','Av. Belaunde 456 SMP','987001022','cdelgado@hotmail.com',1,'2022-12-10')
INSERT INTO Ventas.Clientes VALUES('CLI0023','Ferreteria El Maestro SRL','21201234556','Jr. Huanuco 567 La Victoria','987001023','ventas@elmaestro.pe',2,'2022-12-20')
INSERT INTO Ventas.Clientes VALUES('CLI0024','Luis Eduardo Pacheco Arroyo','37654891','Av. Defensores 678 Chorrillos','987001024','lpacheco@gmail.com',1,'2023-01-08')
INSERT INTO Ventas.Clientes VALUES('CLI0025','Natalia Esperanza Contreras Gil','82345671','Calle Porta 789 Miraflores','987001025','ncontreras@gmail.com',1,'2023-01-20')
INSERT INTO Ventas.Clientes VALUES('CLI0026','Repuestos y Servicios SAC','21301234567','Av. Proceres 890 SJL','987001026','ops@repserv.pe',2,'2023-02-05')
INSERT INTO Ventas.Clientes VALUES('CLI0027','Hector Manuel Coronado Vera','53671289','Jr. Pizarro 123 Rimac','987001027','hcoronado@yahoo.com',1,'2023-02-18')
INSERT INTO Ventas.Clientes VALUES('CLI0028','Gabriela Rocio Salinas Mora','76123489','Av. San Martin 234 Barranco','987001028','gsalinas@gmail.com',1,'2023-03-05')
INSERT INTO Ventas.Clientes VALUES('CLI0029','Empresa de Taxi Ejecutivo SAC','21401234578','Av. Zarumilla 345 Callao','987001029','gerencia@taxiej.pe',2,'2023-03-20')
INSERT INTO Ventas.Clientes VALUES('CLI0030','Ruben Dario Aguirre Pimentel','47891236','Calle Santa Rosa 456 Comas','987001030','raguirre@gmail.com',1,'2023-04-10')
GO


/* TABLAS DE VENTAS */

CREATE TABLE Ventas.VentasCabe (
    IdVenta      INT PRIMARY KEY,
    IdCliente    VARCHAR(8) REFERENCES Ventas.Clientes,
    IdVendedor   INT REFERENCES Personal.Vendedores,
    FechaVenta   DATETIME NOT NULL DEFAULT GETDATE(),
    FechaEntrega DATETIME NULL,
    -- P=Pendiente, E=Entregado, A=Anulado, C=En proceso
    EstadoVenta  CHAR(1) NOT NULL DEFAULT 'P',
    MontoTotal   DECIMAL(12,2) NOT NULL DEFAULT 0
)
GO

ALTER TABLE Ventas.VentasCabe ADD CONSTRAINT CHK_EstadoVenta
    CHECK (EstadoVenta IN ('P','E','A','C'))
GO

CREATE TABLE Ventas.VentasDeta (
    IdVenta    INT REFERENCES Ventas.VentasCabe,
    IdVehiculo INT REFERENCES Inventario.Vehiculos,
    PrecioVenta DECIMAL(12,2) NOT NULL,
    Cantidad    SMALLINT NOT NULL DEFAULT 1,
    Descuento   FLOAT NOT NULL DEFAULT 0
)
GO

-- Datos iniciales de ventas (cabecera)
INSERT INTO Ventas.VentasCabe VALUES(1001,'CLI0001',2,'2022-01-20','2022-01-25','E',89000.00)
INSERT INTO Ventas.VentasCabe VALUES(1002,'CLI0003',5,'2022-01-28','2022-02-05','E',256000.00)
INSERT INTO Ventas.VentasCabe VALUES(1003,'CLI0004',1,'2022-02-10','2022-02-15','E',62000.00)
INSERT INTO Ventas.VentasCabe VALUES(1004,'CLI0005',3,'2022-02-22','2022-03-01','E',384000.00)
INSERT INTO Ventas.VentasCabe VALUES(1005,'CLI0002',6,'2022-03-05','2022-03-10','E',57000.00)
INSERT INTO Ventas.VentasCabe VALUES(1006,'CLI0007',4,'2022-03-18','2022-03-25','E',105000.00)
INSERT INTO Ventas.VentasCabe VALUES(1007,'CLI0008',7,'2022-04-01','2022-04-10','E',240000.00)
INSERT INTO Ventas.VentasCabe VALUES(1008,'CLI0009',2,'2022-04-15','2022-04-20','E',82000.00)
INSERT INTO Ventas.VentasCabe VALUES(1009,'CLI0010',1,'2022-04-28','2022-05-03','E',48000.00)
INSERT INTO Ventas.VentasCabe VALUES(1010,'CLI0006',8,'2022-05-10','2022-05-15','E',75000.00)
INSERT INTO Ventas.VentasCabe VALUES(1011,'CLI0011',3,'2022-05-20','2022-05-28','E',128000.00)
INSERT INTO Ventas.VentasCabe VALUES(1012,'CLI0012',5,'2022-06-05','2022-06-10','E',54000.00)
INSERT INTO Ventas.VentasCabe VALUES(1013,'CLI0013',9,'2022-06-18','2022-06-25','E',52000.00)
INSERT INTO Ventas.VentasCabe VALUES(1014,'CLI0014',2,'2022-06-28','2022-07-05','E',204000.00)
INSERT INTO Ventas.VentasCabe VALUES(1015,'CLI0015',4,'2022-07-10','2022-07-15','E',95000.00)
INSERT INTO Ventas.VentasCabe VALUES(1016,'CLI0016',1,'2022-07-22','2022-07-28','E',76000.00)
INSERT INTO Ventas.VentasCabe VALUES(1017,'CLI0017',7,'2022-08-03','2022-08-10','E',296000.00)
INSERT INTO Ventas.VentasCabe VALUES(1018,'CLI0018',6,'2022-08-15','2022-08-20','E',87000.00)
INSERT INTO Ventas.VentasCabe VALUES(1019,'CLI0019',3,'2022-08-28','2022-09-03','E',62000.00)
INSERT INTO Ventas.VentasCabe VALUES(1020,'CLI0020',5,'2022-09-10','2022-09-18','E',512000.00)
INSERT INTO Ventas.VentasCabe VALUES(1021,'CLI0021',2,'2022-09-22','2022-09-27','E',109000.00)
INSERT INTO Ventas.VentasCabe VALUES(1022,'CLI0001',8,'2022-10-05','2022-10-10','E',48000.00)
INSERT INTO Ventas.VentasCabe VALUES(1023,'CLI0022',1,'2022-10-18','2022-10-23','E',85000.00)
INSERT INTO Ventas.VentasCabe VALUES(1024,'CLI0023',4,'2022-10-28','2022-11-05','E',354000.00)
INSERT INTO Ventas.VentasCabe VALUES(1025,'CLI0024',9,'2022-11-08','2022-11-13','E',112000.00)
INSERT INTO Ventas.VentasCabe VALUES(1026,'CLI0025',2,'2022-11-20','2022-11-25','E',58000.00)
INSERT INTO Ventas.VentasCabe VALUES(1027,'CLI0026',3,'2022-12-01','2022-12-08','E',204000.00)
INSERT INTO Ventas.VentasCabe VALUES(1028,'CLI0027',7,'2022-12-12','2022-12-18','E',128000.00)
INSERT INTO Ventas.VentasCabe VALUES(1029,'CLI0028',5,'2022-12-22','2022-12-28','E',57000.00)
INSERT INTO Ventas.VentasCabe VALUES(1030,'CLI0029',1,'2023-01-10','2023-01-17','E',405000.00)
INSERT INTO Ventas.VentasCabe VALUES(1031,'CLI0030',6,'2023-01-22','2023-01-27','E',52000.00)
INSERT INTO Ventas.VentasCabe VALUES(1032,'CLI0004',2,'2023-02-05','2023-02-10','E',128000.00)
INSERT INTO Ventas.VentasCabe VALUES(1033,'CLI0007',4,'2023-02-18','2023-02-23','E',148000.00)
INSERT INTO Ventas.VentasCabe VALUES(1034,'CLI0009',8,'2023-03-02','2023-03-07','E',75000.00)
INSERT INTO Ventas.VentasCabe VALUES(1035,'CLI0011',3,'2023-03-15','2023-03-20','E',256000.00)
INSERT INTO Ventas.VentasCabe VALUES(1036,'CLI0013',1,'2023-03-28','2023-04-02','E',54000.00)
INSERT INTO Ventas.VentasCabe VALUES(1037,'CLI0015',7,'2023-04-10','2023-04-15','E',109000.00)
INSERT INTO Ventas.VentasCabe VALUES(1038,'CLI0017',5,'2023-04-22','2023-04-28','E',314000.00)
INSERT INTO Ventas.VentasCabe VALUES(1039,'CLI0019',9,'2023-05-05','2023-05-10','E',82000.00)
INSERT INTO Ventas.VentasCabe VALUES(1040,'CLI0021',2,'2023-05-18','2023-05-23','E',95000.00)
INSERT INTO Ventas.VentasCabe VALUES(1041,'CLI0023',4,'2023-05-30','2023-06-05','E',368000.00)
INSERT INTO Ventas.VentasCabe VALUES(1042,'CLI0025',1,'2023-06-12','2023-06-17','E',87000.00)
INSERT INTO Ventas.VentasCabe VALUES(1043,'CLI0027',6,'2023-06-25','2023-06-30','E',76000.00)
INSERT INTO Ventas.VentasCabe VALUES(1044,'CLI0029',3,'2023-07-08','2023-07-15','E',512000.00)
INSERT INTO Ventas.VentasCabe VALUES(1045,'CLI0002',8,'2023-07-20','2023-07-25','E',52000.00)
INSERT INTO Ventas.VentasCabe VALUES(1046,'CLI0006',7,'2023-08-01','2023-08-07','E',105000.00)
INSERT INTO Ventas.VentasCabe VALUES(1047,'CLI0010',2,'2023-08-15','2023-08-20','E',148000.00)
INSERT INTO Ventas.VentasCabe VALUES(1048,'CLI0012',1,'2023-08-28','2023-09-03','E',57000.00)
INSERT INTO Ventas.VentasCabe VALUES(1049,'CLI0014',5,'2023-09-10','2023-09-16','E',204000.00)
INSERT INTO Ventas.VentasCabe VALUES(1050,'CLI0016',9,'2023-09-25','2023-10-01','E',62000.00)
INSERT INTO Ventas.VentasCabe VALUES(1051,'CLI0018',4,'2023-10-08','2023-10-13','E',89000.00)
INSERT INTO Ventas.VentasCabe VALUES(1052,'CLI0020',3,'2023-10-22','2023-10-28','E',517000.00)
INSERT INTO Ventas.VentasCabe VALUES(1053,'CLI0022',7,'2023-11-05','2023-11-10','E',54000.00)
INSERT INTO Ventas.VentasCabe VALUES(1054,'CLI0024',1,'2023-11-18','2023-11-23','E',112000.00)
INSERT INTO Ventas.VentasCabe VALUES(1055,'CLI0026',6,'2023-12-01','2023-12-07','E',204000.00)
INSERT INTO Ventas.VentasCabe VALUES(1056,'CLI0028',2,'2023-12-15','2023-12-20','E',109000.00)
INSERT INTO Ventas.VentasCabe VALUES(1057,'CLI0030',8,'2023-12-28','2024-01-03','E',48000.00)
INSERT INTO Ventas.VentasCabe VALUES(1058,'CLI0003',5,'2024-01-10','2024-01-17','E',414000.00)
INSERT INTO Ventas.VentasCabe VALUES(1059,'CLI0005',3,'2024-01-25','2024-01-31','E',256000.00)
INSERT INTO Ventas.VentasCabe VALUES(1060,'CLI0008',4,'2024-02-08','2024-02-14','E',132000.00)
GO

-- Datos iniciales de ventas (detalle)
INSERT INTO Ventas.VentasDeta VALUES(1001,2,89000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1002,3,128000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1003,1,62000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1004,3,128000.00,3,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1005,6,57000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1006,8,105000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1007,25,112000.00,2,0.05)
INSERT INTO Ventas.VentasDeta VALUES(1008,14,82000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1009,9,48000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1010,15,75000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1011,3,128000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1012,10,54000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1013,23,52000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1014,16,102000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1015,17,95000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1016,22,76000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1017,4,148000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1018,12,87000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1019,1,62000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1020,20,132000.00,4,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1021,5,109000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1022,9,48000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1023,24,85000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1024,13,118000.00,3,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1025,25,112000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1026,11,58000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1027,16,102000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1028,3,128000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1029,6,57000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1030,7,135000.00,3,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1031,23,52000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1032,3,128000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1033,4,148000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1034,15,75000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1035,3,128000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1036,10,54000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1037,5,109000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1038,16,102000.00,2,0.05)
INSERT INTO Ventas.VentasDeta VALUES(1038,25,112000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1039,14,82000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1040,17,95000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1041,13,118000.00,2,0.05)
INSERT INTO Ventas.VentasDeta VALUES(1041,20,132000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1042,12,87000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1043,22,76000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1044,3,128000.00,4,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1045,23,52000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1046,8,105000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1047,4,148000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1048,6,57000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1049,16,102000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1050,1,62000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1051,2,89000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1052,7,135000.00,3,0.05)
INSERT INTO Ventas.VentasDeta VALUES(1052,25,112000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1053,10,54000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1054,25,112000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1055,16,102000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1056,5,109000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1057,9,48000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1058,4,148000.00,2,0.04)
INSERT INTO Ventas.VentasDeta VALUES(1058,21,118000.00,1,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1059,3,128000.00,2,0.00)
INSERT INTO Ventas.VentasDeta VALUES(1060,20,132000.00,1,0.00)
GO


/* TABLA DE AUDITORIA */
CREATE TABLE Ventas.AuditoriaVentas (
    IdAuditoria    INT IDENTITY PRIMARY KEY,
    IdVenta        INT,
    EstadoAnterior CHAR(1),
    EstadoNuevo    CHAR(1),
    FechaCambio    DATETIME DEFAULT GETDATE(),
    Usuario        VARCHAR(100) DEFAULT SYSTEM_USER
)
GO


/* PROCEDIMIENTOS ALMACENADOS
   Encapsulan la logica de negocio mas frecuente de la tienda.*/

CREATE OR ALTER PROCEDURE Ventas.SP_RegistrarVenta
    @IdVenta    INT,
    @IdCliente  VARCHAR(8),
    @IdVendedor INT,
    @FechaEntrega DATETIME,
    @IdVehiculo INT,
    @PrecioVenta DECIMAL(12,2),
    @Cantidad   SMALLINT,
    @Descuento  FLOAT
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Ventas.Clientes WHERE IdCliente = @IdCliente)
            THROW 50001, 'El cliente indicado no existe en el sistema.', 1

        IF NOT EXISTS (SELECT 1 FROM Personal.Vendedores WHERE IdVendedor = @IdVendedor)
            THROW 50002, 'El vendedor indicado no existe en el sistema.', 1

        DECLARE @stock INT
        SELECT @stock = StockDisponible FROM Inventario.Vehiculos WHERE IdVehiculo = @IdVehiculo
        IF ISNULL(@stock, 0) < @Cantidad
            THROW 50003, 'Stock insuficiente para completar la venta.', 1

        DECLARE @total DECIMAL(12,2)
        SET @total = @PrecioVenta * @Cantidad * (1 - @Descuento)

        INSERT INTO Ventas.VentasCabe
            VALUES(@IdVenta, @IdCliente, @IdVendedor, GETDATE(), @FechaEntrega, 'P', @total)

        INSERT INTO Ventas.VentasDeta
            VALUES(@IdVenta, @IdVehiculo, @PrecioVenta, @Cantidad, @Descuento)

        -- Descontar unidades del inventario al confirmar la venta
        UPDATE Inventario.Vehiculos
        SET StockDisponible = StockDisponible - @Cantidad
        WHERE IdVehiculo = @IdVehiculo

        COMMIT TRANSACTION
        PRINT 'Venta registrada exitosamente. ID: ' + CAST(@IdVenta AS VARCHAR)
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al registrar venta: ' + ERROR_MESSAGE()
    END CATCH
END
GO

/* SP_VentasPorFecha
   Proceso: Reporte operativo de ventas en un rango de fechas.
   Util para el cierre diario y reportes de gestion del supervisor. */
CREATE OR ALTER PROCEDURE Ventas.SP_VentasPorFecha
    @FechaInicio DATETIME,
    @FechaFin    DATETIME
AS
BEGIN
    SELECT
        VC.IdVenta,
        C.RazonSocial                               AS Cliente,
        VND.NombreVendedor + ' ' + VND.ApellidoVendedor AS Vendedor,
        VH.NombreVehiculo                           AS Vehiculo,
        M.NombreMarca                               AS Marca,
        VD.Cantidad,
        VD.PrecioVenta,
        VD.PrecioVenta * VD.Cantidad * VD.Descuento AS MontoDescuento,
        VD.PrecioVenta * VD.Cantidad * (1 - VD.Descuento) AS TotalLinea,
        VC.FechaVenta,
        VC.EstadoVenta
    FROM Ventas.VentasCabe VC
    JOIN Ventas.Clientes C         ON C.IdCliente  = VC.IdCliente
    JOIN Personal.Vendedores VND   ON VND.IdVendedor = VC.IdVendedor
    JOIN Ventas.VentasDeta VD      ON VD.IdVenta   = VC.IdVenta
    JOIN Inventario.Vehiculos VH   ON VH.IdVehiculo = VD.IdVehiculo
    JOIN Inventario.Marcas M       ON M.IdMarca    = VH.IdMarca
    WHERE VC.FechaVenta BETWEEN @FechaInicio AND @FechaFin
    ORDER BY VC.FechaVenta
END
GO


CREATE OR ALTER PROCEDURE Ventas.SP_ReporteVendedor
    @IdVendedor INT
AS
BEGIN
    SELECT
        VND.NombreVendedor + ' ' + VND.ApellidoVendedor AS Vendedor,
        P.DesPuesto                                      AS Puesto,
        COUNT(DISTINCT VC.IdVenta)                       AS TotalVentas,
        SUM(VD.PrecioVenta * VD.Cantidad * (1 - VD.Descuento)) AS MontoTotal,
        AVG(VD.PrecioVenta * VD.Cantidad * (1 - VD.Descuento)) AS TicketPromedio
    FROM Personal.Vendedores VND
    JOIN Personal.Puestos P       ON P.IdPuesto   = VND.IdPuesto
    JOIN Ventas.VentasCabe VC     ON VC.IdVendedor = VND.IdVendedor
    JOIN Ventas.VentasDeta VD     ON VD.IdVenta   = VC.IdVenta
    WHERE VND.IdVendedor = @IdVendedor
    GROUP BY VND.NombreVendedor, VND.ApellidoVendedor, P.DesPuesto
END
GO


CREATE OR ALTER PROCEDURE Inventario.SP_StockBajo
    @UmbralMinimo INT = 3
AS
BEGIN
    DECLARE @id   INT, @nombre VARCHAR(100), @marca VARCHAR(50), @stock INT

    DECLARE cur_stock CURSOR FOR
        SELECT V.IdVehiculo, V.NombreVehiculo, M.NombreMarca, V.StockDisponible
        FROM Inventario.Vehiculos V
        JOIN Inventario.Marcas M ON M.IdMarca = V.IdMarca
        WHERE V.StockDisponible <= @UmbralMinimo
        ORDER BY V.StockDisponible ASC

    OPEN cur_stock
    FETCH NEXT FROM cur_stock INTO @id, @nombre, @marca, @stock

    PRINT '=== ALERTA: Vehiculos con stock critico ==='
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'ID: ' + CAST(@id AS VARCHAR) +
              ' | Vehiculo: ' + @nombre +
              ' | Marca: ' + @marca +
              ' | Stock: ' + CAST(@stock AS VARCHAR)
        FETCH NEXT FROM cur_stock INTO @id, @nombre, @marca, @stock
    END

    CLOSE cur_stock
    DEALLOCATE cur_stock
END
GO


/* FUNCIONES ALMACENADAS
   Calculan valores derivados reutilizables en consultas y vistas */

/* FN_TotalVenta
   Calcula el monto neto total de una venta especifica,
   considerando cantidad, precio y descuento de cada linea. */
CREATE OR ALTER FUNCTION Ventas.FN_TotalVenta (@IdVenta INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2)
    SELECT @total = SUM(PrecioVenta * Cantidad * (1 - Descuento))
    FROM Ventas.VentasDeta
    WHERE IdVenta = @IdVenta
    RETURN ISNULL(@total, 0)
END
GO

/* FN_NombreVendedor
   Devuelve el nombre completo de un vendedor a partir de su ID.
   Facilita presentar nombres en reportes sin joins adicionales. */
CREATE OR ALTER FUNCTION Personal.FN_NombreVendedor (@IdVendedor INT)
RETURNS VARCHAR(110)
AS
BEGIN
    DECLARE @nombre VARCHAR(110)
    SELECT @nombre = NombreVendedor + ' ' + ApellidoVendedor
    FROM Personal.Vendedores
    WHERE IdVendedor = @IdVendedor
    RETURN ISNULL(@nombre, 'Vendedor no registrado')
END
GO

/* FN_DescuentoTotal
   Calcula el monto total descontado en una venta.
   Util para reportes de promociones y analisis de margenes. */
CREATE OR ALTER FUNCTION Ventas.FN_DescuentoTotal (@IdVenta INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @desc DECIMAL(12,2)
    SELECT @desc = SUM(PrecioVenta * Cantidad * Descuento)
    FROM Ventas.VentasDeta
    WHERE IdVenta = @IdVenta
    RETURN ISNULL(@desc, 0)
END
GO

/* FN_VentasPorCliente
   Retorna el numero total de compras realizadas por un cliente.
   Se usa para clasificar clientes frecuentes o aplicar beneficios. */
CREATE OR ALTER FUNCTION Ventas.FN_VentasPorCliente (@IdCliente VARCHAR(8))
RETURNS INT
AS
BEGIN
    DECLARE @cant INT
    SELECT @cant = COUNT(*)
    FROM Ventas.VentasCabe
    WHERE IdCliente = @IdCliente
    RETURN ISNULL(@cant, 0)
END
GO


/* TRIGGERS
   Se ejecutan automaticamente ante eventos DML en las tablas.*/

/* TR_ActualizarMontoVenta  */
CREATE OR ALTER TRIGGER Ventas.TR_ActualizarMontoVenta
ON Ventas.VentasDeta
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Ventas.VentasCabe
    SET MontoTotal = Ventas.FN_TotalVenta(inserted.IdVenta)
    FROM inserted
    WHERE Ventas.VentasCabe.IdVenta = inserted.IdVenta
END
GO

/* TR_ValidarStockVenta */
CREATE OR ALTER TRIGGER Inventario.TR_ValidarStockVenta
ON Ventas.VentasDeta
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted I
        JOIN Inventario.Vehiculos V ON V.IdVehiculo = I.IdVehiculo
        WHERE V.StockDisponible < 0
    )
    BEGIN
        RAISERROR('Stock insuficiente: no se puede registrar la venta.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
GO

/* TR_AuditoriaEstado */
CREATE OR ALTER TRIGGER Ventas.TR_AuditoriaEstado
ON Ventas.VentasCabe
AFTER UPDATE
AS
BEGIN
    IF UPDATE(EstadoVenta)
    BEGIN
        INSERT INTO Ventas.AuditoriaVentas (IdVenta, EstadoAnterior, EstadoNuevo)
        SELECT D.IdVenta, D.EstadoVenta, I.EstadoVenta
        FROM deleted D
        JOIN inserted I ON I.IdVenta = D.IdVenta
        WHERE D.EstadoVenta <> I.EstadoVenta
    END
END
GO


/* BLOQUE DE PRUEBAS - Ejemplos de uso de los objetos creados */

-- Ejecutar SP: ventas del año 2023
EXEC Ventas.SP_VentasPorFecha '2023-01-01', '2023-12-31'
GO

-- Ejecutar SP: reporte del vendedor 2
EXEC Ventas.SP_ReporteVendedor 2
GO

-- Ejecutar SP con CURSOR: alerta de stock critico
EXEC Inventario.SP_StockBajo 3
GO

-- Usar funciones en consulta
SELECT
    VC.IdVenta,
    C.RazonSocial AS Cliente,
    Personal.FN_NombreVendedor(VC.IdVendedor) AS Vendedor,
    Ventas.FN_TotalVenta(VC.IdVenta)          AS Total,
    Ventas.FN_DescuentoTotal(VC.IdVenta)      AS Descuento,
    Ventas.FN_VentasPorCliente(VC.IdCliente)  AS ComprasCliente,
    VC.FechaVenta
FROM Ventas.VentasCabe VC
JOIN Ventas.Clientes C ON C.IdCliente = VC.IdCliente
ORDER BY VC.FechaVenta
GO

-- Probar trigger de auditoria: cambiar estado de una venta
UPDATE Ventas.VentasCabe SET EstadoVenta = 'C' WHERE IdVenta = 1001
GO
UPDATE Ventas.VentasCabe SET EstadoVenta = 'E' WHERE IdVenta = 1001
GO

-- Ver resultado de auditoria
SELECT * FROM Ventas.AuditoriaVentas
GO

-- Registrar venta nueva con el procedimiento almacenado
EXEC Ventas.SP_RegistrarVenta
    @IdVenta     = 1061,
    @IdCliente   = 'CLI0005',
    @IdVendedor  = 3,
    @FechaEntrega= '2024-03-15',
    @IdVehiculo  = 15,
    @PrecioVenta = 75000.00,
    @Cantidad    = 1,
    @Descuento   = 0.0
GO
