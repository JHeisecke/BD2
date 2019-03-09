CREATE TABLE SOC_SOCIO
(ID_SOCIO 		NUMBER(12) not null,
CEDULA    		VARCHAR2(12) not null,
RUC       		VARCHAR2(12),
NOMBRE			VARCHAR2(50) NOT NULL,
APELLIDO 		VARCHAR2(50) NOT NULL,
FECHA_NACIMIENTO 	DATE NOT NULL,
FECHA_INGRESO 	 	DATE NOT NULL,
DIRECCION 		VARCHAR2(100) NOT NULL,
TELEFONO 		VARCHAR2(20) NOT NULL,
EMAIL 			VARCHAR2(50) NOT NULL,
SUSCRIPTO_NOVEDADES 	VARCHAR2(1) NOT NULL,
FIRMA			BLOB,
ESTADO 			VARCHAR2(1) DEFAULT 'A',
FECHA_FALLECIMIENTO 	DATE,
FECHA_BAJA 		DATE,
CONSTRAINT PK_ID_SOCIO PRIMARY KEY (ID_SOCIO),
CONSTRAINT SOC_ESTADO CHECK (ESTADO IN ('A','I','P','E','F'))
);

CREATE TABLE GEN_PARAMETROS(
	APORTE_MENSUAL NUMBER(8) NOT NULL,
	SOLIDARIDAD_MENSUAL NUMBER (8) NOT NULL,
	ANTIGUEDAD_MINIMA NUMBER (2),
	RUC_COOPERATIVA VARCHAR2 (15) NOT NULL,
	INTERES_MORATORIO_BCP NUMBER (2),
	PORC_SEG_VIDA NUMBER (3,1)
);

CREATE TABLE ALD_INMUEBLES(
ID_INMUEBLE NUMBER (8) NOT NULL,
ID_SOCIO NUMBER (12) NOT NULL,
CTA_CTE_CATASTRAL VARCHAR2 (20) NOT NULL,
FINCA VARCHAR2 (15) NOT NULL,
SUPERFICIE_M2 NUMBER (4) NOT NULL,
VALOR_FISCAL NUMBER (15) NOT NULL,
VALOR_AVALUO NUMBER (15) NOT NULL
);

ALTER TABLE ALD_INMUEBLES ADD CONSTRAINT PK_ID_INMUEBLE PRIMARY KEY (ID_INMUEBLE);
ALTER TABLE ALD_INMUEBLES ADD CONSTRAINT FK_ID_SOC_INM FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO);

CREATE TABLE ALD_RODADOS(
	RUA VARCHAR2(30) NOT NULL,
	ID_SOCIO NUMBER (12) NOT NULL,
	TIPO_VEHICULO VARCHAR2 (20) NOT NULL,
	MARCA VARCHAR2 (25) NOT NULL,
	MODELO VARCHAR2 (25) NOT NULL,
	VALOR NUMBER (12) NOT NULL,
	FECHA_ADQUISICION DATE  NOT NULL
);

ALTER TABLE ALD_RODADOS ADD CONSTRAINT PK_ID_RODADOS PRIMARY KEY (RUA);
ALTER TABLE ALD_RODADOS ADD CONSTRAINT FK_ID_SOC_ROD FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO);

CREATE TABLE SOC_OBLIGACIONES(
	ID_OBLIGACION NUMBER (10) NOT NULL,
	ANHO NUMBER (4) NOT NULL,
	TOTAL_A_ABONAR NUMBER (8) NOT NULL,
	SALDO NUMBER (8) NOT NULL,
	TIPO_OBLIGACION VARCHAR2 (1) NOT NULL,
	ID_SOCIO NUMBER (12) NOT NULL
);

ALTER TABLE SOC_OBLIGACIONES ADD CONSTRAINT PK_COD_OBLIG PRIMARY KEY (ID_OBLIGACION);
ALTER TABLE SOC_OBLIGACIONES CONSTRAINT FK_ID_SOC_OBL FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO);

CREATE TABLE SOC_DETALLE_OBLIGACIONES(
	ID_OBLIGACION NUMBER (10) NOT NULL,
	NUM_CUOTA NUMBER (2) NOT NULL,
	MONTO NUMBER (8) NOT NULL,
	FECHA_PAGO DATE
);

ALTER TABLE SOC_DETALLE_OBLIGACIONES ADD CONSTRAINT PK_DET_OBLIG PRIMARY KEY (ID_OBLIGACION, NUM_CUOTA);
ALTER TABLE SOC_DETALLE_OBLIGACIONES ADD CONSTRAINT FK_ID_OBLIG FOREIGN KEY (ID_OBLIGACION) REFERENCES SOC_OBLIGACIONES(ID_OBLIGACION);

CREATE TABLE ALD_DECLARACION_JURADA(
	ID_DECLARACION NUMBER (10) NOT NULL,
	FECHA_PRESENTACION DATE NOT NULL,
	OCUPACION VARCHAR2 (30) NOT NULL,
	EMPRESA_ACTUAL VARCHAR2 (30),
	MOTIVO_PRESENTACION VARCHAR2 (100) NOT NULL,
	OBSERVACIONES VARCHAR2 (300),
	ID_SOCIO NUMBER (12) NOT NULL
);

ALTER TABLE ALD_DECLARACION_JURADA ADD CONSTRAINT PK_ID_DECLARACION PRIMARY KEY(ID_DECLARACION);
ALTER TABLE ALD_DECLARACION_JURADA ADD CONSTRAINT FK_ID_SOC_DECL FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO);

CREATE TABLE ALD_CONCEPTOS(
	ID_CONCEPTO NUMBER(3) NOT NULL,
	NOMBRE_CONCEPTO VARCHAR(40) NOT NULL,
	INGRESO_GASTO VARCHAR2(1) NOT NULL
);
ALTER TABLE ALD_CONCEPTOS ADD CONSTRAINT PK_ID_CONCEPTO PRIMARY KEY(ID_CONCEPTO);

CREATE TABLE ALD_DETALLE_DECLARACION(
	ID_DECLARACION NUMBER(10) NOT NULL,
	NRO_ITEM NUMBER (5) NOT NULL,
	IMPORTE NUMBER (15) NOT NULL,
	ID_CONCEPTO NUMBER(3) NOT NULL
);

ALTER TABLE ALD_DETALLE_DECLARACION ADD CONSTRAINT PK_ID_DET_DECLAR PRIMARY KEY(ID_DECLARACION,NRO_ITEM);
ALTER TABLE ALD_DETALLE_DECLARACION ADD CONSTRAINT FK_ID_DECL FOREIGN KEY (ID_DECLARACION) REFERENCES ALD_DECLARACION_JURADA(ID_DECLARACION);
ALTER TABLE ALD_DETALLE_DECLARACION ADD CONSTRAINT FK_DET_DECLA FOREIGN KEY (ID_CONCEPTO) REFERENCES ALD_CONCEPTOS(ID_CONCEPTO);










