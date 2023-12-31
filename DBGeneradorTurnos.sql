USE [GeneradorTurnos]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 29/11/2023 11:33:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comercios]    Script Date: 29/11/2023 11:33:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comercios](
	[IdComercio] [int] IDENTITY(1,1) NOT NULL,
	[NombreComercio] [nvarchar](max) NULL,
 CONSTRAINT [PK_Comercios] PRIMARY KEY CLUSTERED 
(
	[IdComercio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Servicios]    Script Date: 29/11/2023 11:33:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Servicios](
	[IdServicio] [int] IDENTITY(1,1) NOT NULL,
	[IdComercio] [int] NOT NULL,
	[NombreServicio] [nvarchar](255) NOT NULL,
	[HoraApertura] [time](7) NOT NULL,
	[HoraCierre] [time](7) NOT NULL,
	[DuracionMinutos] [int] NOT NULL,
 CONSTRAINT [PK_Servicios] PRIMARY KEY CLUSTERED 
(
	[IdServicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Turnos]    Script Date: 29/11/2023 11:33:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Turnos](
	[IdTurnos] [int] IDENTITY(1,1) NOT NULL,
	[IdServicio] [int] NOT NULL,
	[FechaTurno] [datetime2](7) NOT NULL,
	[HoraInicio] [time](7) NOT NULL,
	[HoraFin] [time](7) NOT NULL,
 CONSTRAINT [PK_Turnos] PRIMARY KEY CLUSTERED 
(
	[IdTurnos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servicios]  WITH CHECK ADD  CONSTRAINT [FK_Servicios_Comercios_IdComercio] FOREIGN KEY([IdComercio])
REFERENCES [dbo].[Comercios] ([IdComercio])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Servicios] CHECK CONSTRAINT [FK_Servicios_Comercios_IdComercio]
GO
ALTER TABLE [dbo].[Turnos]  WITH CHECK ADD  CONSTRAINT [FK_Turnos_Servicios_IdServicio] FOREIGN KEY([IdServicio])
REFERENCES [dbo].[Servicios] ([IdServicio])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Turnos] CHECK CONSTRAINT [FK_Turnos_Servicios_IdServicio]
GO
/****** Object:  StoredProcedure [dbo].[GenerarTurnos]    Script Date: 29/11/2023 11:33:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GenerarTurnos]
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdServicio INT
AS
BEGIN
    DECLARE @HoraApertura TIME;
    DECLARE @HoraCierre TIME;
    DECLARE @DuracionMinutos INT;
    DECLARE @FechaActual DATE;
    DECLARE @HoraInicio TIME;
    DECLARE @HoraFin TIME;

    SELECT @HoraApertura = HoraApertura,
           @HoraCierre = HoraCierre,
           @DuracionMinutos = DuracionMinutos
    FROM Servicios
    WHERE IdServicio = @IdServicio;

    SET @FechaActual = @FechaInicio;
    SET @HoraInicio = @HoraApertura;

    WHILE @FechaActual <= @FechaFin
    BEGIN
        SET @HoraFin = DATEADD(MINUTE, @DuracionMinutos, @HoraInicio);

        INSERT INTO Turnos (IdServicio, FechaTurno, HoraInicio, HoraFin)
        VALUES (@IdServicio, @FechaActual, @HoraInicio, @HoraFin);

		SELECT IdTurnos, IdServicio, FechaTurno, HoraInicio, HoraFin
		FROM Turnos

        SET @FechaActual = DATEADD(DAY, 1, @FechaActual);
        SET @HoraInicio = DATEADD(MINUTE, @DuracionMinutos, @HoraInicio);
    END;
END;
GO
