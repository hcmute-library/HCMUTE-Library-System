------N Bảng [Dan_toc] ------
CREATE TABLE [dbo].[Dan_toc] (
    [ID] INT NOT NULL,
    [Dan_toc] NVARCHAR(28) NOT NULL,
    CONSTRAINT [PK_Dan_toc] PRIMARY KEY ([ID])
);
------N Bảng [Trinh_do] ------
CREATE TABLE [dbo].[Trinh_do] (
    [trinh_do_id] INT NOT NULL,
    [loai_trinh_do] NVARCHAR(50) NOT NULL,
	CONSTRAINT [PK_Trinh_do] PRIMARY KEY CLUSTERED ([trinh_do_id]),
);
------N Bảng [Khoa_hoc] ------
CREATE TABLE [dbo].[Khoa_hoc] (
    [ID] INT NOT NULL,
    [Ten_khoa_hoc] NVARCHAR(200) NULL,
	CONSTRAINT [PK_Khoa_hoc] PRIMARY KEY CLUSTERED ([ID]),
);

------N Bảng [Lop]------
CREATE TABLE [dbo].[Lop] (
    [ID] INT NOT NULL,
    [Ten_lop] NVARCHAR(200) NULL,
	CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED ([ID]),
);

------N Bảng [Nhom_ban_doc]------
CREATE TABLE [dbo].[Nhom_ban_doc] (
    [Nhom_ID] INT NOT NULL,
    [Ten_nhom] NVARCHAR(32) NOT NULL,
    [Sach_giu] INT NULL,
    [Sach_muon] INT NULL,
    [Tien_phat] MONEY NULL,
    [Sach_dat_truoc] INT NULL,
    [Hieu_luc_dat_muon] INT NULL,
    [Muc_uu_tien] INT NULL,
    [So_luot_gia_han] SMALLINT NOT NULL CONSTRAINT [DF_Nhom_ban_doc_So_luot_gia_han] DEFAULT 0,
    [Thoi_gian_gia_han] SMALLINT NOT NULL CONSTRAINT [DF_Nhom_ban_doc_Thoi_gian_gia_han] DEFAULT 0 ,
    [Thoi_gian_muon] INT NULL,
    [Sach_muon_gt] INT NULL,
    [thoi_gian_muon_gt] INT NULL,
    [Ghi_chu] NVARCHAR(500) NULL,
    CONSTRAINT [PK_Nhom_ban_doc] PRIMARY KEY CLUSTERED ([Nhom_ID])
);

------N Bảng [Nhom_nghanh_nghe]------
CREATE TABLE [dbo].[Nhom_nghanh_nghe] (
    [ID] INT NOT NULL,
    [Ten_nhom] NVARCHAR(64) NULL,
    CONSTRAINT [PK_Nhom_nghanh_nghe] PRIMARY KEY CLUSTERED ([ID])
);

------N Bảng [Thu_vien]------
CREATE TABLE [dbo].[Thu_vien] (
    [Thu_vien_ID] INT NOT NULL,
    [Thu_vien] NVARCHAR(80) NULL,
    [Dia_chi] NVARCHAR(120) NULL,
    [Ten_viet_tat] VARCHAR(32) NULL,
    [gia_tri] NVARCHAR(50) NULL,
    [LocalLib] BIT NOT NULL CONSTRAINT [DF_Thu_vien_LocalLib] DEFAULT 1,
    CONSTRAINT [PK_Thu_vien] PRIMARY KEY CLUSTERED ([Thu_vien_ID])
);

------N Bảng [Kho]------
CREATE TABLE [dbo].[Kho] (
    [Kho_ID] INT NOT NULL,
    [Kho] VARCHAR(50) NOT NULL,
    [Thu_vien_ID] INT NULL,
    [MaxID] INT NULL,
    [Mo] BIT NOT NULL CONSTRAINT [DF_Kho_Mo] DEFAULT (1),
    CONSTRAINT [PK_Kho] PRIMARY KEY CLUSTERED ([Kho_ID]),
    CONSTRAINT [FK_Kho_Thu_vien] FOREIGN KEY ([Thu_vien_ID]) REFERENCES [dbo].[Thu_vien] ([Thu_vien_ID])
);


