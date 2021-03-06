
/****** Object:  StoredProcedure [dbo].[USP_NAPI_ErrorLogging]    Script Date: 08-11-2020 15:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[USP_NAPI_ErrorLogging]
(
	@UserId	varchar(100)
	,@LogCode varchar(100)
	,@AppName	varchar(100)
	,@RequestMethod	varchar(100)
	,@RequestUri	varchar(max)
	,@ErrorOccureTime	datetime
	,@ErrorMessage varchar(max)
	,@ErrorStack varchar(max)
)
As
Begin
    Insert into [NAPI_Error]
	(
		LogCode
		 ,UserId
		,AppName
		,RequestMethod
		,RequestUri
		,OccureTime
		,Message
		,Stack
		,CreatedTime
	)
	values
	(
		@LogCode
		,@UserId
		,@AppName
		,@RequestMethod
		,@RequestUri
		,@ErrorOccureTime
		,@ErrorMessage
		,@ErrorStack		
		,GETDATE()
	)

End


GO
/****** Object:  StoredProcedure [dbo].[USP_NAPI_Logging]    Script Date: 08-11-2020 15:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_NAPI_Logging]
(
	 @CommandType	varchar(100)
	,@LogCode	varchar(100)=null
	,@UserId	varchar(100)=null
	,@AppName	varchar(100)=null
	,@RequestTime	datetime=null
	,@Host	varchar(100)=null
	,@AbsoluteUri	nvarchar(200)=null
	,@RequestHeaders	varchar(max)=null
	,@RequestType	varchar(100)=null
	,@RequestBody	varchar(max)=null
	,@RequestMethod	varchar(100)=null
	,@ResponseStatusCode	varchar(100)=null
	,@ResponseHeader	varchar(max)=null
	,@ResponseBody	varchar(max)=null
	,@ResponseTime	datetime=null
)
As
Begin
    If(@CommandType='Request')
	Begin
	  Insert into NAPI_Log
	  (
		LogCode
		,UserId
		,AppName
		,RequestTime
		,Host
		,AbsoluteUri
		,RequestHeaders
		,RequestType
		,RequestBody
		,RequestMethod		
		,CreatedTime
	)
	values
	(
		@LogCode
		,@UserId
		,@AppName
		,@RequestTime
		,@Host
		,@AbsoluteUri
		,@RequestHeaders
		,@RequestType
		,@RequestBody
		,@RequestMethod		
		,GETDATE()
	)

	End
	Else If(@CommandType='Response')
	Begin 
	   Update NAPI_Log
	   set 
		 ResponseStatusCode=@ResponseStatusCode
		,ResponseHeader=@ResponseHeader
		,ResponseBody=@ResponseBody
		,ResponseTime=@ResponseTime
	   Where LogCode=@LogCode
	End  
	
End


GO
/****** Object:  StoredProcedure [dbo].[USP_StudentMaster]    Script Date: 08-11-2020 15:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[USP_StudentMaster]
(
	@StudentId int=null,
	@FirstName varchar(50)=null,
	@LastName varchar(50)=null,
	@EmailId varchar(50)=null,
	@Age int=null,
	@commandType Varchar(50)=null,
	@ResultCode varchar(50)=null output
)
As
Begin
	Begin Try
		if @commandType='I'
		BEGIN
			insert into StudentMaster(FirstName,LastName,EmailId,Age)
			Select  @FirstName,@LastName,@EmailId,@Age

			set @ResultCode='ST01'
		end
		Else if @commandType='E'
		Begin
		   Update StudentMaster
		   set 
				FirstName=@FirstName,
				LastName=@LastName,
				EmailId=@EmailId,
				Age=@Age
		  Where StudentId=@StudentId
		  set @ResultCode='ST02'
		End 
		Else if @commandType='D'
		Begin
		   Delete from StudentMaster
		   Where StudentId=@StudentId
		   set @ResultCode='ST03'
		End 
		Else if @commandType='Get'
		Begin
		   Select StudentId,FirstName,LastName,EmailId,Age,Cast(Dob as date)Dob  , salary from StudentMaster
		   where (StudentId=@StudentId or @StudentId is null) 
		   set @ResultCode='ST0'
		End 
	End Try
	Begin Catch
	 set @ResultCode='Error'
	End Catch
End
GO
/****** Object:  Table [dbo].[NAPI_Error]    Script Date: 08-11-2020 15:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NAPI_Error](
	[APIErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[LogCode] [varchar](100) NULL,
	[UserId] [varchar](100) NULL,
	[AppName] [varchar](100) NULL,
	[RequestMethod] [varchar](100) NULL,
	[RequestUri] [varchar](max) NULL,
	[OccureTime] [datetime] NULL,
	[Message] [varchar](max) NOT NULL,
	[Stack] [varchar](max) NOT NULL,
	[CreatedTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[APIErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NAPI_Log]    Script Date: 08-11-2020 15:31:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NAPI_Log](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[LogCode] [varchar](100) NULL,
	[UserId] [varchar](100) NULL,
	[AppName] [varchar](100) NULL,
	[RequestTime] [datetime] NULL,
	[Host] [varchar](100) NULL,
	[AbsoluteUri] [nvarchar](100) NULL,
	[RequestHeaders] [varchar](max) NULL,
	[RequestType] [varchar](100) NULL,
	[RequestBody] [varchar](max) NULL,
	[RequestMethod] [varchar](100) NULL,
	[ResponseStatusCode] [varchar](100) NULL,
	[ResponseHeader] [varchar](max) NULL,
	[ResponseBody] [varchar](max) NULL,
	[ResponseTime] [datetime] NULL,
	[CreatedTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StudentMaster]    Script Date: 08-11-2020 15:31:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StudentMaster](
	[StudentId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[EmailId] [varchar](50) NULL,
	[Age] [int] NULL,
	[salary] [decimal](18, 2) NULL,
	[Dob] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
