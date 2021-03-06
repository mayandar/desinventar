if exists (select * from sysobjects where id = object_id(N'FK_fichas_causas') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE fichas DROP CONSTRAINT FK_fichas_causas
GO

if exists (select * from sysobjects where id = object_id(N'FK_fichas_eventos') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE fichas DROP CONSTRAINT FK_fichas_eventos
GO

if exists (select * from sysobjects where id = object_id(N'FK_extension_fichas') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE extension DROP CONSTRAINT FK_extension_fichas
GO

if exists (select * from sysobjects where id = object_id(N'FK_wordsdocs_fichas') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE wordsdocs DROP CONSTRAINT FK_wordsdocs_fichas
GO

if exists (select * from sysobjects where id = object_id(N'FK_fichas_lev0') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE fichas DROP CONSTRAINT FK_fichas_lev0
GO

if exists (select * from sysobjects where id = object_id(N'FK_fichas_lev1') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE fichas DROP CONSTRAINT FK_fichas_lev1
GO

if exists (select * from sysobjects where id = object_id(N'FK_fichas_lev2') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE fichas DROP CONSTRAINT FK_fichas_lev2
GO

if exists (select * from sysobjects where id = object_id(N'FK_regiones_niveles') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE regiones DROP CONSTRAINT FK_regiones_niveles
GO

if exists (select * from sysobjects where id = object_id(N'FK_wordsdocs_words') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE wordsdocs DROP CONSTRAINT FK_wordsdocs_words
GO

if exists (select * from sysobjects where id = object_id(N'extension') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table extension
GO

if exists (select * from sysobjects where id = object_id(N'fichas') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table fichas
GO

if exists (select * from sysobjects where id = object_id(N'causas') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table causas
GO

if exists (select * from sysobjects where id = object_id(N'diccionario') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table diccionario
GO

if exists (select * from sysobjects where id = object_id(N'eventos') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table eventos
GO

if exists (select * from sysobjects where id = object_id(N'lev2') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table lev2
GO

if exists (select * from sysobjects where id = object_id(N'lev1') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table lev1
GO

if exists (select * from sysobjects where id = object_id(N'lev0') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table lev0
GO

if exists (select * from sysobjects where id = object_id(N'niveles') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table niveles
GO

if exists (select * from sysobjects where id = object_id(N'regiones') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table regiones
GO

if exists (select * from sysobjects where id = object_id(N'words') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table words
GO

if exists (select * from sysobjects where id = object_id(N'words_seq') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table words_seq
GO

if exists (select * from sysobjects where id = object_id(N'wordsdocs') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table wordsdocs
GO
