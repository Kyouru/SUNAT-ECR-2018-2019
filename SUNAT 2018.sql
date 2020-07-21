--Cuentas Preexistentes hasta el 31/12/2018
--Solo Personas Naturales
--No domiciliadas (no Peru y en la lista de paises reportables)
--Cuenta AHV, CDE y CTS que perdieron dicha caracteristica
--Cuentas de alto valor
----"Saldo al final del periodo" o "Saldo promedio del periodo" o "Saldo Maximo del periodo" o "ABS(Abono - Cargo)" o  "Intereses acumulado no cobrados" >= 1,000,000.00

SELECT DISTINCT 'OECD1' cDocTypeIndic, 'PE2018PE2011106501300001' || LPAD(ROW_NUMBER() OVER(ORDER BY numerocuenta ASC),5,'0') AS cDocRefId, numerocuenta cAccountNumber, 'OECD605' cTypeAccountNumber,
estado cUndocumentedAccount, CAST(NULL AS VARCHAR2(100)) cClosedAccount, CAST(NULL AS VARCHAR2(100)) cDormantAccount, --Falta rellenar valores con el estado de la cuenta linea 41
CASE tipopersona WHEN 1 THEN 'Individual' ELSE 'Organisation' END cTypeHolder, upper(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cResCountryCode, CAST(NULL AS VARCHAR2(100)) cTIN, CAST(NULL AS VARCHAR2(100)) cTIN_IssuedBy,
TRANSLATE(bd_nombrecompleto(codigopersona), '&', 'Y') cName, CASE tipopersona WHEN 2 THEN 'OECD207' ELSE NULL END cName_nameType, TRIM(pkg_personanatural.f_obt_nombres(codigopersona)) cFirstName, TRIM(TRIM(pkg_personanatural.f_obt_apellidopaterno(codigopersona)) || ' ' || TRIM(pkg_personanatural.f_obt_apellidomaterno(codigopersona))) cLastName, 'OECD304' cAddress_legalAddressType, upper(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cCountryCode,
TRIM(direccion) cAddressFree, CAST(NULL AS VARCHAR2(100)) cStreet, CAST(NULL AS VARCHAR2(100)) cBuildingIdentifier, CAST(NULL AS VARCHAR2(100)) cSuiteIdentifier, CAST(NULL AS VARCHAR2(100)) cFloorIdentifier,
CAST(NULL AS VARCHAR2(100)) cDistrictName, CAST(NULL AS VARCHAR2(100)) cPOB, CAST(NULL AS VARCHAR2(100)) cPostCode, CAST(NULL AS VARCHAR2(100)) cCity,
pkg_personanatural.f_obt_fechacumpleanos(codigopersona) cBirthDate, CAST(NULL AS VARCHAR2(100)) cBirthCity, upper(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(codigopersona))) cBirthCountryCode, CAST(NULL AS VARCHAR2(100)) cBirthFormerCountryName, CASE tipopersona WHEN 2 THEN 'CRS101' ELSE NULL END cAcctHolderTypeCRS,

-- CtrlgPersonType
CASE tipovinculo
WHEN 1 THEN 'CRS803' --GERENTE GENERAL
WHEN 79 THEN 'CRS801' --ACCIONISTA
ELSE NULL
END cCtrlgPersonType,

salcon_soles + intcon_soles cAccountBalance,
CASE WHEN moneda = 1 THEN 'PEN' ELSE 'USD' END cAccountBalance_CurrCode, 'CRS502' cType, intcon_soles cPaymentAmnt, CASE WHEN moneda = 1 THEN 'PEN' ELSE 'USD' END cPaymentAmnt_currCode,

CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 1 THEN 'Individual' WHEN 2 THEN 'Organisation' ELSE NULL END ccTypeHolder, upper(pkg_syst900.f_obt_tbldesabr(3, codigopaisvinculo)) ccResCountryCode, CAST(NULL AS VARCHAR2(100)) ccTIN, CAST(NULL AS VARCHAR2(100)) ccTIN_IssuedBy,
				TRANSLATE(bd_nombrecompleto(personavinculada), '&', 'Y') ccName, CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 2 THEN 'OECD207' ELSE NULL END ccName_nameType, TRIM(pkg_personanatural.f_obt_nombres(personavinculada)) ccFirstName, TRIM(TRIM(pkg_personanatural.f_obt_apellidopaterno(personavinculada)) || ' ' || TRIM(pkg_personanatural.F_OBT_APELLIDOMATERNO(personavinculada))) ccLastName, CAST(NULL AS VARCHAR2(100)) ccAddress_legalAddressType, upper(pkg_syst900.f_obt_tbldesabr(3, codigopaisvinculo)) ccCountryCode,
				direccionvinculo ccAddressFree, CAST(NULL AS VARCHAR2(100)) ccStreet, CAST(NULL AS VARCHAR2(100)) ccBuildingIdentifier, CAST(NULL AS VARCHAR2(100)) ccSuiteIdentifier, CAST(NULL AS VARCHAR2(100)) ccFloorIdentifier,
				CAST(NULL AS VARCHAR2(100)) ccDistrictName, CAST(NULL AS VARCHAR2(100)) ccPOB, CAST(NULL AS VARCHAR2(100)) ccPostCode, CAST(NULL AS VARCHAR2(100)) ccCity,
				pkg_personanatural.f_obt_fechacumpleanos(personavinculada) ccBirthDate, CAST(NULL AS VARCHAR2(100)) ccBirthCity, upper(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(personavinculada))) ccBirthCountryCode, CAST(NULL AS VARCHAR2(100)) ccBirthFormerCountryName