------N Bảng [LoanType]------
CREATE TABLE [dbo].[LoanType] (
    [LoanTypeID] SMALLINT IDENTITY(1,1) NOT NULL,
    [LoanType] VARCHAR(100) NOT NULL,
    [LoanPeriod] TINYINT NOT NULL,
    [RenewalPeriod] TINYINT NOT NULL,
    [TimeUnit] TINYINT NOT NULL,
    [Renewals] TINYINT NULL CONSTRAINT [DF_LoanType_Renewals] DEFAULT (0),
    [OverdueFine] MONEY NOT NULL CONSTRAINT [DF_LoanType_OverdueFine] DEFAULT (0),
    [Fee] MONEY NOT NULL CONSTRAINT [DF_LoanType_Fee] DEFAULT (0),
    [FixedFee] BIT NOT NULL CONSTRAINT [DF_LoanType_FixedFee] DEFAULT (0),
    [Num_books] INT NULL,
    CONSTRAINT [PK_LoanType] PRIMARY KEY CLUSTERED ([LoanTypeID])
);


------N Bảng [Vat_mang_tin]------
CREATE TABLE [dbo].[Vat_mang_tin] (
    [Vat_mang_tin_ID] INT NOT NULL,
    [Ky_hieu] NVARCHAR(6) NULL,
    [Vat_mang_tin] NVARCHAR(32) NULL,
    CONSTRAINT [PK_Vat_mang_tin] PRIMARY KEY CLUSTERED ([Vat_mang_tin_ID])
);

------N Bảng [Dang_tai_lieu]------
CREATE TABLE [dbo].[Dang_tai_lieu] (
    [Dang_tai_lieu_ID] INT NOT NULL,
    [Dang_tai_lieu] VARCHAR(164) NULL,
    [Ky_hieu_tai_lieu] VARCHAR(6) NOT NULL,
    [LoanPeriod] SMALLINT NULL,
    [Renewals] TINYINT NULL,
    [RenewalPeriod] TINYINT NULL,
    [TimeUnit] TINYINT NULL,
    [Fee] MONEY NOT NULL CONSTRAINT [DF_Dang_tai_lieu_Fee] DEFAULT (0),
    [OverdueFine] MONEY NOT NULL CONSTRAINT [DF_Dang_tai_lieu_OverdueFine] DEFAULT (0),
    [FixedFee] BIT NOT NULL CONSTRAINT [DF_Dang_tai_lieu_FixedFee] DEFAULT (0),
    CONSTRAINT [PK_Dang_tai_lieu] PRIMARY KEY CLUSTERED ([Dang_tai_lieu_ID])
);

------N Bảng [Ten_nuoc]------
CREATE TABLE [dbo].[Ten_nuoc] (
    [Ma_nuoc_ID] INT NOT NULL,
    [Ten_nuoc_ISO] NVARCHAR(30) NULL,
    [Ten_nuoc_Viet] NVARCHAR(50) NULL,
    [Ma_ISO] NVARCHAR(2) NULL,
    CONSTRAINT [PK_Ten_nuoc] PRIMARY KEY NONCLUSTERED ([Ma_nuoc_ID])
);

------N Bảng [Ten_Form]------
CREATE TABLE [dbo].[Ten_Form] (
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Ten_form] VARCHAR(128) NOT NULL,
    [Nguoi_tao] VARCHAR(60) NOT NULL,
    [Ngay_tao] DATETIME NOT NULL,
    [Ngay_sua_cuoi] DATETIME NOT NULL,
    [Ghi_chu] VARCHAR(255) NULL,
    CONSTRAINT [PK_Ten_Form] PRIMARY KEY NONCLUSTERED ([ID])
);

