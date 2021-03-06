--JAVIER HEISECKE CI:4374941

UPDATE B_ARTICULOS
SET ULTIMA_COMPRA = TAB.FECHA,
	COSTO = TAB.COSTO
FROM B_ARTICULOS A JOIN(
SELECT DC.ID_ARTICULO AS ID_ARTICULO, MAX(C.FECHA) AS FECHA, AVG(DC.CANTIDAD*DC.PRECIO_COMPRA) AS PRECIO_COSTO
FROM B_COMPRAS C
JOIN B_DETALLE_COMPRAS DC ON C.ID = DC.ID_COMPRA
GROUP BY DC.ID_ARTICULO, DC.PRECIO_COMPRA
) TAB ON A.ID = TAB.ID_ARTICULO;