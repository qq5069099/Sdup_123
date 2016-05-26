USE [master]
GO
/****** 对象:  Database [SdupDB]    脚本日期: 12/08/2008 11:31:04 ******/
CREATE DATABASE [SdupDB] ON  PRIMARY 
( NAME = N'SdupDB', FILENAME = N'E:\SdupDB.mdf' , SIZE = 41216KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SdupDB_log', FILENAME = N'E:\SdupDB_log.LDF' , SIZE = 13632KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 COLLATE Chinese_PRC_CI_AS
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SdupDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SdupDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SdupDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SdupDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SdupDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SdupDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [SdupDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SdupDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SdupDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SdupDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SdupDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SdupDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SdupDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SdupDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SdupDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SdupDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SdupDB] SET  READ_WRITE 
GO
ALTER DATABASE [SdupDB] SET RECOVERY FULL 
GO
ALTER DATABASE [SdupDB] SET  MULTI_USER 
GO
if (((@@microsoftversion / power(2, 24) = 8) and (@@microsoftversion & 0xffff >= 760)) or 
		(@@microsoftversion / power(2, 24) >= 9) )begin 
	exec dbo.sp_dboption @dbname =  N'SdupDB', @optname = 'db chaining', @optvalue = 'OFF'
 end


GO

USE [SdupDB]
GO
/****** 对象:  Table [dbo].[Kind]    脚本日期: 02/08/2012 15:48:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Sdup](
	[SdupID] [int] IDENTITY(1,1) NOT NULL,
	[SdupValue] [nvarchar](512) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[AtTime] [datetime] NOT NULL CONSTRAINT [DF_Account_AtTime]  DEFAULT (getdate()),
 CONSTRAINT [PK_Account_1] PRIMARY KEY CLUSTERED 
(
	[SdupID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[Kind](
	[KindID] [int] IDENTITY(1,1) NOT NULL,
	[KindName] [nvarchar](64) COLLATE Chinese_PRC_CI_AS NOT NULL,
	[IsOut] [bit] NOT NULL CONSTRAINT [DF_Kind_IsOut]  DEFAULT ((1)),
	[AddTotal] [bit] NOT NULL CONSTRAINT [DF_Kind_AddTotal]  DEFAULT ((1)),
	[Width] [int] NOT NULL CONSTRAINT [DF_Kind_Width_1]  DEFAULT ((60)),
	[SortID] [int] NOT NULL CONSTRAINT [DF_Kind_SortID]  DEFAULT ((100)),
 CONSTRAINT [PK_Kind] PRIMARY KEY CLUSTERED 
(
	[KindID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

----------------------------------------------------------------------------------------------------

INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('张工收' , 0, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('张工支', 1, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('平面图', 0, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('效果图', 0, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('全套图', 0, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('业  主', 0, 0)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('包工头', 0, 0)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('新客户', 0, 0)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('老客户', 0, 0)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('业务量', 0, 0)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('租物电', 1, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('办公费', 1, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('生活费', 1, 1)
INSERT INTO [Kind] ([KindName] ,[IsOut] ,[AddTotal]) VALUES ('其它支', 1, 1)

----------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[KindValue](
	[ValueID] [int] IDENTITY(1,1) NOT NULL,
	[SdupID] [int] NOT NULL,
	[KindID] [int] NOT NULL,
	[Value] [float] NOT NULL,
	[DateTime] [datetime] NOT NULL CONSTRAINT [DF_KindValue_AtTime]  DEFAULT (getdate()),
 CONSTRAINT [PK_Value] PRIMARY KEY CLUSTERED 
(
	[ValueID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

----------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GR_InsertSdup]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GR_InsertSdup]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- I D 登录
CREATE PROC GR_InsertSdup
	@SdupValue NVARCHAR(512)					-- 摘要信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	INSERT INTO Sdup([SdupValue]) VALUES(@SdupValue)
	SELECT  DISTINCT TOP(1) @@IDENTITY AS SdupID, AtTime FROM Sdup WHERE ([SdupValue]=@SdupValue) ORDER BY AtTime DESC

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GR_InsertKindValue]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GR_InsertKindValue]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- I D 登录
CREATE PROC GR_InsertKindValue
	@ValueID INT,					-- 金额ID号
	@SdupID INT,					-- 帐目ID号
	@KindID INT,					-- 类型ID号
	@Value FLOAT					-- 项目金额
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	IF @ValueID=0
	BEGIN
		INSERT INTO KindValue([SdupID],[KindID],[Value]) VALUES(@SdupID,@KindID,@Value)
		SELECT  DISTINCT TOP(1) @@IDENTITY AS ValueID FROM KindValue ORDER BY ValueID DESC
	END
	ELSE
	BEGIN
		IF @Value<>0.0
		BEGIN
			UPDATE KindValue SET [SdupID]=@SdupID,[KindID]=@KindID,[Value]=@Value,[DateTime]=GetDate() WHERE (ValueID=@ValueID)
			SELECT  DISTINCT TOP(1) * FROM KindValue WHERE (ValueID=@ValueID) ORDER BY ValueID DESC
		END
		ELSE
		BEGIN
			DELETE FROM KindValue WHERE (ValueID=@ValueID)
		END
	END

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GR_ClearJunkData]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GR_ClearJunkData]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

-- I D 登录
CREATE PROC GR_ClearJunkData
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN
	
	DELETE FROM KindValue WHERE ([Value]=0 OR (NOT EXISTS (SELECT * FROM Sdup WHERE Sdup.SdupID=KindValue.SdupID)))
	DELETE FROM Sdup WHERE (NOT EXISTS (SELECT * FROM KindValue WHERE Sdup.SdupID=KindValue.SdupID))

END

RETURN 0

GO
