SELECT DISTINCT 'OECD1' cDocTypeIndic, 'PE2019PE2011106501300001' || LPAD(ROW_NUMBER() OVER(ORDER BY numerocuenta ASC),5,'0') AS cDocRefId, numerocuenta cAccountNumber, 'OECD605' cTypeAccountNumber,
CAST(NULL AS VARCHAR2(100)) cUndocumentedAccount, CAST(NULL AS VARCHAR2(100)) cClosedAccount, CAST(NULL AS VARCHAR2(100)) cDormantAccount, --Falta rellenar valores con el estado de la cuenta linea 41
CASE tipopersona WHEN 1 THEN 'Individual' ELSE 'Organisation' END cTypeHolder, upper(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cResCountryCode, CAST(NULL AS VARCHAR2(100)) cTIN, CAST(NULL AS VARCHAR2(100)) cTIN_IssuedBy,
TRANSLATE(bd_nombrecompleto(codigopersona), '&', 'Y') cName, CASE tipopersona WHEN 2 THEN 'OECD207' ELSE NULL END cName_nameType, TRIM(pkg_personanatural.f_obt_nombres(codigopersona)) cFirstName, TRIM(TRIM(pkg_personanatural.f_obt_apellidopaterno(codigopersona)) || ' ' || TRIM(pkg_personanatural.f_obt_apellidomaterno(codigopersona))) cLastName, 'OECD304' cAddress_legalAddressType, upper(pkg_syst900.f_obt_tbldesabr(3, codigopais)) cCountryCode,
TRIM(direccion) cAddressFree, CAST(NULL AS VARCHAR2(100)) cStreet, CAST(NULL AS VARCHAR2(100)) cBuildingIdentifier, CAST(NULL AS VARCHAR2(100)) cSuiteIdentifier, CAST(NULL AS VARCHAR2(100)) cFloorIdentifier,
CAST(NULL AS VARCHAR2(100)) cDistrictName, CAST(NULL AS VARCHAR2(100)) cPOB, CAST(NULL AS VARCHAR2(100)) cPostCode, CAST(NULL AS VARCHAR2(100)) cCity,
pkg_personanatural.f_obt_fechacumpleanos(codigopersona) cBirthDate, CAST(NULL AS VARCHAR2(100)) cBirthCity, upper(pkg_syst900.f_obt_tbldesabr(3, pkg_personanatural.f_obt_lugarnacimiento(codigopersona))) cBirthCountryCode, CAST(NULL AS VARCHAR2(100)) cBirthFormerCountryName, CASE tipopersona WHEN 2 THEN 'CRS101' ELSE NULL END cAcctHolderTypeCRS,

-- CtrlgPersonType
CASE tipovinculo
WHEN 1 THEN 'CRS803' --GERENTE GENERAL
WHEN 79 THEN 'CRS803' --ACCIONISTA
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
	SELECT	cta_max_reporte.numerocuenta,
			cta_max_reporte.codigopersona,
			cta_max_reporte.tablaservicio,
			cta_max_reporte.tipopersona,
			--reporte.codigodireccion,
			pkg_direccion.f_obt_tipovia(cta_max_reporte.codigodireccion)||' '||TRIM(pkg_direccion.f_obt_callenumero(cta_max_reporte.codigodireccion))||'  '||
			DECODE(TRIM(pkg_direccion.f_obt_numeropuerta(cta_max_reporte.codigodireccion)),NULL,NULL,'Nro.:'||TRIM(pkg_direccion.f_obt_numeropuerta(cta_max_reporte.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_manzana(cta_max_reporte.codigodireccion)),NULL,NULL,'Mz.:'||' '||TRIM(pkg_direccion.f_obt_manzana(cta_max_reporte.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_lote(cta_max_reporte.codigodireccion)),NULL,NULL,'Lt.:'||' '||TRIM(pkg_direccion.f_obt_lote(cta_max_reporte.codigodireccion)))||' '|| 
			DECODE(TRIM(pkg_direccion.f_obt_referencia(cta_max_reporte.codigodireccion)),NULL,NULL,'Referencia :'||TRIM(pkg_direccion.f_obt_referencia(cta_max_reporte.codigodireccion)))||' *** '|| 
			UPPER(pkg_direccion.f_obt_descdepartamento(cta_max_reporte.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descprovincia(cta_max_reporte.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descdistrito(cta_max_reporte.codigodireccion)) AS direccion,
			cta_max_reporte.codigopais,
			cta_max_reporte.maxfecha,
			cta_max_reporte.estado,
			cta_max_reporte.moneda,
			CASE WHEN cta_max_reporte.moneda=1 THEN cta_max_reporte.saldoimporte1 ELSE cta_max_reporte.saldoimporte1*GEN05200('31/12/2019', 3, 3) END AS salcon_soles,
			CASE WHEN cta_max_reporte.moneda=2 THEN cta_max_reporte.saldoimporte1 ELSE cta_max_reporte.saldoimporte1/GEN05200('31/12/2019', 3, 3) END AS salcon_dolares,
			CASE WHEN cta_max_reporte.moneda=1 THEN cta_max_reporte.interestotal ELSE cta_max_reporte.interestotal*GEN05200('31/12/2019', 3, 3) END AS intcon_soles,
			CASE WHEN cta_max_reporte.moneda=2 THEN cta_max_reporte.interestotal ELSE cta_max_reporte.interestotal/GEN05200('31/12/2019', 3, 3) END AS intcon_dolares,
			pjv.personavinculada,
			pjv.tipovinculo,
			pkg_direccion.f_obt_tipovia(pjv.codigodireccion)||' '||TRIM(pkg_direccion.f_obt_callenumero(pjv.codigodireccion))||'  '||
			DECODE(TRIM(pkg_direccion.f_obt_numeropuerta(pjv.codigodireccion)),NULL,NULL,'Nro.:'||TRIM(pkg_direccion.f_obt_numeropuerta(pjv.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_manzana(pjv.codigodireccion)),NULL,NULL,'Mz.:'||' '||TRIM(pkg_direccion.f_obt_manzana(pjv.codigodireccion)))||' '||
			DECODE(TRIM(pkg_direccion.f_obt_lote(pjv.codigodireccion)),NULL,NULL,'Lt.:'||' '||TRIM(pkg_direccion.f_obt_lote(pjv.codigodireccion)))||' '|| 
			DECODE(TRIM(pkg_direccion.f_obt_referencia(pjv.codigodireccion)),NULL,NULL,'Referencia :'||TRIM(pkg_direccion.f_obt_referencia(pjv.codigodireccion)))||' *** '|| 
			UPPER(pkg_direccion.f_obt_descdepartamento(pjv.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descprovincia(pjv.codigodireccion))||' - '||
			UPPER(pkg_direccion.f_obt_descdistrito(pjv.codigodireccion)) AS direccionvinculo,
			pkg_direccion.f_obt_codigopais(pjv.codigodireccion) AS codigopaisvinculo
	FROM 
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
				INNER JOIN (SELECT ca.numerocuenta, codigopersona, ca.tablaservicio, cuenta_reporte.estado, tipopersona, codigodireccion, codigopais, max(fecha) AS maxfecha
					FROM captacionanexo ca
					INNER JOIN (SELECT numerocuenta, cc.codigopersona, cc.tablaservicio, cc.estado, tipopersona, codigodireccion, codigopais FROM cuentacorriente cc
						INNER JOIN (SELECT per.codigopersona, per.tipopersona, codigodireccion, codigopais FROM persona per
							INNER JOIN (SELECT perdir2019.codigopersona, perdir2019.codigodireccion, codigopais FROM personadireccion_20191231 perdir2019
								INNER JOIN (SELECT codigopersona, max(pd.codigodireccion) codigodireccion FROM personadireccion_20191231 pd 
											WHERE pd.tipodireccion = 1 AND pd.enviocorreo ='S' 
											GROUP BY codigopersona) maxperdir2019
								ON perdir2019.codigopersona = maxperdir2019.codigopersona
									AND perdir2019.codigodireccion = maxperdir2019.codigodireccion
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
					GROUP BY ca.numerocuenta, codigopersona, ca.tablaservicio, cuenta_reporte.estado, tipopersona, codigodireccion, codigopais) maxfecha_reporte
				ON ca.numerocuenta = maxfecha_reporte.numerocuenta AND maxfecha_reporte.maxfecha = ca.fecha) cta_max_reporte
	LEFT JOIN (SELECT pjv.codigopersona, pjv.personavinculada, pjv.tipovinculo, maxdir2019.codigodireccion
				FROM personajurvinculada pjv 
				INNER JOIN (SELECT codigopersona, max(pd.codigodireccion) codigodireccion FROM personadireccion_20191231 pd 
							WHERE pd.tipodireccion = 1 AND pd.enviocorreo ='S' 
							GROUP BY codigopersona) maxdir2019
				ON pjv.codigopersona = maxdir2019.codigopersona) pjv
	ON pjv.codigopersona = cta_max_reporte.codigopersona
	WHERE (pjv.tipovinculo = 1 OR pjv.tipovinculo = 79 OR pjv.tipovinculo IS NULL)

	-- Falta 2018
	);