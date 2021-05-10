--Reporte del periodo 2020
CREATE TABLE SISGODBA.ECR_ACCOUNTREPORT 
AS
SELECT DISTINCT 'OECD1' cDocTypeIndic,
		--Cambiar el periodo
		'PE20202011106501300001' || LPAD(ROW_NUMBER() OVER(ORDER BY numerocuenta ASC),5,'0') AS cDocRefId,
		numerocuenta cAccountNumber,
		'OECD605' cTypeAccountNumber,
		'false' cUndocumentedAccount,
		CASE estado WHEN 3 THEN 'true' WHEN 2 THEN 'true' ELSE 'false' END cClosedAccount,
		CASE estado WHEN 4 THEN 'true' ELSE 'false' END cDormantAccount,
		CASE tipopersona WHEN 1 THEN 'Individual' ELSE 'Organisation' END cTypeHolder,
		UPPER(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cResCountryCode,
		CASE tipopersona WHEN 1 THEN pkg_personanatural.f_obt_numerodocumentoid(codigopersona) ELSE (CASE pkg_persona.f_obt_numeroruc(codigopersona) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE TO_CHAR(pkg_persona.f_obt_numeroruc(codigopersona)) END) END cIN,
		CASE tipopersona WHEN 1 THEN (CASE pkg_personanatural.f_obt_tipodocumentoid(codigopersona) WHEN 1 THEN 'PE' ELSE UPPER(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(codigopersona))) END) ELSE (CASE pkg_persona.f_obt_numeroruc(codigopersona) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE 'PE' END) END cIN_IssuedBy,
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
		CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 1 THEN pkg_personanatural.f_obt_numerodocumentoid(personavinculada) ELSE TO_CHAR(pkg_persona.f_obt_numeroruc(personavinculada)) END ccIN,
		CASE personavinculada
			WHEN 1 THEN
                (CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 1 THEN (CASE pkg_personanatural.f_obt_tipodocumentoid(personavinculada) WHEN 1 THEN 'PE' ELSE CAST(NULL AS VARCHAR2(100)) END) ELSE (CASE pkg_persona.f_obt_numeroruc(personavinculada) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE 'PE' END) END)
            WHEN 79 THEN
                (CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 1 THEN (CASE pkg_personanatural.f_obt_tipodocumentoid(personavinculada) WHEN 1 THEN 'PE' ELSE CAST(NULL AS VARCHAR2(100)) END) ELSE (CASE pkg_persona.f_obt_numeroruc(personavinculada) WHEN NULL THEN CAST(NULL AS VARCHAR2(100)) ELSE 'PE' END) END)
            ELSE CAST(NULL AS VARCHAR2(100))
        END ccIN_IssuedBy,
		TRANSLATE(bd_nombrecompleto(personavinculada), '&', 'Y') ccName,
		CASE pkg_persona.f_obt_tipopersona(personavinculada) WHEN 2 THEN 'OECD207' WHEN 1 THEN 'OECD202' ELSE CAST(NULL AS VARCHAR2(100)) END ccName_nameType,
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
    -- Ctas. Nuevas al 2020 PN-PJ
	SELECT	cta_max_reporte.numerocuenta,
			cta_max_reporte.codigopersona,
			cta_max_reporte.tablaservicio,
			cta_max_reporte.tipopersona,

			--reporte.codigodireccion,
			(SELECT tipovia||' '||TRIM(callenumero)||'  '||
				DECODE(TRIM(numeropuerta),NULL,NULL,'Nro.:'||TRIM(numeropuerta))||' '||
				DECODE(TRIM(manzana),NULL,NULL,'Mz.:'||' '||TRIM(manzana))||' '||
				DECODE(TRIM(lote),NULL,NULL,'Lt.:'||' '||TRIM(lote))||' '|| 
				DECODE(TRIM(referencia),NULL,NULL,'Referencia :'||TRIM(referencia))||' *** '|| 
				UPPER(pkg_syst090.f_obt_descdepartamento(codigoregion, codigodepartamento))||' - '||
				UPPER(pkg_syst090.f_obt_descprovincia(codigoregion, codigodepartamento, codigoprovincia ))||' - '||
				UPPER(pkg_syst090.f_obt_descdistrito(codigoregion, codigodepartamento, codigoprovincia, codigodistrito ))
				FROM direccion_20201231 where codigodireccion = cta_max_reporte.codigodireccion) AS direccion,

			cta_max_reporte.codigopais,
			cta_max_reporte.estado,
			cta_max_reporte.moneda,
			CASE WHEN cta_max_reporte.moneda=1 THEN cta_max_reporte.saldoimporte1 ELSE cta_max_reporte.saldoimporte1*GEN05200('31/12/2020', 3, 3) END AS salcon_soles,
			CASE WHEN cta_max_reporte.moneda=2 THEN cta_max_reporte.saldoimporte1 ELSE cta_max_reporte.saldoimporte1/GEN05200('31/12/2020', 3, 3) END AS salcon_dolares,
			CASE WHEN cta_max_reporte.moneda=1 THEN cta_max_reporte.interestotal ELSE cta_max_reporte.interestotal*GEN05200('31/12/2020', 3, 3) END AS intcon_soles,
			CASE WHEN cta_max_reporte.moneda=2 THEN cta_max_reporte.interestotal ELSE cta_max_reporte.interestotal/GEN05200('31/12/2020', 3, 3) END AS intcon_dolares,
			pjv.personavinculada,
			pjv.tipovinculo,

			--pjv.codigodireccion,
			CASE WHEN pjv.codigodireccion IS NOT NULL THEN
				(SELECT tipovia||' '||TRIM(callenumero)||'  '||
				DECODE(TRIM(numeropuerta),NULL,NULL,'Nro.:'||TRIM(numeropuerta))||' '||
				DECODE(TRIM(manzana),NULL,NULL,'Mz.:'||' '||TRIM(manzana))||' '||
				DECODE(TRIM(lote),NULL,NULL,'Lt.:'||' '||TRIM(lote))||' '|| 
				DECODE(TRIM(referencia),NULL,NULL,'Referencia :'||TRIM(referencia))||' *** '|| 
				UPPER(pkg_syst090.f_obt_descdepartamento(codigoregion, codigodepartamento))||' - '||
				UPPER(pkg_syst090.f_obt_descprovincia(codigoregion, codigodepartamento, codigoprovincia ))||' - '||
				UPPER(pkg_syst090.f_obt_descdistrito(codigoregion, codigodepartamento, codigoprovincia, codigodistrito ))
				FROM direccion_20201231 where codigodireccion = cta_max_reporte.codigodireccion)
				ELSE CAST(NULL AS VARCHAR2(100)) END AS direccionvinculo,

			pkg_direccion.f_obt_codigopais(pjv.codigodireccion) AS codigopaisvinculo
	FROM 
		--Ctas. Nuevas al 31/12/2020
		(SELECT maxfecha_reporte.numerocuenta,
				maxfecha_reporte.codigopersona,
				maxfecha_reporte.tablaservicio,
				maxfecha_reporte.tipopersona,
				maxfecha_reporte.codigodireccion,
				maxfecha_reporte.codigopais,
				maxfecha_reporte.maxfecha,
				maxfecha_reporte.estado,
				ca.moneda,
				ca.saldoimporte1,
				ca.interestotal
				FROM captacionanexo ca
				INNER JOIN (SELECT ca.numerocuenta,
									codigopersona,
									ca.tablaservicio,
									cuenta_reporte.estado,
									tipopersona,
									codigodireccion,
									codigopais,
									MAX(fecha) AS maxfecha
							FROM captacionanexo ca
							INNER JOIN (SELECT numerocuenta,
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
													INNER JOIN (SELECT perdir2020.codigopersona,
																		perdir2020.codigodireccion,
																		codigopais
																FROM personadireccion_20201231 perdir2020
																INNER JOIN (SELECT codigopersona,
																					MAX(pd.codigodireccion) codigodireccion
																			FROM personadireccion_20201231 pd
																			WHERE pd.tipodireccion = 1
																				AND pd.enviocorreo ='S'
																			GROUP BY codigopersona
																			) maxperdir2020
																ON perdir2020.codigopersona = maxperdir2020.codigopersona
																	AND perdir2020.codigodireccion = maxperdir2020.codigodireccion
																	INNER JOIN (SELECT codigodireccion,
																						codigopais
																				FROM direccion_20201231 dir2020
																				INNER JOIN (SELECT tbl_pais.TBLCODARG
																							FROM t_wdd_paises auxpais
																							INNER JOIN (SELECT TBLCODARG,
																												UPPER(TBLDESCRI) AS nom_pais
																										FROM syst900
																										WHERE tblcodtab = 3
																										) tbl_pais
																							ON auxpais.pais_dp = tbl_pais.nom_pais
																							WHERE marca='X'
																							) pais_reporte
																				ON dir2020.codigopais = pais_reporte.TBLCODARG
																				) dir_reporte
																	ON perdir2020.codigodireccion = dir_reporte.codigodireccion
																) perdir_reporte
													ON per.codigopersona = perdir_reporte.codigopersona
													) persona_reporte
										ON cc.codigopersona = persona_reporte.codigopersona
										) cuenta_reporte
							ON ca.numerocuenta = cuenta_reporte.numerocuenta
							WHERE TRUNC(fecha) <= TO_DATE('31/12/2020','DD/MM/YYYY') 						--Hasta el 31/12/2020
								AND TRUNC(fechaapertura) >= TO_DATE('01/01/2020','DD/MM/YYYY') 			--Aperturadas en el periodo 2020
								AND (cuenta_reporte.tablaservicio = 101			--AHV
									OR cuenta_reporte.tablaservicio = 102)		--CDE
							GROUP BY ca.numerocuenta,
										codigopersona,
										ca.tablaservicio,
										cuenta_reporte.estado,
										tipopersona,
										codigodireccion,
										codigopais
							) maxfecha_reporte
		ON ca.numerocuenta = maxfecha_reporte.numerocuenta
			AND maxfecha_reporte.maxfecha = ca.fecha
		) cta_max_reporte
	LEFT JOIN (SELECT pjv.codigopersona,
						pjv.personavinculada,
						pjv.tipovinculo,
						maxdir2020.codigodireccion
				FROM personajurvinculada pjv 
				INNER JOIN (SELECT codigopersona,
									MAX(pd.codigodireccion) codigodireccion
							FROM personadireccion_20201231 pd 
							WHERE pd.tipodireccion = 1
								AND pd.enviocorreo ='S' 
							GROUP BY codigopersona
							) maxdir2020
				ON pjv.codigopersona = maxdir2020.codigopersona
				) pjv
	ON pjv.codigopersona = cta_max_reporte.codigopersona
	WHERE	(pjv.tipovinculo = 1
			OR pjv.tipovinculo = 79
			OR pjv.tipovinculo IS NULL
			)

	UNION ALL

	--Cuentas Preexistentes hasta el 31/12/2020 PN
	SELECT	maxfecha_reporte.numerocuenta,
			maxfecha_reporte.codigopersona,
			maxfecha_reporte.tablaservicio,
			maxfecha_reporte.tipopersona,
			--maxfecha_reporte.codigodireccion
				(SELECT tipovia||' '||TRIM(callenumero)||'  '||
					DECODE(TRIM(numeropuerta),NULL,NULL,'Nro.:'||TRIM(numeropuerta))||' '||
					DECODE(TRIM(manzana),NULL,NULL,'Mz.:'||' '||TRIM(manzana))||' '||
					DECODE(TRIM(lote),NULL,NULL,'Lt.:'||' '||TRIM(lote))||' '|| 
					DECODE(TRIM(referencia),NULL,NULL,'Referencia :'||TRIM(referencia))||' *** '|| 
					UPPER(pkg_syst090.f_obt_descdepartamento(codigoregion, codigodepartamento))||' - '||
					UPPER(pkg_syst090.f_obt_descprovincia(codigoregion, codigodepartamento, codigoprovincia ))||' - '||
					UPPER(pkg_syst090.f_obt_descdistrito(codigoregion, codigodepartamento, codigoprovincia, codigodistrito ))
					FROM direccion_20201231 where codigodireccion = maxfecha_reporte.codigodireccion) AS direccion,
			maxfecha_reporte.codigopais,
			maxfecha_reporte.estado,
			maxfecha_reporte.moneda,
			CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.saldoimporte1 ELSE ca.saldoimporte1 * GEN05200('31/12/2020', 3, 3) END AS salcon_soles,
			CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.saldoimporte1 ELSE ca.saldoimporte1 / GEN05200('31/12/2020', 3, 3) END AS salcon_dolares,
			CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.interestotal ELSE ca.interestotal * GEN05200('31/12/2020', 3, 3) END AS intcon_soles,
			CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.interestotal ELSE ca.interestotal / GEN05200('31/12/2020', 3, 3) END AS intcon_dolares,
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
											INNER JOIN (SELECT perdir2020.codigopersona,
																perdir2020.codigodireccion,
																codigopais
														FROM personadireccion_20201231 perdir2020
														INNER JOIN (SELECT codigopersona,
																			MAX(pd.codigodireccion) codigodireccion
																	FROM personadireccion_20201231 pd 
																	WHERE pd.tipodireccion = 1
																		AND pd.enviocorreo ='S' 
																	GROUP BY codigopersona
																	) maxperdir2020
														ON perdir2020.codigopersona = maxperdir2020.codigopersona
															AND perdir2020.codigodireccion = maxperdir2020.codigodireccion
															INNER JOIN (SELECT codigodireccion,
																				codigopais
																		FROM direccion_20201231 dir2020
																		INNER JOIN (SELECT tbl_pais.TBLCODARG
																					FROM t_wdd_paises auxpais
																					INNER JOIN (SELECT TBLCODARG,
																										UPPER(TBLDESCRI) AS nom_pais
																								FROM syst900
																								WHERE tblcodtab = 3
																								) tbl_pais
																					ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca = 'X'
																					) pais_reporte
																		ON dir2020.codigopais = pais_reporte.TBLCODARG
																		) dir_reporte
															ON perdir2020.codigodireccion = dir_reporte.codigodireccion
														) perdir_reporte
											ON per.codigopersona = perdir_reporte.codigopersona
                                            WHERE tipopersona = 1                               --Solo Personas Naturales
											) persona_reporte
								ON cc.codigopersona = persona_reporte.codigopersona
								) cuenta_reporte
					ON ca.numerocuenta = cuenta_reporte.numerocuenta
					WHERE TRUNC(fechaapertura) <= TO_DATE('31/12/2019','DD/MM/YYYY')			--Ctas. aperturadas hasta el 31/12/2019
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
		
        UNION ALL
        --Ctas. Pre-Existentes EJ Al 31/12/2020
        SELECT	maxfecha_reporte.numerocuenta,
			maxfecha_reporte.codigopersona,
			maxfecha_reporte.tablaservicio,
			maxfecha_reporte.tipopersona,
			--maxfecha_reporte.codigodireccion
				(SELECT tipovia||' '||TRIM(callenumero)||'  '||
					DECODE(TRIM(numeropuerta),NULL,NULL,'Nro.:'||TRIM(numeropuerta))||' '||
					DECODE(TRIM(manzana),NULL,NULL,'Mz.:'||' '||TRIM(manzana))||' '||
					DECODE(TRIM(lote),NULL,NULL,'Lt.:'||' '||TRIM(lote))||' '|| 
					DECODE(TRIM(referencia),NULL,NULL,'Referencia :'||TRIM(referencia))||' *** '|| 
					UPPER(pkg_syst090.f_obt_descdepartamento(codigoregion, codigodepartamento))||' - '||
					UPPER(pkg_syst090.f_obt_descprovincia(codigoregion, codigodepartamento, codigoprovincia ))||' - '||
					UPPER(pkg_syst090.f_obt_descdistrito(codigoregion, codigodepartamento, codigoprovincia, codigodistrito ))
					FROM direccion_20201231 where codigodireccion = maxfecha_reporte.codigodireccion) AS direccion,
			maxfecha_reporte.codigopais,
			maxfecha_reporte.estado,
			maxfecha_reporte.moneda,
			CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.saldoimporte1 ELSE ca.saldoimporte1 * GEN05200('31/12/2020', 3, 3) END AS salcon_soles,
			CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.saldoimporte1 ELSE ca.saldoimporte1 / GEN05200('31/12/2020', 3, 3) END AS salcon_dolares,
			CASE WHEN maxfecha_reporte.moneda = 1 THEN ca.interestotal ELSE ca.interestotal * GEN05200('31/12/2020', 3, 3) END AS intcon_soles,
			CASE WHEN maxfecha_reporte.moneda = 2 THEN ca.interestotal ELSE ca.interestotal / GEN05200('31/12/2020', 3, 3) END AS intcon_dolares,
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
											INNER JOIN (SELECT perdir2020.codigopersona,
																perdir2020.codigodireccion,
																codigopais
														FROM personadireccion_20201231 perdir2020
														INNER JOIN (SELECT codigopersona,
																			MAX(pd.codigodireccion) codigodireccion
																	FROM personadireccion_20201231 pd 
																	WHERE pd.tipodireccion = 1
																		AND pd.enviocorreo ='S' 
																	GROUP BY codigopersona
																	) maxperdir2020
														ON perdir2020.codigopersona = maxperdir2020.codigopersona
															AND perdir2020.codigodireccion = maxperdir2020.codigodireccion
															INNER JOIN (SELECT codigodireccion,
																				codigopais
																		FROM direccion_20201231 dir2020
																		INNER JOIN (SELECT tbl_pais.TBLCODARG
																					FROM t_wdd_paises auxpais
																					INNER JOIN (SELECT TBLCODARG,
																										UPPER(TBLDESCRI) AS nom_pais
																								FROM syst900
																								WHERE tblcodtab = 3
																								) tbl_pais
																					ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca = 'X'
																					) pais_reporte
																		ON dir2020.codigopais = pais_reporte.TBLCODARG
																		) dir_reporte
															ON perdir2020.codigodireccion = dir_reporte.codigodireccion
														) perdir_reporte
											ON per.codigopersona = perdir_reporte.codigopersona
                                            WHERE tipopersona = 2                               --Solo Personas Juridicas
											) persona_reporte
								ON cc.codigopersona = persona_reporte.codigopersona
								) cuenta_reporte
					ON ca.numerocuenta = cuenta_reporte.numerocuenta
					WHERE TRUNC(fechaapertura) <= TO_DATE('31/12/2019','DD/MM/YYYY')			--Ctas. aperturadas hasta el 31/12/2019
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
													(IMPORTE1 * (-1)) / GEN05200('31/12/2020', 3, 3)
												ELSE 
													IMPORTE1 / GEN05200('31/12/2020', 3, 3)
												END
											END
										)	) AS SALDOACUMULADO,
									MAX(CASE WHEN maxfecha_reporte.moneda = 2 THEN apo.saldoimporte1 ELSE apo.saldoimporte1 / GEN05200('31/12/2020', 3, 3) END
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
														INNER JOIN (SELECT perdir2020.codigopersona,
																			perdir2020.codigodireccion,
																			codigopais
																	FROM personadireccion_20201231 perdir2020
																	INNER JOIN (SELECT codigopersona,
																						MAX(pd.codigodireccion) codigodireccion
																				FROM personadireccion_20201231 pd 
																				WHERE pd.tipodireccion = 1
																					AND pd.enviocorreo ='S' 
																				GROUP BY codigopersona
																				) maxperdir2020
																	ON perdir2020.codigopersona = maxperdir2020.codigopersona
																		AND perdir2020.codigodireccion = maxperdir2020.codigodireccion
																		INNER JOIN (SELECT codigodireccion, codigopais
																					FROM direccion_20201231 dir2020
																					INNER JOIN (SELECT tbl_pais.TBLCODARG
																								FROM t_wdd_paises auxpais
																								INNER JOIN (SELECT TBLCODARG,
																													UPPER(TBLDESCRI) AS nom_pais
																											FROM syst900
																											WHERE tblcodtab = 3
																											) tbl_pais
																								ON auxpais.pais_dp = tbl_pais.nom_pais WHERE marca = 'X'
																								) pais_reporte
																					ON dir2020.codigopais = pais_reporte.TBLCODARG
																					) dir_reporte
																		ON perdir2020.codigodireccion = dir_reporte.codigodireccion
																	) perdir_reporte
														ON per.codigopersona = perdir_reporte.codigopersona
														) persona_reporte
											ON cc.codigopersona = persona_reporte.codigopersona
											) cuenta_reporte
								ON ca.numerocuenta = cuenta_reporte.numerocuenta
								WHERE TRUNC(fechaapertura) <= TO_DATE('31/12/2019','DD/MM/YYYY')									--Ctas. aperturadas hasta el 31/12/2019
										AND (cuenta_reporte.tablaservicio = 101 
											OR cuenta_reporte.tablaservicio = 102
											)		--Cuentas de Ahorro y CDE
										AND tipopersona = 2																	--Solo Personas Juridicas
								GROUP BY cuenta_reporte.codigopersona,
											ca.numerocuenta,
											cuenta_reporte.moneda,
											cuenta_reporte.estado,
											fechaapertura
								) maxfecha_reporte
							ON maxfecha_reporte.numerocuenta = apo.numerocuenta
							WHERE TRUNC(apo.fechamovimiento) <= TO_DATE('31/12/2020','DD/MM/YYYY')              --Los movimientos al 31/12/2020
							GROUP BY apo.numerocuenta) apo
							INNER JOIN

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
														INNER JOIN (SELECT perdir2020.codigopersona,
																			perdir2020.codigodireccion,
																			codigopais
																	FROM personadireccion_20201231 perdir2020
																	INNER JOIN (SELECT codigopersona,
																						max(pd.codigodireccion) codigodireccion
																				FROM personadireccion_20201231 pd 
																				WHERE pd.tipodireccion = 1
																					AND pd.enviocorreo = 'S' 
																				GROUP BY codigopersona
																				) maxperdir2020
																	ON perdir2020.codigopersona = maxperdir2020.codigopersona
																		AND perdir2020.codigodireccion = maxperdir2020.codigodireccion
																	INNER JOIN (SELECT codigodireccion,
																					codigopais
																			FROM direccion_20201231 dir2020
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
																			ON dir2020.codigopais = pais_reporte.TBLCODARG
																			) dir_reporte
																	ON perdir2020.codigodireccion = dir_reporte.codigodireccion
																	) perdir_reporte
														ON per.codigopersona = perdir_reporte.codigopersona
														) persona_reporte
													ON cc.codigopersona = persona_reporte.codigopersona
													) cuenta_reporte
										ON ca.numerocuenta = cuenta_reporte.numerocuenta
										WHERE TRUNC(fecha) <= TO_DATE('31/12/2020','DD/MM/YYYY')									--Los movimientos Hasta el 31/12/2020
												AND (cuenta_reporte.tablaservicio = 101 
													OR cuenta_reporte.tablaservicio = 102
													)		--Cuentas de Ahorro y CDE
												AND tipopersona = 2																	--Solo Personas Juridicas
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
						HAVING 	(SUM(saldofinal) >= 250000
								OR SUM(interestotal) >= 250000
								OR SUM(saldopromedio) >= 250000
								OR SUM(saldoacumulado) >= 250000
								OR SUM(saldomaximo) >= 250000
								)
						) personas_reporte
		ON maxfecha_reporte.codigopersona = personas_reporte.codigopersona
	) ORDER BY cDocRefId;