SELECT  maxfecha_reporte.numerocuenta,
                maxfecha_reporte.codigopersona,
                maxfecha_reporte.tablaservicio,
                maxfecha_reporte.tipopersona,
                maxfecha_reporte.codigodireccion,
                maxfecha_reporte.codigopais,
                ca.saldoimporte1,
                ca.interestotal
        FROM captacionanexo ca
        INNER JOIN (SELECT ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais, SUM(saldoimporte1)/360 AS saldopromedio, max(fecha) AS maxfecha
            FROM captacionanexo ca
            INNER JOIN (SELECT numerocuenta, cc.codigopersona, cc.tablaservicio, tipopersona, codigodireccion, codigopais from cuentacorriente cc
                INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais from persona per
                    INNER JOIN (SELECT codigopersona, perdir2018.codigodireccion, codigopais from personadireccion_20181231 perdir2018
                        INNER JOIN (SELECT codigodireccion, codigopais from direccion_20181231 dir2018
                            INNER JOIN (SELECT tbl_pais.TBLCODARG FROM t_wdd_paises auxpais
                                INNER JOIN (SELECT TBLCODARG, UPPER(TBLDESCRI) AS nom_pais from syst900 where tblcodtab = 3) tbl_pais
                                ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca='X') pais_reporte
                            ON dir2018.codigopais = pais_reporte.TBLCODARG) dir_reporte
                        ON perdir2018.codigodireccion = dir_reporte.codigodireccion) perdir_reporte
                    ON per.codigopersona = perdir_reporte.codigopersona) persona_reporte
                ON cc.codigopersona = persona_reporte.codigopersona) cuenta_reporte
            ON ca.numerocuenta = cuenta_reporte.numerocuenta
            WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY') 			--Hasta el 31/12/2018
                    AND (cuenta_reporte.tablaservicio = 101 OR cuenta_reporte.tablaservicio = 102)
            GROUP BY ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais) maxfecha_reporte
        ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha

	INNER JOIN (SELECT  canexo_reporte.codigopersona,
						SUM(canexo_reporte.saldoimporte1) AS SALDOFINAL,
						SUM(canexo_reporte.interestotal) AS INTERESTOTAL,
						SUM(canexo_reporte.saldopromedio) AS SALDOPROMEDIO,
						SUM(CASE WHEN MOD(tipomovimiento, 2) = 0 THEN IMPORTE1 ELSE 0 END) AS CARGO,
						SUM(CASE WHEN MOD(tipomovimiento, 2) = 1 THEN IMPORTE1 ELSE 0 END) AS ABONO,
						ABS(SUM(CASE WHEN MOD(tipomovimiento, 2) = 0 THEN IMPORTE1*(-1) ELSE IMPORTE1 END)) AS SALDOACUMULADO,
						MAX(aportes.saldoimporte1) AS SALDOMAXIMO
				FROM aportes
				RIGHT JOIN 
					(SELECT  maxfecha_reporte.numerocuenta,
							maxfecha_reporte.codigopersona,
							maxfecha_reporte.tablaservicio,
							maxfecha_reporte.tipopersona,
							maxfecha_reporte.codigodireccion,
							maxfecha_reporte.codigopais,
							maxfecha_reporte.saldopromedio,
							maxfecha_reporte.maxfecha,
							ca.saldoimporte1,
							ca.interestotal
					FROM captacionanexo ca
					INNER JOIN (SELECT ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais, SUM(saldoimporte1)/360 AS saldopromedio, max(fecha) AS maxfecha
						FROM captacionanexo ca
						INNER JOIN (SELECT numerocuenta, cc.codigopersona, cc.tablaservicio, tipopersona, codigodireccion, codigopais from cuentacorriente cc
							INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais from persona per
								INNER JOIN (SELECT codigopersona, perdir2018.codigodireccion, codigopais from personadireccion_20181231 perdir2018
									INNER JOIN (SELECT codigodireccion, codigopais from direccion_20181231 dir2018
										INNER JOIN (SELECT tbl_pais.TBLCODARG FROM t_wdd_paises auxpais
											INNER JOIN (SELECT TBLCODARG, UPPER(TBLDESCRI) AS nom_pais from syst900 where tblcodtab = 3) tbl_pais
											ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca='X') pais_reporte
										ON dir2018.codigopais = pais_reporte.TBLCODARG) dir_reporte
									ON perdir2018.codigodireccion = dir_reporte.codigodireccion) perdir_reporte
								ON per.codigopersona = perdir_reporte.codigopersona) persona_reporte
							ON cc.codigopersona = persona_reporte.codigopersona) cuenta_reporte
						ON ca.numerocuenta = cuenta_reporte.numerocuenta
						WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY') 			--Hasta el 31/12/2018
								AND (cuenta_reporte.tablaservicio = 101 OR cuenta_reporte.tablaservicio = 102)
						GROUP BY ca.numerocuenta, codigopersona, ca.tablaservicio, tipopersona, codigodireccion, codigopais) maxfecha_reporte
					ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha) canexo_reporte
				ON aportes.numerocuenta = canexo_reporte.numerocuenta
				WHERE   (canexo_reporte.tablaservicio = 101
							OR canexo_reporte.tablaservicio = 102)			--Cuentas de Ahorro y CDE
						AND tipopersona = 1									--Solo Personas Naturales
				GROUP BY    canexo_reporte.codigopersona
					HAVING (SALDOFINAL >= 1000000 OR INTERESTOTAL >= 1000000 OR SALDOPROMEDIO >= 1000000 OR SALDOACUMULADO >= 1000000 OR SALDOMAXIMO >= 1000000)) personas_reporte
	ON maxfecha_reporte.codigopersona = personas_reporte.codigopersona;
