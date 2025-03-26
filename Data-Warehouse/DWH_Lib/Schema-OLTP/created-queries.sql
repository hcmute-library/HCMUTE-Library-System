------------Tạo scheme để dễ dàng quản lý
------------Những bảng trong schema này chỉ để lưu trữ
CREATE SCHEMA oltp;

------------Tạo bảng lưu trữ các records của MARC theo quốc tế
CREATE TABLE [oltp].[USMARC](
	[Truong_ID] INT IDENTITY(1,1) NOT NULL,
	[Nhan_truong] VARCHAR(10) NOT NULL,
	[Ten_truong] NVARCHAR(255) NULL,
	[Nhom_ID] INT NOT NULL,
	[Truong_muc_tren] INT NULL,
	[Giai_thich] NVARCHAR(255) NULL,
	[Lap] BIT NOT NULL DEFAULT 1,
	[Ten_truong_English] VARCHAR(255) NULL,
	[Truong_USMARC] BIT NOT NULL DEFAULT 1,
	[Tham_chieu] INT NULL,
	[Bat_buoc] BIT NOT NULL DEFAULT 0,
	[Chuc_nang_ID] INT NULL,
	[CodedData] BIT NOT NULL DEFAULT 0,
	[Lap_USMARC] BIT NOT NULL DEFAULT 1,
	[Do_dai] INT NOT NULL DEFAULT 0,
	[Kieu_truong] INT NOT NULL DEFAULT 1,
	[Indicator_Eng] NVARCHAR(800) NULL,
	[Indicator_Viet] NVARCHAR(1000) NULL,
	[Lien_ket_ID] INT NULL,
	CONSTRAINT [PK_Ten_truong_USMARC] PRIMARY KEY NONCLUSTERED ([Truong_ID] ASC)
) ON [PRIMARY]

------------Tạo bảng lưu trữ các records của MARC theo VN
CREATE TABLE [oltp].[UNIMARC](
	[Truong_ID] INT IDENTITY(1,1) NOT NULL,
	[Nhan_truong] VARCHAR(10) NOT NULL,
	[Ten_truong] NVARCHAR(255) NULL,
	[Nhom_ID] INT NOT NULL,
	[Truong_muc_tren] INT NULL,
	[Giai_thich] NVARCHAR(255) NULL,
	[Lap] BIT NOT NULL DEFAULT 1,
	[Ten_truong_English] NVARCHAR(255) NULL,
	[Truong_UNIMARC] BIT NOT NULL DEFAULT 1,
	[Tham_chieu] INT NULL,
	[Bat_buoc] BIT NOT NULL DEFAULT 0,
	[Chuc_nang_ID] INT NULL,
	[CodedData] BIT NOT NULL DEFAULT 0,
	[Lap_UNIMARC] BIT NOT NULL DEFAULT 1,
	[Do_dai] INT NOT NULL DEFAULT 0,
	[Kieu_truong] INT NOT NULL DEFAULT 1,
	[Truong_con_chinh] NVARCHAR(2) NULL,
	CONSTRAINT [PK_Ten_truong_UNMARC] PRIMARY KEY NONCLUSTERED ([Truong_ID] ASC)
) ON [PRIMARY]

------------Tạo bảng lưu trữ các tài liệu theo records của MARC
CREATE TABLE [oltp].[Tai_lieu_marc](
    [ID] INT IDENTITY(1,1) NOT NULL,
	[ID_tai_lieu] INT NOT NULL,
	[Truong_ID] INT NOT NULL,
	[Gia_tri] VARCHAR(800) NOT NULL,
	[Indicators] VARCHAR(2) NULL,
	CONSTRAINT [PK_Tai_lieu_marc] PRIMARY KEY CLUSTERED (
			[ID] ASC,
			[ID_tai_lieu] ASC,
			[Truong_ID] ASC),
	CONSTRAINT [FK_Tai_lieu_marc_TaiLieu] FOREIGN KEY([ID_tai_lieu]) REFERENCES [olap].[DIM_Tai_lieu]([ID_tai_lieu]),
	CONSTRAINT [FK_Tai_lieu_marc_USMARC] FOREIGN KEY([Truong_ID]) REFERENCES [oltp].[USMARC]([Truong_ID])
) ON [PRIMARY]

CREATE TABLE oltp.Phieu_muon_sach (
    ID_phieu_muon int NOT NULL, -- Mã phiếu mượn, khóa chính
    ID_tai_lieu int NOT NULL, -- Mã tài liệu (FK đến DIM_Tai_lieu)
    ID_xep_gia int NOT NULL, -- Mã xếp giá (FK đến DIM_Xep_gia)
    ID_ban_doc nvarchar(100) NULL, -- Mã bạn đọc (FK đến DIM_Ban_doc)
    Ngay_muon int NOT NULL, -- Ngày mượn (FK đến DIM_Date)
    Ngay_tra int NULL, -- Ngày trả (FK đến DIM_Date)
    So_luot_gia_han smallint NULL, -- Số lượt gia hạn
    So_ngay_qua_han int NULL, -- Số ngày quá hạn
    Tien_phat money NULL, -- Tiền phạt
    Ghi_chu nvarchar(max) NULL, -- Ghi chú
    -- Khóa chính dạng clustered
    CONSTRAINT [PK_Phieu_muon_sach] PRIMARY KEY CLUSTERED (ID_phieu_muon), 
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Phieu_muon_sach_Ban_doc] FOREIGN KEY([ID_ban_doc]) REFERENCES [olap].[DIM_Ban_doc]([ID_ban_doc]),
    CONSTRAINT [FK_Phieu_muon_sach_Ngay_muon] FOREIGN KEY([Ngay_muon]) REFERENCES [olap].[DIM_Date]([Date_key]),
    CONSTRAINT [FK_Phieu_muon_sach_Ngay_tra] FOREIGN KEY([Ngay_tra]) REFERENCES [olap].[DIM_Date]([Date_key]),
    CONSTRAINT [FK_Phieu_muon_sach_Tai_lieu] FOREIGN KEY([ID_tai_lieu]) REFERENCES [olap].[DIM_Tai_lieu]([ID_tai_lieu]),
    CONSTRAINT [FK_Phieu_muon_sach_Xep_gia] FOREIGN KEY([ID_xep_gia]) REFERENCES [olap].[DIM_Xep_gia]([ID_xep_gia])
) ON [PRIMARY]
