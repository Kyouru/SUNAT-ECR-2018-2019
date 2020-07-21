--Falta el TIN
--Falta Tipo Cuenta
DECLARE

    v_buffer varchar2(32767);
    i       NUMBER := 1;
    
    v_SendingCompanyIN              VARCHAR2(500 BYTE) := '20111065013';
    v_TransmittingCountry           VARCHAR2(2 BYTE) := 'PE';
    v_ReceivingCountry              VARCHAR2(2 BYTE) := 'PE';
    v_MessageType                   VARCHAR2(20 BYTE) := 'FATCA-CRS';
    v_Warning                       VARCHAR2(500 BYTE) := NULL;
    v_Contact                       VARCHAR2(500 BYTE) := NULL;
    v_MessageRefId                  VARCHAR2(24 BYTE) := 'PE2018PE2011106501300001';
    v_MessageTypeIndic              VARCHAR2(6 BYTE) := 'CRS701';
    v_ReportingPeriod               DATE := TO_DATE('2018-12-31', 'YYYY-MM-DD');
    v_Timestamp                     DATE := SYSDATE;
    
    v2_ResCountryCode                VARCHAR2(2 BYTE) := 'PE';
    v2_TIN                           VARCHAR2(50 BYTE) := 'TIN20111065013';
    v2_TIN_issuedBy                  VARCHAR2(2 BYTE) := 'PE';
    v2_Name                          VARCHAR2(200 BYTE) := 'COOPERATIVA DE AHORRO Y CREDITO PACIFICO';
    v2_Name_nameType                 VARCHAR2(7 BYTE) := 'OECD202';
    v2_Address_legalAddressType      VARCHAR2(7 BYTE) := NULL;
    v2_CountryCode                   VARCHAR2(2 BYTE) := 'PE';
    v2_AddressFree                   VARCHAR2(1000 BYTE) := 'Calle Las Orquideas Nro. 675, San Isidro, Lima';
    v2_Street                        VARCHAR2(1000 BYTE) := 'Calle Las Orquideas';
    v2_BuildingIdentifier            VARCHAR2(100 BYTE) := NULL;
    v2_SuiteIdentifier               VARCHAR2(100 BYTE) := NULL;
    v2_FloorIdentifier               VARCHAR2(100 BYTE) := '3';
    v2_DistrictName                  VARCHAR2(100 BYTE) := 'San Isidro';
    v2_POB                           VARCHAR2(100 BYTE) := NULL;
    v2_PostCode                      VARCHAR2(100 BYTE) := '15046';
    v2_City                          VARCHAR2(100 BYTE) := 'Lima';
    v2_DocTypeIndic                  VARCHAR2(7 BYTE) := 'OECD1';
    
    CURSOR c_accountreport IS
    SELECT DISTINCT cDocTypeIndic, cAccountNumber, cTypeHolder, cResCountryCode, cTIN, cTIN_IssuedBy,
            cName, cName_nameType, cFirstName, cLastName, cAddress_legalAddressType, cCountryCode,
            cAddressFree, cStreet, cBuildingIdentifier, cSuiteIdentifier, cFloorIdentifier,
            cDistrictName, cPOB, cPostCode, cCity,
            cBirthDate, cBirthCity, cBirthCountryCode, cBirthFormerCountryName, cAcctHolderTypeCRS, cCtrlgPersonType,
            cAccountBalance, cAccountBalance_CurrCode, cType, cPaymentAmnt, cPaymentAmnt_currCode
     FROM SISGODBA.ECR_ACCOUNTREPORT order by cAccountNumber;
    
    v3_DocTypeIndic                SISGODBA.ECR_ACCOUNTREPORT.cDocTypeIndic%TYPE;
    v3_AccountNumber                SISGODBA.ECR_ACCOUNTREPORT.cAccountNumber%TYPE;
    v3_TypeHolder               SISGODBA.ECR_ACCOUNTREPORT.cTypeHolder%TYPE;
    v3_ResCountryCode                SISGODBA.ECR_ACCOUNTREPORT.cResCountryCode%TYPE;
    v3_TIN                SISGODBA.ECR_ACCOUNTREPORT.cTIN%TYPE;
    v3_TIN_IssuedBy                SISGODBA.ECR_ACCOUNTREPORT.cTIN_IssuedBy%TYPE;
    v3_Name                SISGODBA.ECR_ACCOUNTREPORT.cName%TYPE;
    v3_Name_nameType                SISGODBA.ECR_ACCOUNTREPORT.cName_nameType%TYPE;
    v3_FirstName                SISGODBA.ECR_ACCOUNTREPORT.cFirstName%TYPE;
    v3_LastName                SISGODBA.ECR_ACCOUNTREPORT.cLastName%TYPE;
    v3_Address_legalAddressType                SISGODBA.ECR_ACCOUNTREPORT.cAddress_legalAddressType%TYPE;
    v3_CountryCode                SISGODBA.ECR_ACCOUNTREPORT.cCountryCode%TYPE;
    v3_AddressFree                SISGODBA.ECR_ACCOUNTREPORT.cAddressFree%TYPE;
    v3_Street                SISGODBA.ECR_ACCOUNTREPORT.cStreet%TYPE;
    v3_BuildingIdentifier                SISGODBA.ECR_ACCOUNTREPORT.cBuildingIdentifier%TYPE;
    v3_SuiteIdentifier                SISGODBA.ECR_ACCOUNTREPORT.cSuiteIdentifier%TYPE;
    v3_FloorIdentifier                SISGODBA.ECR_ACCOUNTREPORT.cFloorIdentifier%TYPE;
    v3_DistrictName                SISGODBA.ECR_ACCOUNTREPORT.cDistrictName%TYPE;
    v3_POB                SISGODBA.ECR_ACCOUNTREPORT.cPOB%TYPE;
    v3_PostCode                SISGODBA.ECR_ACCOUNTREPORT.cPostCode%TYPE;
    v3_City                SISGODBA.ECR_ACCOUNTREPORT.cCity%TYPE;
    v3_BirthDate                SISGODBA.ECR_ACCOUNTREPORT.cBirthDate%TYPE;
    v3_BirthCity                SISGODBA.ECR_ACCOUNTREPORT.cBirthCity%TYPE;
    v3_BirthCountryCode                SISGODBA.ECR_ACCOUNTREPORT.cBirthCountryCode%TYPE;
    v3_BirthFormerCountryName                SISGODBA.ECR_ACCOUNTREPORT.cBirthFormerCountryName%TYPE;
    v3_AcctHolderTypeCRS                SISGODBA.ECR_ACCOUNTREPORT.cAcctHolderTypeCRS%TYPE;
    v3_CtrlgPersonType                SISGODBA.ECR_ACCOUNTREPORT.cCtrlgPersonType%TYPE;
    v3_AccountBalance                SISGODBA.ECR_ACCOUNTREPORT.cAccountBalance%TYPE;
    v3_AccountBalance_CurrCode                SISGODBA.ECR_ACCOUNTREPORT.cAccountBalance_CurrCode%TYPE;
    v3_Type                SISGODBA.ECR_ACCOUNTREPORT.cType%TYPE;
    v3_PaymentAmnt                SISGODBA.ECR_ACCOUNTREPORT.cPaymentAmnt%TYPE;
    v3_PaymentAmnt_currCode                SISGODBA.ECR_ACCOUNTREPORT.cPaymentAmnt_currCode%TYPE;
    
    c_controllingaccount   SYS_REFCURSOR;
    
    v4_TypeHolder               SISGODBA.ECR_ACCOUNTREPORT.ccTypeHolder%TYPE;
    v4_ResCountryCode                SISGODBA.ECR_ACCOUNTREPORT.ccResCountryCode%TYPE;
    v4_TIN                SISGODBA.ECR_ACCOUNTREPORT.ccTIN%TYPE;
    v4_TIN_IssuedBy                SISGODBA.ECR_ACCOUNTREPORT.ccTIN_IssuedBy%TYPE;
    v4_Name                SISGODBA.ECR_ACCOUNTREPORT.ccName%TYPE;
    v4_Name_nameType                SISGODBA.ECR_ACCOUNTREPORT.ccName_nameType%TYPE;
    v4_FirstName                SISGODBA.ECR_ACCOUNTREPORT.ccFirstName%TYPE;
    v4_LastName                SISGODBA.ECR_ACCOUNTREPORT.ccLastName%TYPE;
    v4_Address_legalAddressType                SISGODBA.ECR_ACCOUNTREPORT.ccAddress_legalAddressType%TYPE;
    v4_CountryCode                SISGODBA.ECR_ACCOUNTREPORT.ccCountryCode%TYPE;
    v4_AddressFree                SISGODBA.ECR_ACCOUNTREPORT.ccAddressFree%TYPE;
    v4_Street                SISGODBA.ECR_ACCOUNTREPORT.ccStreet%TYPE;
    v4_BuildingIdentifier                SISGODBA.ECR_ACCOUNTREPORT.ccBuildingIdentifier%TYPE;
    v4_SuiteIdentifier                SISGODBA.ECR_ACCOUNTREPORT.ccSuiteIdentifier%TYPE;
    v4_FloorIdentifier                SISGODBA.ECR_ACCOUNTREPORT.ccFloorIdentifier%TYPE;
    v4_DistrictName                SISGODBA.ECR_ACCOUNTREPORT.ccDistrictName%TYPE;
    v4_POB                SISGODBA.ECR_ACCOUNTREPORT.ccPOB%TYPE;
    v4_PostCode                SISGODBA.ECR_ACCOUNTREPORT.ccPostCode%TYPE;
    v4_City                SISGODBA.ECR_ACCOUNTREPORT.ccCity%TYPE;
    v4_BirthDate                SISGODBA.ECR_ACCOUNTREPORT.ccBirthDate%TYPE;
    v4_BirthCity                SISGODBA.ECR_ACCOUNTREPORT.ccBirthCity%TYPE;
    v4_BirthCountryCode                SISGODBA.ECR_ACCOUNTREPORT.ccBirthCountryCode%TYPE;
    v4_BirthFormerCountryName                SISGODBA.ECR_ACCOUNTREPORT.ccBirthFormerCountryName%TYPE;