------N Bảng [Ban_doc]------
CREATE TABLE [dbo].[Ban_doc] (
    [ID] INT NOT NULL,
    [So_the] VARCHAR(20) NOT NULL,
    [Ho_ten] NVARCHAR(100) NOT NULL,
    [Ngay_sinh] DATETIME NULL,
    [Dan_toc_ID] INT NULL,
    [Trinh_do_ID] INT NULL,
    [Nghe_nghiep] NVARCHAR(140) NULL,
    [Co_quan] NVARCHAR(160) NULL,
    [Dia_chi] NVARCHAR(MAX) NULL,
    [Dia_chi_thuong_tru] NVARCHAR(2540) NULL,
    [So_dien_thoai] NVARCHAR(14) NULL,
    [Khoa_hoc] NVARCHAR(50) NULL,
    [Loai] BIT NOT NULL CONSTRAINT [DF_Ban_doc_Loai] DEFAULT ((1)),
    [Anh] NVARCHAR(50) NULL,
    [Ngay_cap] DATETIME NOT NULL,
    [Ngay_het_han] DATETIME NULL,
    [Email] NVARCHAR(50) NULL,
    [Nhom_ID] INT NULL,
    [Khoa] NVARCHAR(255) NULL,
    [Mat_khau] NVARCHAR(50) NULL,
    [Nhom_nghanh_nghe_ID] INT NULL,
    [Gioi_tinh] BIT NOT NULL CONSTRAINT [DF_ban_doc_Gioi_tinh] DEFAULT ((1)),
    [Linh_vuc_quan_tam_BBK] NVARCHAR(1000) NULL,
    [Linh_vuc_quan_tam_DDC] NVARCHAR(1000) NULL,
    [Status] INT NULL CONSTRAINT [DF_Ban_doc_Status] DEFAULT ((1)),
    [Check_Mail] BIT NULL CONSTRAINT [DF_Ban_doc_Check_Mail] DEFAULT ((0)),
    [Gia_tri] NTEXT NULL,
    [Ghi_chu] VARCHAR(100) NULL,
    [Lop] NVARCHAR(50) NULL,
    [Nam_sinh] INT NULL,
    [chuc_vu] NVARCHAR(50) NULL,
    [noi_cong_tac] NVARCHAR(50) NULL,
    [Giao_trinh] INT NULL,
    [New] BIT NULL CONSTRAINT [DF_Ban_doc_New] DEFAULT ((0)),
    [muon_tu] INT NULL CONSTRAINT [DF_Ban_doc_muon_tu] DEFAULT ((0)),
    [ID_class] INT NULL,
    [ID_Faculty] INT NULL,
    [ID_Khoa_hoc] INT NULL,
    [ID_Phong_ban] INT NULL,
    [Gia_tri_download] NVARCHAR(50) NULL,
    [EDateStart] DATETIME NULL,
    [EDateEnd] DATETIME NULL,
    [Xem] INT NULL,
    [Download] INT NULL,
    CONSTRAINT [PK_Ban_doc] PRIMARY KEY CLUSTERED ([ID]),
    CONSTRAINT [FK_Ban_doc_Nhom_ban_doc] FOREIGN KEY ([Nhom_ID]) REFERENCES [dbo].[Nhom_ban_doc] ([Nhom_ID]),
    CONSTRAINT [FK_Ban_doc_Nhom_nghanh_nghe] FOREIGN KEY ([Nhom_nghanh_nghe_ID]) REFERENCES [dbo].[Nhom_nghanh_nghe] ([ID])
);


------N Bảng [Ma_xep_gia]------
CREATE TABLE [dbo].[Ma_xep_gia] (
    [Tai_lieu_ID] INT NOT NULL,
    [Ten_thu_vien_ID] INT NOT NULL,
    [Ma_xep_gia] VARCHAR(32) NOT NULL,
    [Kho_ID] INT NULL,
    [Gia] VARCHAR(10) NULL,
    [Ngay_bo_sung] DATETIME NULL,
    [ID] INT IDENTITY(1,1) NOT NULL,
    [Cho_nhap_kho] BIT NOT NULL,
    [InUsed] BIT NOT NULL,
    [Tap] VARCHAR(32) NULL,
    [ILLID] INT NULL,
    [Gia_tien] MONEY NULL,
    [InCirculation] BIT NULL,
    [LoanTypeID] SMALLINT NULL,
    [UseCount] INT NOT NULL CONSTRAINT [DF_Ma_xep_gia_UseCount_1] DEFAULT (0),
    [DateLastUsed] DATETIME NULL,
    [Note] VARCHAR(100) NULL,
    [Kiem_ke] BIT NULL,
    [Nguon_Nhap] NVARCHAR(100) NULL,
    [Callnumber] NVARCHAR(32) NULL,
    [So_HD] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Ma_xep_gia] PRIMARY KEY CLUSTERED ([ID])
);

