#ifdef _DEBUG


	CDataBase DataBase;						//数据库对象

	//连接数据库
		DataBase.SetConnectionInfo(dlgLogon.m_strServerIP, 1433, dlgLogon.m_strDataBaseName, dlgLogon.m_strUserName, dlgLogon.m_strPassword);
		DataBase.OpenConnection();

	char selcom[1024] = {0};
	ZeroMemory(selcom, sizeof(selcom));

	sprintf_s(selcom, "SELECT * FROM Kind");
	m_DataBase.ExecuteSentence(selcom, true);

	while(!m_DataBase.IsRecordsetEnd())//获取具体的数据
	{
		int KindID = m_DataBase.GetValue_INT("KindID");

		char szBuf[512] = {0};
		m_DataBase.GetValue_String("KindName", szBuf, sizeof(szBuf));

		char szBuf2[512] = {0};
		CXOREncrypt::EncryptData(szBuf, szBuf2, sizeof(szBuf2));

		sprintf_s(selcom, "UPDATE Kind SET [KindName] = \'%s\' WHERE [KindID]=%d", szBuf2, KindID);
		DataBase.ExecuteSentence(selcom, false);

		m_DataBase.MoveToNext();
	}

	ZeroMemory(selcom, sizeof(selcom));

	sprintf_s(selcom, "SELECT * FROM Sdup");
	m_DataBase.ExecuteSentence(selcom, true);

	while(!m_DataBase.IsRecordsetEnd())//获取具体的数据
	{
		int SdupID = m_DataBase.GetValue_INT("SdupID");

		char szBuf[512] = {0};
		m_DataBase.GetValue_String("SdupValue", szBuf, sizeof(szBuf));

		char szBuf2[512] = {0};
		CXOREncrypt::EncryptData(szBuf, szBuf2, sizeof(szBuf2));

		sprintf_s(selcom, "UPDATE Sdup SET [SdupValue] = \'%s\' WHERE [SdupID]=%d", szBuf2, SdupID);
		DataBase.ExecuteSentence(selcom, false);

		m_DataBase.MoveToNext();
	}

	exit(0);

#endif