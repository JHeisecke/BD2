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

--tabla AHO_TIPO_MOVIMIENTO
create table AHO_TIPO_MOVIMIENTO
(ID_TIPO	NUMBER(3) NOT NULL,
NOMBRE_TIPO	VARCHAR2(20) NOT NULL,
DEBITO_CREDITO	VARCHAR2(1) NOT NULL,
CONSTRAINT PK_ID_TIPO_MOV PRIMARY KEY (ID_TIPO),
CONSTRAINT D_C_CHECK CHECK (DEBITO_CREDITO IN ('C','D'))
)
;

--tabla AHO_CUENTA_AHORRO
create table AHO_CUENTA_AHORRO
(ID_CUENTA		NUMBER(8) NOT NULL,
ID_SOCIO		NUMBER(12) NOT NULL,
ESTADO			VARCHAR2(1) NOT NULL,
TASA_INTERES		NUMBER(3) NOT NULL,
FECHA_APERTURA  	DATE NOT NULL,
FECHA_CANCEL		DATE,
SALDO_BLOQUEADO		NUMBER(12) NOT NULL,
SALDO_DISPONIBLE	NUMBER(12) NOT NULL,
CONSTRAINT PK_ID_AHORRO PRIMARY KEY (ID_CUENTA),
CONSTRAINT FK_ID_SOC_AHO FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO),
CONSTRAINT CH_ESTADO CHECK (ESTADO IN ('A', 'I')),
CONSTRAINT CH_SALDO_DISPONIBLE CHECK (SALDO_DISPONIBLE > 0),
CONSTRAINT CH_SALDO_BLOQUEADO CHECK (SALDO_BLOQUEADO > 0)
)
;

--table aho_movimientos_cuenta
create table AHO_MOVIMIENTOS_CUENTA
(ID_MOVIMIENTO		NUMBER(12) NOT NULL,
FECHA_MOVIMIENTO	DATE NOT NULL,
IMPORTE			NUMBER(15) NOT NULL,
ID_TIPO			NUMBER(3) NOT NULL,
ID_CUENTA		NUMBER(8) NOT NULL,
CONSTRAINT PK_ID_MOV PRIMARY KEY (ID_MOVIMIENTO),
CONSTRAINT FK_TIPO_MOV FOREIGN KEY (ID_TIPO) REFERENCES AHO_TIPO_MOVIMIENTO(ID_TIPO),
CONSTRAINT FK_ID_CTA_AHO FOREIGN KEY (ID_CUENTA) REFERENCES AHO_CUENTA_AHORRO(ID_CUENTA)
)
;

--table cre_modalidad_prestamo
CREATE TABLE CRE_MODALIDAD_PRESTAMO
(COD_TIPO		NUMBER(3) NOT NULL,
DESCRIPCION_MOD		VARCHAR2(60) NOT NULL,
TASA_INTERES_ANUAL	NUMBER(3,1),
RELACION_APORTES	NUMBER(2),
PLAZO_MAXIMO		NUMBER(3),
TIPO_GATANTIA		VARCHAR(2),
CONSTRAINT PK_ID_MODALIDAD PRIMARY KEY (COD_TIPO)
)
;

--tabla cre_solicitud_prestamos
CREATE TABLE CRE_SOLICITUD_PRESTAMOS
(ID_SOL_CRED		NUMBER(12) NOT NULL,
FECHA_PRESENTACION	DATE NOT NULL,
SITUACION		VARCHAR2(1) NOT NULL,
MONTO_SOLICITADO	NUMBER(12) NOT NULL,
MONTO_CONCEDIDO		NUMBER(12) NOT NULL,
PLAZO			NUMBER(3) NOT NULL,
OBSERVACION		VARCHAR2(300),
SOCIO_DEUDOR		NUMBER(12) NOT NULL,
SOCIO_CODEUDOR		NUMBER(12),
COD_TIPO		NUMBER(3) NOT NULL,
CONSTRAINT PK_ID_SOL_PRES PRIMARY KEY (ID_SOL_CRED),
CONSTRAINT FK_COD_MOD FOREIGN KEY (COD_TIPO) REFERENCES CRE_MODALIDAD_PRESTAMO(COD_TIPO),
CONSTRAINT FK_ID_SOC_CRED FOREIGN KEY (SOCIO_DEUDOR) REFERENCES SOC_SOCIO(ID_SOCIO),
CONSTRAINT FK_ID_SOC_CRED1 FOREIGN KEY (SOCIO_CODEUDOR) REFERENCES SOC_SOCIO(ID_SOCIO),
CONSTRAINT CH_SITUACION CHECK(SITUACION IN ('I','A', 'R', 'X'))
)
;

--TABLa cre_prestamos
CREATE TABLE CRE_PRESTAMOS
(
NRO_PRESTAMO		NUMBER(12) NOT NULL,
FECHA_GENERACION	DATE NOT NULL,
FECHA_DESEMBOLSO	DATE NOT NULL,
FECHA_CANCELACION	DATE,
MONTO_PRESTAMO		NUMBER(12) NOT NULL,
ESTADO			VARCHAR2(1) DEFAULT 'A',
ID_SOL_CRED		NUMBER(12) NOT NULL,
CONSTRAINT PK_ID_PRESTAMO PRIMARY KEY (NRO_PRESTAMO),
CONSTRAINT FK_ID_SOL_CRE FOREIGN KEY (ID_SOL_CRED) REFERENCES CRE_SOLICITUD_PRESTAMOS(ID_SOL_CRED),
CONSTRAINT CH_ESTADO_CRE_PRESTAMOS CHECK (ESTADO IN ('A','I'))
)
;

--tabla cre_cuotas
CREATE TABLE CRE_CUOTAS
(
NRO_PRESTAMO		NUMBER(12) NOT NULL,
NRO_CUOTA		NUMBER(2) NOT NULL,
AMORTIZACION		NUMBER(12) NOT NULL,
INTERES			NUMBER(12) NOT NULL,
MONTO_CUOTA		NUMBER(12) NOT NULL,
SEGURO_VIDA		NUMBER(8) NOt NULL,
INTERES_MORATORIO	NUMBER(10) NOT NULL,
FECHA_VENCIMIENTO	DATE NOT NULL,
FECHA_PAGO		DATE,
CONSTRAINT FK_NRO_PMO FOREIGN KEY (NRO_PRESTAMO) REFERENCES CRE_PRESTAMOS(NRO_PRESTAMO),
CONSTRAINT PK_ID_CUO_PRES PRIMARY KEY (NRO_PRESTAMO,NRO_CUOTA)
)
;

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
	TIPO_OBLIGACION VARCHAR2 (1) DEFAULT 'A',
	ID_SOCIO NUMBER (12) NOT NULL
);

ALTER TABLE SOC_OBLIGACIONES ADD CONSTRAINT PK_COD_OBLIG PRIMARY KEY (ID_OBLIGACION);
ALTER TABLE SOC_OBLIGACIONES ADD CONSTRAINT FK_ID_SOC_OBL FOREIGN KEY (ID_SOCIO) REFERENCES SOC_SOCIO(ID_SOCIO);
ALTER TABLE SOC_OBLIGACIONES ADD CONSTRAINT CHK_TIPO_OBLIG CHECK(TIPO_OBLIGACION IN('A', 'S'));

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