------N Bảng [Tai_lieu]------
CREATE TABLE [dbo].[Tai_lieu] (
    [Tai_lieu_ID] INT NOT NULL,
    [Ma_tai_lieu] VARCHAR(20) NOT NULL,
    [Nguoi_nhap_tin] VARCHAR(40) NULL,
    [Nguoi_kiem_tra] VARCHAR(40) NULL,
    [Nguoi_xu_ly] VARCHAR(40) NULL,
    [Nuoc_cung_cap_ID] INT NULL,
    [Co_quan_cung_cap_ID] INT NULL,
    [Ngay_giao_dich] SMALLDATETIME NOT NULL,
    [Cap_mo_ta_thu_muc] CHAR(1) NOT NULL,
    [Muc_do_mat] CHAR(1) NOT NULL,
    [Vat_mang_tin_ID] INT NOT NULL,
    [Dang_tai_lieu_ID] INT NOT NULL,
    [ID_lop_tren] INT NULL,
    [Kieu_ban_ghi] CHAR(1) NOT NULL,
    [Form_ID] INT NOT NULL,
    [Leader] VARCHAR(25) NOT NULL,
    [Anh_bia] VARCHAR(64) NULL,
    [Ban_ghi_moi] BIT NOT NULL CONSTRAINT [DF_Tai_lieu_Ban_ghi_moi] DEFAULT (1),
    [OPAC] BIT NOT NULL CONSTRAINT [DF_Tai_lieu_OPAC] DEFAULT (1),
    [Bieu_ghi_nhap_hoi_co] BIT NOT NULL CONSTRAINT [DF_Tai_lieu_Bieu_ghi_nhap_hoi_co] DEFAULT (0),
    [CallNumber] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Tai_lieu] PRIMARY KEY NONCLUSTERED ([Tai_lieu_ID]),
    CONSTRAINT [FK_Tai_lieu_Dang_tai_lieu] FOREIGN KEY ([Dang_tai_lieu_ID]) REFERENCES [dbo].[Dang_tai_lieu] ([Dang_tai_lieu_ID]),
    CONSTRAINT [FK_Tai_lieu_Ten_Form] FOREIGN KEY ([Form_ID]) REFERENCES [dbo].[Ten_Form] ([ID]),
    CONSTRAINT [FK_Tai_lieu_Ten_nuoc] FOREIGN KEY ([Nuoc_cung_cap_ID]) REFERENCES [dbo].[Ten_nuoc] ([Ma_nuoc_ID]),
    CONSTRAINT [FK_Tai_lieu_Vat_mang_tin] FOREIGN KEY ([Vat_mang_tin_ID]) REFERENCES [dbo].[Vat_mang_tin] ([Vat_mang_tin_ID])
);


------N Bảng [An_pham_cho_muon]------
CREATE TABLE [dbo].[An_pham_cho_muon] (
    [Tai_lieu_ID] INT NOT NULL,
    [Ma_xep_gia] NVARCHAR(16) NULL,
    [Ngay_muon] DATETIME NOT NULL,
    [Ngay_tra] DATETIME NULL,
    [So_the_ID] INT NOT NULL,
    [So_luot_gia_han] SMALLINT NOT NULL CONSTRAINT [DF_An_pham_cho_muon_So_luot_gia_han] DEFAULT (0),
    [LoanType] TINYINT NOT NULL CONSTRAINT [DF_An_pham_cho_muon_LoanType] DEFAULT (1),
    [Note] VARCHAR(128) NULL,
    [ID] INT NOT NULL,
    [CirID] TINYINT NULL,
    CONSTRAINT [PK_An_pham_cho_muon] PRIMARY KEY CLUSTERED ([ID]),
    CONSTRAINT [FK_An_pham_cho_muon_Ban_doc] FOREIGN KEY ([So_the_ID]) REFERENCES [dbo].[Ban_doc] ([ID]),
    CONSTRAINT [FK_An_pham_cho_muon_Tai_lieu] FOREIGN KEY ([Tai_lieu_ID]) REFERENCES [dbo].[Tai_lieu] ([Tai_lieu_ID])
);

------N Bảng [Lich_su_muon_sach]------
CREATE TABLE [dbo].[Lich_su_muon_sach] (
    [Tai_lieu_ID] INT NOT NULL,
    [Ma_xep_gia] NVARCHAR(16) NOT NULL,
    [So_the_ID] INT NULL,
    [Ngay_muon] SMALLDATETIME NOT NULL,
    [Ngay_tra] SMALLDATETIME NOT NULL,
    [So_ngay_qua_han] INT NULL CONSTRAINT [DF_Lich_su_muon_sach_So_ngay_qua_han] DEFAULT (0),
    [Tien_phat] MONEY NULL CONSTRAINT [DF_Lich_su_muon_sach_Tien_phat] DEFAULT (0),
    [ID] INT IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_Lich_su_muon_sach] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Lich_su_muon_sach_Ban_doc] FOREIGN KEY ([So_the_ID]) REFERENCES [dbo].[Ban_doc] ([ID]),
    CONSTRAINT [FK_Lich_su_muon_sach_Tai_lieu] FOREIGN KEY ([Tai_lieu_ID]) REFERENCES [dbo].[Tai_lieu] ([Tai_lieu_ID])
);

