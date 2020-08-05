--Reporte de las cuentas preexistentes del 2018
CREATE TABLE SISGODBA.ECR_ACCOUNTREPORT 
AS
SELECT DISTINCT 'OECD1' cDocTypeIndic,
		--Cambiar el periodo
		'PE20182011106501300001' || LPAD(ROW_NUMBER() OVER(ORDER BY numerocuenta ASC),5,'0') AS cDocRefId,
		numerocuenta cAccountNumber,
		'OECD605' cTypeAccountNumber,
		'false' cUndocumentedAccount,
		CASE estado WHEN 3 THEN 'true' WHEN 2 THEN 'true' ELSE 'false' END cClosedAccount,
		CASE estado WHEN 4 THEN 'true' ELSE 'false' END cDormantAccount,
		CASE tipopersona WHEN 1 THEN 'Individual' ELSE 'Organisation' END cTypeHolder,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cResCountryCode,
		CASE tipopersona WHEN 1 THEN pkg_personanatural.f_obt_numerodocumentoid(codigopersona) ELSE (CASE pkg_persona.f_obt_numeroruc(codigopersona) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE TO_CHAR(pkg_persona.f_obt_numeroruc(codigopersona)) END) END cIN,
		CASE tipopersona WHEN 1 THEN (CASE pkg_personanatural.f_obt_tipodocumentoid(codigopersona) WHEN 1 THEN 'PE' ELSE UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopais)) END) ELSE (CASE pkg_persona.f_obt_numeroruc(codigopersona) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE 'PE' END) END cIN_IssuedBy,
		TRANSLATE(bd_nombrecompleto(codigopersona), '&', 'Y') cName,
		CASE tipopersona WHEN 2 THEN 'OECD207' ELSE 'OECD202' END cName_nameType,
		TRIM(pkg_personanatural.f_obt_nombres(codigopersona)) cFirstName,
		TRIM(TRIM(pkg_personanatural.f_obt_apellidopaterno(codigopersona)) || ' ' || TRIM(pkg_personanatural.f_obt_apellidomaterno(codigopersona))) cLastName,
		'OECD304' cAddress_legalAddressType,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cCountryCode,
		CAST(NULL AS VARCHAR2(100)) cStreet,
		CAST(NULL AS VARCHAR2(100)) cBuildingIdentifier,
		CAST(NULL AS VARCHAR2(100)) cSuiteIdentifier,
		CAST(NULL AS VARCHAR2(100)) cFloorIdentifier,
		CAST(NULL AS VARCHAR2(100)) cDistrictName,
		CAST(NULL AS VARCHAR2(100)) cPOB,
		CAST(NULL AS VARCHAR2(100)) cPostCode,
		CAST(NULL AS VARCHAR2(100)) cCity,
		TRIM(direccion) cAddressFree,
		pkg_personanatural.f_obt_fechacumpleanos(codigopersona) cBirthDate,
		CAST(NULL AS VARCHAR2(100)) cBirthCity,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(codigopersona))) cBirthCountryCode,
		CAST(NULL AS VARCHAR2(100)) cBirthFormerCountryName,
		CASE tipopersona WHEN 2 THEN 'CRS101' ELSE CAST(NULL AS VARCHAR2(100)) END cAcctHolderTypeCRS,
		CASE tipovinculo WHEN 1 THEN 'CRS803' WHEN 79 THEN 'CRS801' ELSE CAST(NULL AS VARCHAR2(100)) END cCtrlgPersonType, --Accionestas y Gerente General
		CASE WHEN moneda = 1 THEN salcon_soles + intcon_soles ELSE salcon_dolares + intcon_dolares END cAccountBalance,
		CASE WHEN moneda = 1 THEN 'PEN' ELSE 'USD' END cAccountBalance_CurrCode,
		'CRS502' cType, --Intereses
		CASE WHEN moneda = 1 THEN intcon_soles ELSE intcon_dolares END cPaymentAmnt,
		CASE WHEN moneda = 1 THEN 'PEN' ELSE 'USD' END cPaymentAmnt_currCode,
		CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 1 THEN 'Individual' WHEN 2 THEN 'Organisation' ELSE CAST(NULL AS VARCHAR2(100)) END ccTypeHolder,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopaisvinculo)) ccResCountryCode,
		CAST(NULL AS VARCHAR2(100)) ccIN,
		CAST(NULL AS VARCHAR2(100)) ccIN_IssuedBy,
		TRANSLATE(bd_nombrecompleto(personavinculada), '&', 'Y') ccName,
		CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 2 THEN 'OECD207' WHEN 2 THEN 'OECD202' ELSE CAST(NULL AS VARCHAR2(100)) END ccName_nameType,
		TRIM(pkg_personanatural.f_obt_nombres(personavinculada)) ccFirstName,
		TRIM(TRIM(pkg_personanatural.f_obt_apellidopaterno(personavinculada)) || ' ' || TRIM(pkg_personanatural.f_obt_apellidomaterno(personavinculada))) ccLastName,
		CAST(NULL AS VARCHAR2(100)) ccAddress_legalAddressType,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopaisvinculo)) ccCountryCode,
		CAST(direccionvinculo AS VARCHAR2(1000)) ccAddressFree,
		CAST(NULL AS VARCHAR2(100)) ccStreet,
		CAST(NULL AS VARCHAR2(100)) ccBuildingIdentifier,
		CAST(NULL AS VARCHAR2(100)) ccSuiteIdentifier,
		CAST(NULL AS VARCHAR2(100)) ccFloorIdentifier,
		CAST(NULL AS VARCHAR2(100)) ccDistrictName,
		CAST(NULL AS VARCHAR2(100)) ccPOB,
		CAST(NULL AS VARCHAR2(100)) ccPostCode,
		CAST(NULL AS VARCHAR2(100)) ccCity,
		pkg_personanatural.f_obt_fechacumpleanos(personavinculada) ccBirthDate,
		CAST(NULL AS VARCHAR2(100)) ccBirthCity,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(personavinculada))) ccBirthCountryCode,
		CAST(NULL AS VARCHAR2(100)) ccBirthFormerCountryName

