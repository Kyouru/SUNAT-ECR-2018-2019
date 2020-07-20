SELECT 	reporte.numerocuenta,
	    reporte.codigopersona,
	    reporte.tablaservicio,
	    reporte.tipopersona,
	    reporte.codigodireccion,
	    reporte.codigopais,
	    reporte.maxfecha,
	    reporte.saldoimporte1,
	    reporte.interestotal,
	    pjv.personavinculada,
	    pjv.tipovinculo
FROM 
	(SELECT maxfecha_reporte.numerocuenta,
	        maxfecha_reporte.codigopersona,
	        maxfecha_reporte.tablaservicio,
	        maxfecha_reporte.tipopersona,
	        maxfecha_reporte.codigodireccion,
	        maxfecha_reporte.codigopais,
	        maxfecha_reporte.maxfecha,
	        ca.saldoimporte1,
	        ca.interestotal
	        FROM captacionanexo ca
	        INNER JOIN (SELECT ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais, max(fecha) AS maxfecha
	            FROM captacionanexo ca
	            INNER JOIN (SELECT numerocuenta, cc.codigopersona, cc.tablaservicio, tipopersona, codigodireccion, codigopais FROM cuentacorriente cc
	                INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais FROM persona per
	                    INNER JOIN (SELECT codigopersona, perdir2019.codigodireccion, codigopais FROM personadireccion_20191231 perdir2019
	                        INNER JOIN (SELECT codigodireccion, codigopais FROM direccion_20191231 dir2019
	                            INNER JOIN (SELECT tbl_pais.TBLCODARG FROM t_wdd_paises auxpais
	                                INNER JOIN (SELECT TBLCODARG, UPPER(TBLDESCRI) AS nom_pais FROM syst900 WHERE tblcodtab = 3) tbl_pais
	                                ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca='X') pais_reporte
	                            ON dir2019.codigopais = pais_reporte.TBLCODARG) dir_reporte
	                        ON perdir2019.codigodireccion = dir_reporte.codigodireccion) perdir_reporte
	                    ON per.codigopersona = perdir_reporte.codigopersona) persona_reporte
	                ON cc.codigopersona = persona_reporte.codigopersona) cuenta_reporte
	            ON ca.numerocuenta = cuenta_reporte.numerocuenta
	            WHERE TRUNC(fecha) <= TO_DATE('31/12/2019','DD/MM/YYYY') 						--Hasta el 31/12/2019
	            		AND TRUNC(fechaapertura) >= TO_DATE('01/01/2019','DD/MM/YYYY') 			--Aperturadas en el periodo 2019
	                    AND (cuenta_reporte.tablaservicio = 101 OR cuenta_reporte.tablaservicio = 102)
	            GROUP BY ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais) maxfecha_reporte
	        ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha) reporte
LEFT JOIN personajurvinculada pjv ON pjv.codigopersona = reporte.codigopersona
WHERE (pjv.tipovinculo = 1 OR pjv.tipovinculo = 79 OR pjv.tipovinculo IS NULL);