BEGIN

    v_buffer := v_buffer || '<oecd_ftc:FATCA_CRS  xmlns:sfa_ftc="urn:oecd:ties:fatcacrstypes:v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oecd_ftc="urn:fatcacrs:ties:v1" xmlns:sfa="urn:oecd:ties:stffatcatypes:v2"  version="2.1">' || chr(10);
    
    --Inicio Message Header
	v_buffer := v_buffer || chr(9) || '<oecd_ftc:MessageHeader>' || chr(10);
	
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:SendingCompanyIN>' || v_SendingCompanyIN || '</sfa_ftc:SendingCompanyIN>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:TransmittingCountry>' || v_TransmittingCountry || '</sfa_ftc:TransmittingCountry>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:ReceivingCountry>' || v_ReceivingCountry || '</sfa_ftc:ReceivingCountry>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:MessageType>' || v_MessageType || '</sfa_ftc:MessageType>' || chr(10);
	If v_Warning is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:Warning>' || v_Warning || '</sfa_ftc:Warning>' || chr(10);
	End If;
	If v_Contact is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:Contact>' || v_Contact || '</sfa_ftc:Contact>' || chr(10);
	End If;
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:MessageRefId>' || v_MessageRefId || '</sfa_ftc:MessageRefId>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:MessageTypeIndic>' || v_MessageTypeIndic || '</sfa_ftc:MessageTypeIndic>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:ReportingPeriod>' || TO_CHAR(v_ReportingPeriod, 'YYYY-MM-DD') || '</sfa_ftc:ReportingPeriod>' || chr(10);
	v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:Timestamp>' || TO_CHAR(v_Timestamp, 'YYYY-MM-DD') || 'T' || TO_CHAR(v_Timestamp, 'hh24:mm:ss') || 'Z</sfa_ftc:Timestamp>' || chr(10);
	
	v_buffer := v_buffer || chr(9) || '</oecd_ftc:MessageHeader>' || chr(10);
	dbms_output.put_line(v_buffer);
	v_buffer := NULL;
    --Fin Message Header
    
    --Inicio MessageBody
    v_buffer := v_buffer || chr(9) || '<oecd_ftc:MessageBody>' || chr(10);
    
    --Inicio ReportingFI
	
	v_buffer := v_buffer || chr(9) || chr(9) ||  '<sfa_ftc:ReportingFI>' || chr(10);
	
	If v2_ResCountryCode is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:ResCountryCode>' || v2_ResCountryCode || '</sfa_ftc:ResCountryCode>' || chr(10);
	End If;
	
	If v2_TIN is not Null Then
		If v2_TIN_issuedBy is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN issuedBy = "' || v2_TIN_issuedBy || '">' || v2_TIN || '</sfa_ftc:TIN>' || chr(10);
		Else
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN>' || v2_TIN || '</sfa_ftc:TIN>' || chr(10);
		End If;
	End If;
	
	If v2_Name is not Null Then
		If v2_Name_nameType is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name nameType = "' || v2_Name_nameType || '">' || v2_Name || '</sfa_ftc:Name>' || chr(10);
		Else
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name>' || v2_Name || '</sfa_ftc:Name>' || chr(10);
		End If;
	End If;
	
	If v2_Address_legalAddressType is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address legalAddressType = "' || v2_Address_legalAddressType || '">' || chr(10);
	Else
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address>' || chr(10);
	End If;
	
	If v2_CountryCode is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:CountryCode>' || v2_CountryCode || '</sfa:CountryCode>' || chr(10);
	End If;
	If v2_AddressFree is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFree>' || v2_AddressFree || '</sfa:AddressFree>' || chr(10);
	End If;
	If v2_Street is not null or v2_BuildingIdentifier is not null or v2_SuiteIdentifier is not null or 
		v2_FloorIdentifier is not null or v2_DistrictName is not null or
		v2_POB is not null or v2_PostCode is not null or v2_City is not null
	Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFix>' || chr(10);
		
		If v2_Street is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:Street>' || v2_Street || '</sfa:Street>' || chr(10);
		End If;
		
		If v2_BuildingIdentifier is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:BuildingIdentifier>' || v2_BuildingIdentifier || '</sfa:BuildingIdentifier>' || chr(10);
		End If;
		
		If v2_SuiteIdentifier is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:SuiteIdentifier>' || v2_SuiteIdentifier || '</sfa:SuiteIdentifier>' || chr(10);
		End If;
		
		If v2_FloorIdentifier is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:FloorIdentifier>' || v2_FloorIdentifier || '</sfa:FloorIdentifier>' || chr(10);
		End If;
		
		If v2_DistrictName is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:DistrictName>' || v2_DistrictName || '</sfa:DistrictName>' || chr(10);
		End If;
		
		If v2_POB is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:POB>' || v2_POB || '</sfa:POB>' || chr(10);
		End If;
		
		If v2_PostCode is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:PostCode>' || v2_PostCode || '</sfa:PostCode>' || chr(10);
		End If;
		
		If v2_City is not Null Then
			v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:City>' || v2_City || '</sfa:City>' || chr(10);
		End If;
		
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa:AddressFix>' || chr(10);
	End If;
	v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Address>' || chr(10);
	
	v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocSpec>' || chr(10);
	If v2_DocTypeIndic is not Null Then
		v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocTypeIndic>' || v2_DocTypeIndic || '</sfa_ftc:DocTypeIndic>' || chr(10);
	End If;
	
	--DocRefId
	v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocRefId>' || v_MessageRefId || lpad(i, 5, '0') || '</sfa_ftc:DocRefId>' || chr(10);
	i := i + 1;
	
	v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '</sfa_ftc:DocSpec>' || chr(10);
	
	v_buffer := v_buffer || chr(9) || chr(9) || '</sfa_ftc:ReportingFI>' || chr(10);
	dbms_output.put_line(v_buffer);
	v_buffer := NULL;
    --Fin ReportingFI
    
    --Inicio ReportingGroup
    v_buffer := v_buffer || chr(9) || chr(9) || '<sfa_ftc:ReportingGroup>' || chr(10);
     
    --Inicio AccountReport

    OPEN c_accountreport;
    LOOP
        FETCH c_accountreport INTO v3_DocTypeIndic, v3_AccountNumber, v3_TypeHolder,
            v3_ResCountryCode, v3_TIN, v3_TIN_IssuedBy, v3_Name, v3_Name_nameType,
            v3_FirstName, v3_LastName, v3_Address_legalAddressType, v3_CountryCode,
            v3_AddressFree, v3_Street, v3_BuildingIdentifier, v3_SuiteIdentifier, v3_FloorIdentifier,
            v3_DistrictName, v3_POB, v3_PostCode, v3_City, v3_BirthDate, v3_BirthCity, v3_BirthCountryCode,
            v3_BirthFormerCountryName, v3_AcctHolderTypeCRS, v3_CtrlgPersonType,
            v3_AccountBalance, v3_AccountBalance_CurrCode, v3_Type,
            v3_PaymentAmnt, v3_PaymentAmnt_currCode;
        EXIT WHEN c_accountreport%NOTFOUND;
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AccountReport>' || chr(10);
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocSpec>' || chr(10);
        If v3_DocTypeIndic is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocTypeIndic>' || v3_DocTypeIndic || '</sfa_ftc:DocTypeIndic>' || chr(10);
        End If;
        
        --DocRefId
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:DocRefId>' || v_MessageRefId || lpad(i, 5, '0') || '</sfa_ftc:DocRefId>' || chr(10);
        i := i + 1;
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:DocSpec>' || chr(10);
        
        If v3_AccountNumber is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AccountNumber>' || v3_AccountNumber || '</sfa_ftc:AccountNumber>' || chr(10);
        End If;
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AccountHolder>' || chr(10);
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:' || v3_TypeHolder || '>' || chr(10);
        
        If v3_ResCountryCode is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:ResCountryCode>' || v3_ResCountryCode || '</sfa_ftc:ResCountryCode>' || chr(10);
        End If;
        
        If v3_TIN is not Null Then
            If v3_TIN_issuedBy is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN issuedBy = "' || v3_TIN_issuedBy || '">' || v3_TIN || '</sfa_ftc:TIN>' || chr(10);
            Else
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN>' || v3_TIN || '</sfa_ftc:TIN>' || chr(10);
            End If;
        End If;
        
        If v3_TypeHolder = 'Individual' Then
        
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name>' || chr(10);
            If v3_FirstName is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:FirstName>' || v3_FirstName || '</sfa:FirstName>' || chr(10);
            End If;
            If v3_LastName is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:LastName>' || v3_LastName || '</sfa:LastName>' || chr(10);
            End If;
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Name>' || chr(10);
        Else
            If v3_Name_nameType is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name nameType = "' || v3_Name_nameType || '">' || v3_Name || '</sfa_ftc:Name>' || chr(10);
            Else
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name>' || v3_Name || '</sfa_ftc:Name>' || chr(10);
            End If;
        End If;
            
        If v3_Address_legalAddressType is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address legalAddressType = "' || v3_Address_legalAddressType || '">' || chr(10);
        Else
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address>' || chr(10);
        End If;
        
        If v3_CountryCode is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:CountryCode>' || v3_CountryCode || '</sfa:CountryCode>' || chr(10);
        End If;
        If v3_Street is not null or v3_BuildingIdentifier is not null or v3_SuiteIdentifier is not null or 
            v3_FloorIdentifier is not null or v3_DistrictName is not null or
            v3_POB is not null or v3_PostCode is not null or v3_City is not null
        Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFix>' || chr(10);
            
            If v3_Street is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:Street>' || v3_Street || '</sfa:Street>' || chr(10);
            End If;
            
            If v3_BuildingIdentifier is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:BuildingIdentifier>' || v3_BuildingIdentifier || '</sfa:BuildingIdentifier>' || chr(10);
            End If;
            
            If v3_SuiteIdentifier is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:SuiteIdentifier>' || v3_SuiteIdentifier || '</sfa:SuiteIdentifier>' || chr(10);
            End If;
            
            If v3_FloorIdentifier is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:FloorIdentifier>' || v3_FloorIdentifier || '</sfa:FloorIdentifier>' || chr(10);
            End If;
            
            If v3_DistrictName is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:DistrictName>' || v3_DistrictName || '</sfa:DistrictName>' || chr(10);
            End If;
            
            If v3_POB is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:POB>' || v3_POB || '</sfa:POB>' || chr(10);
            End If;
            
            If v3_PostCode is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:PostCode>' || v3_PostCode || '</sfa:PostCode>' || chr(10);
            End If;
            
            If v3_City is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:City>' || v3_City || '</sfa:City>' || chr(10);
            End If;
            
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa:AddressFix>' || chr(10);
        End If;
        If v3_AddressFree is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFree>' || v3_AddressFree || '</sfa:AddressFree>' || chr(10);
        End If;
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Address>' || chr(10);
        
        If v3_BirthDate is not Null Or v3_BirthCity is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:BirthInfo>' || chr(10);
            If v3_BirthDate is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:BirthDate>' || TO_CHAR(v3_BirthDate, 'YYYY-MM-DD') || '</sfa_ftc:BirthDate>' || chr(10);
            End If;
            If v3_BirthCity is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:City>' || v3_BirthCity || '</sfa_ftc:City>' || chr(10);
            End If;
        End If;
        If v3_BirthCountryCode is not Null Or v3_BirthFormerCountryName is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:CountryInfo>' || chr(10);
            If v3_BirthCountryCode is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:CountryCode>' || v3_BirthCountryCode || '</sfa_ftc:CountryCode>' || chr(10);
            End If;
            If v3_BirthFormerCountryName is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:FormerCountryName>' || v3_BirthFormerCountryName || '</sfa_ftc:FormerCountryName>' || chr(10);
            End If;
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:CountryInfo>' || chr(10);
        End If;
        If v3_BirthDate is not Null Or v3_BirthCity is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:BirthInfo>' || chr(10);
        End If;
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:' || v3_TypeHolder || '>' || chr(10);
        
        If v3_AcctHolderTypeCRS is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AcctHolderTypeCRS>' || v3_AcctHolderTypeCRS  || '</sfa_ftc:AcctHolderTypeCRS>' || chr(10);
        End If;
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:AccountHolder>' || chr(10);
        If v3_CtrlgPersonType is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:ControllingPerson>' || chr(10);
            
            OPEN c_controllingaccount FOR 'SELECT ccTypeHolder, ccResCountryCode, ccTIN, ccTIN_IssuedBy,
                ccName, ccName_nameType, ccFirstName, ccLastName, ccAddress_legalAddressType, ccCountryCode,
                ccAddressFree, ccStreet, ccBuildingIdentifier, ccSuiteIdentifier, ccFloorIdentifier,
                ccDistrictName, ccPOB, ccPostCode, ccCity,
                ccBirthDate, ccBirthCity, ccBirthCountryCode, ccBirthFormerCountryName
                FROM SISGODBA.ECR_ACCOUNTREPORT WHERE cAccountNumber = ' || v3_AccountNumber;
            LOOP
                FETCH c_controllingaccount INTO v4_TypeHolder,
                    v4_ResCountryCode, v4_TIN, v4_TIN_IssuedBy, v4_Name, v4_Name_nameType,
                    v4_FirstName, v4_LastName, v4_Address_legalAddressType, v4_CountryCode,
                    v4_AddressFree, v4_Street, v4_BuildingIdentifier, v4_SuiteIdentifier, v4_FloorIdentifier,
                    v4_DistrictName,
                    v4_POB, v4_PostCode, v4_City, v4_BirthDate, v4_BirthCity, v4_BirthCountryCode,
                    v4_BirthFormerCountryName;
                EXIT WHEN c_controllingaccount%NOTFOUND;
                
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:' || v4_TypeHolder || '>' || chr(10);
                If v4_ResCountryCode is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:ResCountryCode>' || v4_ResCountryCode || '</sfa_ftc:ResCountryCode>' || chr(10);
                End If;
                
                If v4_TIN is not Null Then
                    If v4_TIN_issuedBy is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN issuedBy = "' || v4_TIN_issuedBy || '">' || v4_TIN || '</sfa_ftc:TIN>' || chr(10);
                    Else
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:TIN>' || v4_TIN || '</sfa_ftc:TIN>' || chr(10);
                    End If;
                End If;
                If v4_TypeHolder = 'Individual' Then
        
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name>' || chr(10);
                    If v4_FirstName is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:FirstName>' || v4_FirstName || '</sfa:FirstName>' || chr(10);
                    End If;
                    If v4_LastName is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:LastName>' || v4_LastName || '</sfa:LastName>' || chr(10);
                    End If;
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Name>' || chr(10);
                Else
                    If v4_Name_nameType is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name nameType = "' || v4_Name_nameType || '">' || v3_Name || '</sfa_ftc:Name>' || chr(10);
                    Else
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Name>' || v4_Name || '</sfa_ftc:Name>' || chr(10);
                    End If;
                End If;
                    
                If v4_Address_legalAddressType is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address legalAddressType = "' || v4_Address_legalAddressType || '">' || chr(10);
                Else
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Address>' || chr(10);
                End If;
                
                If v4_CountryCode is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:CountryCode>' || v4_CountryCode || '</sfa:CountryCode>' || chr(10);
                End If;
                If v4_Street is not null or v4_BuildingIdentifier is not null or v4_SuiteIdentifier is not null or 
                    v4_FloorIdentifier is not null or v4_DistrictName is not null or
                    v4_POB is not null or v4_PostCode is not null or v4_City is not null
                Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFix>' || chr(10);
                    
                    If v4_Street is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:Street>' || v4_Street || '</sfa:Street>' || chr(10);
                    End If;
                    
                    If v4_BuildingIdentifier is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:BuildingIdentifier>' || v4_BuildingIdentifier || '</sfa:BuildingIdentifier>' || chr(10);
                    End If;
                    
                    If v4_SuiteIdentifier is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:SuiteIdentifier>' || v4_SuiteIdentifier || '</sfa:SuiteIdentifier>' || chr(10);
                    End If;
                    
                    If v4_FloorIdentifier is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:FloorIdentifier>' || v4_FloorIdentifier || '</sfa:FloorIdentifier>' || chr(10);
                    End If;
                    
                    If v4_DistrictName is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:DistrictName>' || v4_DistrictName || '</sfa:DistrictName>' || chr(10);
                    End If;
                    
                    If v4_POB is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:POB>' || v4_POB || '</sfa:POB>' || chr(10);
                    End If;
                    
                    If v4_PostCode is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:PostCode>' || v4_PostCode || '</sfa:PostCode>' || chr(10);
                    End If;
                    
                    If v4_City is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:City>' || v4_City || '</sfa:City>' || chr(10);
                    End If;
                    
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa:AddressFix>' || chr(10);
                End If;
                If v4_AddressFree is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa:AddressFree>' || v4_AddressFree || '</sfa:AddressFree>' || chr(10);
                End If;
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Address>' || chr(10);
                
                If v4_BirthDate is not Null Or v4_BirthCity is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:BirthInfo>' || chr(10);
                    If v4_BirthDate is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:BirthDate>' || TO_CHAR(v4_BirthDate, 'YYYY-MM-DD') || '</sfa_ftc:BirthDate>' || chr(10);
                    End If;
                    If v4_BirthCity is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:City>' || v4_BirthCity || '</sfa_ftc:City>' || chr(10);
                    End If;
                End If;
                If v4_BirthCountryCode is not Null Or v4_BirthFormerCountryName is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:CountryInfo>' || chr(10);
                    If v4_BirthCountryCode is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:CountryCode>' || v4_BirthCountryCode || '</sfa_ftc:CountryCode>' || chr(10);
                    End If;
                    If v4_BirthFormerCountryName is not Null Then
                        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:FormerCountryName>' || v4_BirthFormerCountryName || '</sfa_ftc:FormerCountryName>' || chr(10);
                    End If;
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:CountryInfo>' || chr(10);
                End If;
                If v4_BirthDate is not Null Or v4_BirthCity is not Null Then
                    v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:BirthInfo>' || chr(10);
                End If;
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:' || v4_TypeHolder || '>';
                
                dbms_output.put_line(v_buffer);
                v_buffer := NULL;
            END LOOP;
            CLOSE c_controllingaccount;
            
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:CtrlgPersonType>' || v3_CtrlgPersonType || '</sfa_ftc:CtrlgPersonType>' || chr(10);
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:ControllingPerson>' || chr(10);
        End If;
        
        If v3_AccountBalance is not Null Then
            If v3_AccountBalance_CurrCode is not Null Then
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AccountBalance currCode = "' || v3_AccountBalance_CurrCode ||'">' || TRIM(TO_CHAR(ROUND(v3_AccountBalance,2), '9999990,99')) || '</sfa_ftc:AccountBalance>' || chr(10);
            Else
                v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:AccountBalance>' || TRIM(TO_CHAR(ROUND(v3_AccountBalance,2), '9999990,99')) || '</sfa_ftc:AccountBalance>' || chr(10);
            End If;
        End If;
        
        If v3_PaymentAmnt is not Null And v3_PaymentAmnt_currCode is not Null And v3_Type is not Null Then
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Payment>' || chr(10);

            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:Type>' || v3_Type || '</sfa_ftc:Type>' || chr(10);
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || chr(9) || '<sfa_ftc:PaymentAmnt currCode = "' || v3_PaymentAmnt_CurrCode ||'">' || TRIM(TO_CHAR(ROUND(v3_PaymentAmnt,2), '9999990,99')) || '</sfa_ftc:PaymentAmnt>' || chr(10);
            
            v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || chr(9) || '</sfa_ftc:Payment>' || chr(10);
        End If;
        
        v_buffer := v_buffer || chr(9) || chr(9) || chr(9) || '</sfa_ftc:AccountReport>' || chr(10);
        dbms_output.put_line(v_buffer);
        v_buffer := NULL;
    END LOOP;
	CLOSE c_accountreport;
    --Fin AccountReport
    
    v_buffer := v_buffer || chr(9) || chr(9) || '</sfa_ftc:ReportingGroup>' || chr(10);
    --Fin ReportingGroup
    
    v_buffer := v_buffer || chr(9) || '</oecd_ftc:MessageBody>' || chr(10);
    --Fin MessageBody
    
    v_buffer := v_buffer ||'</oecd_ftc:FATCA_CRS>';
    
    dbms_output.put_line(v_buffer);
END;