FROM (

	SELECT	maxfecha_reporte.numerocuenta,
			maxfecha_reporte.codigopersona,
			maxfecha_reporte.tablaservicio,
			maxfecha_reporte.tipopersona,
			--maxfecha_reporte.codigodireccion,
			pkg_direccion.f_obt_tipovia(maxfecha_reporte.codigodireccion)||' '||TRIM(pkg_direccion.f_obt_callenumero(maxfecha_reporte.codigodireccion))||'  '||
			DECODE(TRIM(pkg_direccion.f_obt_numeropuerta(maxfecha_reporte.codigodireccion)),NULL,NULL,'Nro.:'||TRIM(pkg_direccion.f_obt_numeropuerta(maxfecha_reporte.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_manzana(maxfecha_reporte.codigodireccion)),NULL,NULL,'Mz.:'||' '||TRIM(pkg_direccion.f_obt_manzana(maxfecha_reporte.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_lote(maxfecha_reporte.codigodireccion)),NULL,NULL,'Lt.:'||' '||TRIM(pkg_direccion.f_obt_lote(maxfecha_reporte.codigodireccion)))||' '|| 
			DECODE(TRIM(pkg_direccion.f_obt_referencia(maxfecha_reporte.codigodireccion)),NULL,NULL,'Referencia :'||TRIM(pkg_direccion.f_obt_referencia(maxfecha_reporte.codigodireccion)))||' *** '|| 
			UPPER(pkg_direccion.f_obt_descdepartamento(maxfecha_reporte.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descprovincia(maxfecha_reporte.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descdistrito(maxfecha_reporte.codigodireccion)) AS direccion,
			maxfecha_reporte.codigopais,
			maxfecha_reporte.estado,
			maxfecha_reporte.moneda,
			CASE WHEN maxfecha_reporte.moneda=1 THEN ca.saldoimporte1 ELSE ca.saldoimporte1*GEN05200('31/12/2018', 3, 3) END AS salcon_soles,
			CASE WHEN maxfecha_reporte.moneda=2 THEN ca.saldoimporte1 ELSE ca.saldoimporte1/GEN05200('31/12/2018', 3, 3) END AS salcon_dolares,
			CASE WHEN maxfecha_reporte.moneda=1 THEN ca.interestotal ELSE ca.interestotal*GEN05200('31/12/2018', 3, 3) END AS intcon_soles,
			CASE WHEN maxfecha_reporte.moneda=2 THEN ca.interestotal ELSE ca.interestotal/GEN05200('31/12/2018', 3, 3) END AS intcon_dolares,
			NULL AS personavinculada,
			NULL AS tipovinculo,
			NULL AS direccionvinculo,
			NULL AS codigopaisvinculo
			FROM captacionanexo ca
			INNER JOIN (SELECT ca.numerocuenta, cuenta_reporte.moneda, codigopersona, ca.tablaservicio, cuenta_reporte.estado, tipopersona, codigodireccion, codigopais, max(fecha) AS maxfecha
				FROM captacionanexo ca
				INNER JOIN (SELECT numerocuenta, cc.moneda, cc.codigopersona, cc.tablaservicio, cc.estado, tipopersona, codigodireccion, codigopais from cuentacorriente cc
					INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais from persona per
						INNER JOIN (SELECT perdir2018.codigopersona, perdir2018.codigodireccion, codigopais FROM personadireccion_20181231 perdir2018
							INNER JOIN (SELECT codigopersona, max(pd.codigodireccion) codigodireccion FROM personadireccion_20181231 pd 
										WHERE pd.tipodireccion = 1 AND pd.enviocorreo ='S' 
										GROUP BY codigopersona) maxperdir2018
							ON perdir2018.codigopersona = maxperdir2018.codigopersona
								AND perdir2018.codigodireccion = maxperdir2018.codigodireccion
								INNER JOIN (SELECT codigodireccion, codigopais FROM direccion_20181231 dir2018
									INNER JOIN (SELECT tbl_pais.TBLCODARG FROM t_wdd_paises auxpais
										INNER JOIN (SELECT TBLCODARG, UPPER(TBLDESCRI) AS nom_pais FROM syst900 WHERE tblcodtab = 3) tbl_pais
										ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca='X') pais_reporte
									ON dir2018.codigopais = pais_reporte.TBLCODARG) dir_reporte
								ON perdir2018.codigodireccion = dir_reporte.codigodireccion) perdir_reporte
						ON per.codigopersona = perdir_reporte.codigopersona) persona_reporte
					ON cc.codigopersona = persona_reporte.codigopersona) cuenta_reporte
				ON ca.numerocuenta = cuenta_reporte.numerocuenta
				WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY')			--Hasta el 31/12/2018
						AND (cuenta_reporte.tablaservicio = 101 OR cuenta_reporte.tablaservicio = 102)
				GROUP BY ca.numerocuenta, cuenta_reporte.moneda, codigopersona, ca.tablaservicio, cuenta_reporte.estado, tipopersona, codigodireccion, codigopais) maxfecha_reporte
			ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha
		INNER JOIN ( SELECT codigopersona FROM 
						(SELECT	canexo_reporte.codigopersona,
								SUM(CASE WHEN canexo_reporte.moneda=2 THEN canexo_reporte.saldoimporte1 ELSE canexo_reporte.saldoimporte1/GEN05200('31/12/2018', 3, 3) END) AS SALDOFINAL,
								SUM(CASE WHEN canexo_reporte.moneda=2 THEN canexo_reporte.interestotal ELSE canexo_reporte.interestotal/GEN05200('31/12/2018', 3, 3) END) AS INTERESTOTAL,
								SUM(CASE WHEN canexo_reporte.moneda=2 THEN canexo_reporte.saldopromedio ELSE canexo_reporte.saldopromedio/GEN05200('31/12/2018', 3, 3) END) AS SALDOPROMEDIO,
								ABS(SUM(CASE 	WHEN canexo_reporte.moneda=2 THEN
													CASE WHEN MOD(tipomovimiento, 2)=0 THEN
														IMPORTE1*(-1)
													ELSE
														IMPORTE1
													END
												ELSE
													CASE WHEN MOD(tipomovimiento, 2)=0 THEN
														(IMPORTE1*(-1))/GEN05200('31/12/2018', 3, 3)
													ELSE 
														IMPORTE1/GEN05200('31/12/2018', 3, 3)
													END
										END
								)) AS SALDOACUMULADO,
								SUM(CASE WHEN canexo_reporte.moneda=2 THEN canexo_reporte.saldomaximo ELSE canexo_reporte.saldomaximo/GEN05200('31/12/2018', 3, 3) END) AS SALDOMAXIMO
						FROM aportes apo
						RIGHT JOIN
							(SELECT	maxfecha_reporte.codigopersona,
									maxfecha_reporte.numerocuenta,
									maxfecha_reporte.saldopromedio,
									maxfecha_reporte.moneda,
									maxfecha_reporte.estado,
									maxfecha_reporte.saldomaximo,
									ca.saldoimporte1,
									ca.interestotal
							FROM captacionanexo ca
							INNER JOIN (SELECT cuenta_reporte.codigopersona, ca.numerocuenta, cuenta_reporte.moneda, cuenta_reporte.estado, TRUNC(fechaapertura) AS fechaapertura, SUM(saldoimporte1)/(MAX(fecha) - fechaapertura) AS saldopromedio, MAX(saldoimporte1) AS saldomaximo, MAX(fecha) AS maxfecha
								FROM captacionanexo ca
								INNER JOIN (SELECT numerocuenta, cc.moneda, cc.estado, cc.codigopersona, cc.tablaservicio, tipopersona, codigodireccion, codigopais from cuentacorriente cc
									INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais from persona per
										INNER JOIN (SELECT perdir2018.codigopersona, perdir2018.codigodireccion, codigopais FROM personadireccion_20181231 perdir2018
											INNER JOIN (SELECT codigopersona, max(pd.codigodireccion) codigodireccion FROM personadireccion_20181231 pd 
														WHERE pd.tipodireccion = 1 AND pd.enviocorreo ='S' 
														GROUP BY codigopersona) maxperdir2018
											ON perdir2018.codigopersona = maxperdir2018.codigopersona
												AND perdir2018.codigodireccion = maxperdir2018.codigodireccion
												INNER JOIN (SELECT codigodireccion, codigopais FROM direccion_20181231 dir2018
													INNER JOIN (SELECT tbl_pais.TBLCODARG FROM t_wdd_paises auxpais
														INNER JOIN (SELECT TBLCODARG, UPPER(TBLDESCRI) AS nom_pais FROM syst900 WHERE tblcodtab = 3) tbl_pais
														ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca='X') pais_reporte
													ON dir2018.codigopais = pais_reporte.TBLCODARG) dir_reporte
												ON perdir2018.codigodireccion = dir_reporte.codigodireccion) perdir_reporte
										ON per.codigopersona = perdir_reporte.codigopersona) persona_reporte
									ON cc.codigopersona = persona_reporte.codigopersona) cuenta_reporte
								ON ca.numerocuenta = cuenta_reporte.numerocuenta
								WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY')									--Hasta el 31/12/2018
										AND (cuenta_reporte.tablaservicio = 101 OR cuenta_reporte.tablaservicio = 102)		--Cuentas de Ahorro y CDE
										AND tipopersona = 1																	--Solo Personas Naturales
										--AND TRUNC(fecha) >= TO_DATE('01/10/2018','DD/MM/YYYY')								--Para Pruebas, solo cuentas que estuvieron activas a partir en 01/10/2018
								GROUP BY cuenta_reporte.codigopersona, ca.numerocuenta, cuenta_reporte.moneda, cuenta_reporte.estado, fechaapertura) maxfecha_reporte
							ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha) canexo_reporte
						ON apo.numerocuenta = canexo_reporte.numerocuenta
						GROUP BY canexo_reporte.codigopersona
						)
						WHERE (saldofinal >= 1000000
								OR interestotal >= 1000000
								OR saldopromedio >= 1000000
								OR saldoacumulado >= 1000000
								OR saldomaximo >= 1000000)
					) personas_reporte
		ON maxfecha_reporte.codigopersona = personas_reporte.codigopersona
		);