FROM (
		SELECT	maxfecha_reporte.numerocuenta,
				maxfecha_reporte.codigopersona,
				maxfecha_reporte.tablaservicio,
				maxfecha_reporte.tipopersona,
				--maxfecha_reporte.codigodireccion
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
				CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.saldoimporte1 ELSE ROUND(ca.saldoimporte1 * GEN05200('31/12/2018', 3, 3), 2) END AS salcon_soles,
				CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.saldoimporte1 ELSE ROUND(ca.saldoimporte1 / GEN05200('31/12/2018', 3, 3), 2) END AS salcon_dolares,
				CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.interestotal ELSE ROUND(ca.interestotal * GEN05200('31/12/2018', 3, 3), 2) END AS intcon_soles,
				CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.interestotal ELSE ROUND(ca.interestotal / GEN05200('31/12/2018', 3, 3), 2) END AS intcon_dolares,
				NULL AS personavinculada,
				NULL AS tipovinculo,
				NULL AS direccionvinculo,
				NULL AS codigopaisvinculo
		FROM captacionanexo ca
		INNER JOIN (SELECT ca.numerocuenta,
							cuenta_reporte.moneda,
							codigopersona,
							ca.tablaservicio,
							cuenta_reporte.estado,
							tipopersona,
							codigodireccion,
							codigopais,
							MAX(fecha) AS maxfecha
					FROM captacionanexo ca
					INNER JOIN (SELECT numerocuenta,
										cc.moneda,
										cc.codigopersona,
										cc.tablaservicio,
										cc.estado,
										tipopersona,
										codigodireccion,
										codigopais 
								FROM cuentacorriente cc
								INNER JOIN (SELECT per.codigopersona,
													per.tipopersona,
													codigodireccion,
													codigopais
											FROM persona per
											INNER JOIN (SELECT perdir2018.codigopersona,
																perdir2018.codigodireccion,
																codigopais
														FROM personadireccion_20181231 perdir2018
														INNER JOIN (SELECT codigopersona,
																			MAX(pd.codigodireccion) codigodireccion
																	FROM personadireccion_20181231 pd 
																	WHERE pd.tipodireccion = 1
																		AND pd.enviocorreo ='S' 
																	GROUP BY codigopersona
																	) maxperdir2018
														ON perdir2018.codigopersona = maxperdir2018.codigopersona
															AND perdir2018.codigodireccion = maxperdir2018.codigodireccion
															INNER JOIN (SELECT codigodireccion,
																				codigopais
																		FROM direccion_20181231 dir2018
																		INNER JOIN (SELECT tbl_pais.TBLCODARG
																					FROM t_wdd_paises auxpais
																					INNER JOIN (SELECT TBLCODARG,
																										UPPER(TBLDESCRI) AS nom_pais
																								FROM syst900
																								WHERE tblcodtab = 3
																								) tbl_pais
																					ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca = 'X'
																					) pais_reporte
																		ON dir2018.codigopais = pais_reporte.TBLCODARG
																		) dir_reporte
															ON perdir2018.codigodireccion = dir_reporte.codigodireccion
														) perdir_reporte
											ON per.codigopersona = perdir_reporte.codigopersona
											) persona_reporte
								ON cc.codigopersona = persona_reporte.codigopersona
								) cuenta_reporte
					ON ca.numerocuenta = cuenta_reporte.numerocuenta
					WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY')			--Hasta el 31/12/2018
							AND (cuenta_reporte.tablaservicio = 101
								OR cuenta_reporte.tablaservicio = 102
								)
					GROUP BY ca.numerocuenta,
								cuenta_reporte.moneda,
								codigopersona,
								ca.tablaservicio,
								cuenta_reporte.estado,
								tipopersona,
								codigodireccion,
								codigopais
					) maxfecha_reporte
		ON ca.numerocuenta = maxfecha_reporte.numerocuenta
			AND maxfecha_reporte.maxfecha = ca.fecha

			--Lista de Socios que cumplen la condicion
			INNER JOIN ( 	SELECT canexo_reporte.codigopersona,
									--apo.numerocuenta,
									--canexo_reporte.moneda,
									--canexo_reporte.estado,
									SUM(canexo_reporte.saldopromedio),
									SUM(apo.saldoacumulado),
									SUM(apo.saldomaximo),
									SUM(canexo_reporte.saldofinal),
									SUM(canexo_reporte.interestotal)
							FROM 

							-- SALDOACUMULADO SALDOMAXIMO de la tabla APORTES
							(SELECT	apo.numerocuenta,
									ABS(SUM(CASE WHEN maxfecha_reporte.moneda = 2 THEN
												CASE WHEN MOD(tipomovimiento, 2) = 0 THEN
													IMPORTE1*(-1)
												ELSE
													IMPORTE1
												END
											ELSE
												CASE WHEN MOD(tipomovimiento, 2) = 0 THEN
													(IMPORTE1 * (-1)) / GEN05200('31/12/2018', 3, 3)
												ELSE 
													IMPORTE1 / GEN05200('31/12/2018', 3, 3)
												END
											END
										)	) AS SALDOACUMULADO,
									MAX(CASE WHEN maxfecha_reporte.moneda = 2 THEN apo.saldoimporte1 ELSE apo.saldoimporte1 / GEN05200('31/12/2018', 3, 3) END
										) AS SALDOMAXIMO
							FROM aportes apo
							INNER JOIN
								(SELECT cuenta_reporte.codigopersona,
										ca.numerocuenta,
										cuenta_reporte.moneda,
										cuenta_reporte.estado,
										MAX(fecha) AS maxfecha
								FROM captacionanexo ca
								INNER JOIN (SELECT numerocuenta,
													cc.moneda,
													cc.estado,
													cc.codigopersona,
													cc.tablaservicio,
													tipopersona,
													codigodireccion,
													codigopais
											FROM cuentacorriente cc
											INNER JOIN (SELECT per.codigopersona,
																per.tipopersona,
																codigodireccion,
																codigopais
														FROM persona per
														INNER JOIN (SELECT perdir2018.codigopersona,
																			perdir2018.codigodireccion,
																			codigopais
																	FROM personadireccion_20181231 perdir2018
																	INNER JOIN (SELECT codigopersona,
																						MAX(pd.codigodireccion) codigodireccion
																				FROM personadireccion_20181231 pd 
																				WHERE pd.tipodireccion = 1
																					AND pd.enviocorreo ='S' 
																				GROUP BY codigopersona
																				) maxperdir2018
																	ON perdir2018.codigopersona = maxperdir2018.codigopersona
																		AND perdir2018.codigodireccion = maxperdir2018.codigodireccion
																		INNER JOIN (SELECT codigodireccion, codigopais
																					FROM direccion_20181231 dir2018
																					INNER JOIN (SELECT tbl_pais.TBLCODARG
																								FROM t_wdd_paises auxpais
																								INNER JOIN (SELECT TBLCODARG,
																													UPPER(TBLDESCRI) AS nom_pais
																											FROM syst900
																											WHERE tblcodtab = 3
																											) tbl_pais
																								ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca = 'X'
																								) pais_reporte
																					ON dir2018.codigopais = pais_reporte.TBLCODARG
																					) dir_reporte
																		ON perdir2018.codigodireccion = dir_reporte.codigodireccion
																	) perdir_reporte
														ON per.codigopersona = perdir_reporte.codigopersona
														) persona_reporte
											ON cc.codigopersona = persona_reporte.codigopersona
											) cuenta_reporte
								ON ca.numerocuenta = cuenta_reporte.numerocuenta
								WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY')									--Hasta el 31/12/2018
										AND (cuenta_reporte.tablaservicio = 101 
											OR cuenta_reporte.tablaservicio = 102
											)		--Cuentas de Ahorro y CDE
										AND tipopersona = 1																	--Solo Personas Naturales
								GROUP BY cuenta_reporte.codigopersona,
											ca.numerocuenta,
											cuenta_reporte.moneda,
											cuenta_reporte.estado,
											fechaapertura
								) maxfecha_reporte
							ON maxfecha_reporte.numerocuenta = apo.numerocuenta
							WHERE TRUNC(apo.fechamovimiento) <= TO_DATE('31/12/2018','DD/MM/YYYY')
							GROUP BY apo.numerocuenta) apo
							INNER JOIN

							--SALDOFINAL SALDOPROMEDIO INTERESTOTAL de la tabla CAPTACIONANEXO
							(SELECT	maxfecha_reporte.codigopersona,
									maxfecha_reporte.numerocuenta,
									maxfecha_reporte.moneda,
									maxfecha_reporte.estado,
									maxfecha_reporte.saldopromedio,
									ca.saldoimporte1 AS saldofinal,
									ca.interestotal AS interestotal
							FROM captacionanexo ca
							INNER JOIN (SELECT cuenta_reporte.codigopersona,
												ca.numerocuenta,
												cuenta_reporte.moneda,
												cuenta_reporte.estado,
												MAX(fecha) AS maxfecha,
												SUM(saldoimporte1) / (MAX(fecha) - MIN(fecha)  + 1) AS saldopromedio
										FROM captacionanexo ca
										INNER JOIN (SELECT numerocuenta,
															cc.moneda,
															cc.estado,
															cc.codigopersona,
															cc.tablaservicio,
															tipopersona,
															codigodireccion,
															codigopais
													FROM cuentacorriente cc
													INNER JOIN (SELECT per.codigopersona,
																per.tipopersona,
																codigodireccion,
																codigopais
														FROM persona per
														INNER JOIN (SELECT perdir2018.codigopersona,
																			perdir2018.codigodireccion,
																			codigopais
																	FROM personadireccion_20181231 perdir2018
																	INNER JOIN (SELECT codigopersona,
																						max(pd.codigodireccion) codigodireccion
																				FROM personadireccion_20181231 pd 
																				WHERE pd.tipodireccion = 1
																					AND pd.enviocorreo = 'S' 
																				GROUP BY codigopersona
																				) maxperdir2018
																	ON perdir2018.codigopersona = maxperdir2018.codigopersona
																		AND perdir2018.codigodireccion = maxperdir2018.codigodireccion
																	INNER JOIN (SELECT codigodireccion,
																					codigopais
																			FROM direccion_20181231 dir2018
																			INNER JOIN (SELECT tbl_pais.TBLCODARG
																						FROM t_wdd_paises auxpais
																						INNER JOIN (SELECT TBLCODARG,
																											UPPER(TBLDESCRI) AS nom_pais
																									FROM syst900
																									WHERE tblcodtab = 3
																									) tbl_pais
																						ON auxpais.pais_dp = tbl_pais.nom_pais
																						WHERE marca= 'X'
																						) pais_reporte
																			ON dir2018.codigopais = pais_reporte.TBLCODARG
																			) dir_reporte
																	ON perdir2018.codigodireccion = dir_reporte.codigodireccion
																	) perdir_reporte
														ON per.codigopersona = perdir_reporte.codigopersona
														) persona_reporte
													ON cc.codigopersona = persona_reporte.codigopersona
													) cuenta_reporte
										ON ca.numerocuenta = cuenta_reporte.numerocuenta
										WHERE TRUNC(fecha) <= TO_DATE('31/12/2018','DD/MM/YYYY')									--Hasta el 31/12/2018
												AND (cuenta_reporte.tablaservicio = 101 
													OR cuenta_reporte.tablaservicio = 102
													)		--Cuentas de Ahorro y CDE
												AND tipopersona = 1																	--Solo Personas Naturales
										GROUP BY cuenta_reporte.codigopersona,
													ca.numerocuenta,
													cuenta_reporte.moneda,
													cuenta_reporte.estado,
													fechaapertura
										) maxfecha_reporte
							ON ca.numerocuenta = maxfecha_reporte.numerocuenta
								AND maxfecha_reporte.maxfecha = ca.fecha
							) canexo_reporte
						ON canexo_reporte.numerocuenta = apo.numerocuenta
						GROUP BY canexo_reporte.codigopersona
						HAVING 	(SUM(saldofinal) >= 1000000
								OR SUM(interestotal) >= 1000000
								OR SUM(saldopromedio) >= 1000000
								OR SUM(saldoacumulado) >= 1000000
								OR SUM(saldomaximo) >= 1000000
								)
						) personas_reporte
		ON maxfecha_reporte.codigopersona = personas_reporte.codigopersona
	) ORDER BY cDocRefId;
