------N Bảng [Date] ------
CREATE TABLE DIM_Date (
    Date_key int,
    Full_date date,
    Date_text varchar(50),
    Day tinyint,
    Week_of_quarter tinyint,
    Month tinyint,
    Quarter tinyint, 
    Year smallint,
    Day_of_week tinyint,
    Day_name varchar(50),
    CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED (Date_key)
);
------N Bảng [Khoa] ------
CREATE TABLE DIM_Khoa (
	ID_khoa varchar(20) NOT NULL,
    Ten_khoa nvarchar(50) NOT NULL,
    CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED (ID_khoa)
);

------N Bảng [Dan_toc] ------
CREATE TABLE DIM_Dan_toc (
	ID_dan_toc int  NOT NULL,
    Dan_toc nvarchar(30)  NOT NULL,
    CONSTRAINT [PK_Dan_toc] PRIMARY KEY (ID_dan_toc)
);

------N Bảng [Trinh_do] ------
CREATE TABLE DIM_Trinh_do (
    ID_trinh_do int NOT NULL,
    Loai_trinh_do nvarchar(50) NOT NULL,
	CONSTRAINT [PK_Trinh_do] PRIMARY KEY CLUSTERED (ID_trinh_do)
);

------N Bảng [Khoa_hoc] ------
CREATE TABLE DIM_Khoa_hoc (
    ID_khoa_hoc varchar(20) NOT NULL,
    Ten_khoa_hoc nvarchar(50) NOT NULL,
    CONSTRAINT [PK_Khoa_hoc] PRIMARY KEY CLUSTERED (ID_khoa_hoc)
);

------N Bảng [Lop]------
CREATE TABLE DIM_Lop (
    ID_lop varchar(20) NOT NULL,
    Ten_lop nvarchar(50) NOT NULL,
	ID_khoa varchar(20) NOT NULL,
	CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED (ID_lop),
	CONSTRAINT [FK_Lop_Khoa] FOREIGN KEY (ID_khoa) REFERENCES DIM_Khoa(ID_Khoa)
);

------N Bảng DIM_Nhom_ban_doc------
CREATE TABLE DIM_Nhom_ban_doc ( 
	ID_nhom_ban_doc int NOT NULL,
	Nhom_ban_doc nvarchar(50),
	CONSTRAINT [PK_Nhom_ban_doc] PRIMARY KEY CLUSTERED (ID_nhom_ban_doc)
);

------N Bảng DIM_Nhom_nghanh_nghe------
CREATE TABLE DIM_Nhom_nghanh_nghe ( 
	ID_nhom_nghanh_nghe int NOT NULL,
	Nhom_ban_doc nvarchar(50),
	CONSTRAINT [PK_Nhom_nghanh_nghe] PRIMARY KEY CLUSTERED (ID_nhom_nghanh_nghe)
);

------N Bảng DIM_Quoc_gia------
CREATE TABLE DIM_Quoc_gia ( 
	ID_quoc_gia int NOT NULL,
	Ma_ISO varchar(2),
	Ten_nuoc_ISO varchar(30),
	CONSTRAINT [PK_Quoc_gia] PRIMARY KEY CLUSTERED (ID_quoc_gia)
);

------N Bảng DIM_Vat_mang_tin------
CREATE TABLE DIM_Vat_mang_tin ( 
	ID_vat_mang_tin int NOT NULL,
	Ky_hieu nvarchar(6),
	Vat_mang_tin nvarchar(32),
	CONSTRAINT [PK_Vat_mang_tin] PRIMARY KEY CLUSTERED (ID_vat_mang_tin)
);

------N Bảng DIM_Dang_tai_lieu------
CREATE TABLE DIM_Dang_tai_lieu ( 
	ID_dang_tai_lieu int NOT NULL,
	Dang_tai_lieu nvarchar(164),
	Ky_hieu_tai_lieu varchar(6),
	LoanPeriod smallint,
	Renewals tinyint,
	RenewalPeriod tinyint,
	TimeUnit tinyint,
	Fee money,
	OverdueFine money,
	FixedFee bit,
	CONSTRAINT [PK_Dang_tai_lieu] PRIMARY KEY CLUSTERED (ID_dang_tai_lieu)
);

------N Bảng DIM_Ten_form------
CREATE TABLE DIM_Ten_form ( 
	ID_form int NOT NULL,
	Ten_form varchar(128),
	Nguoi_tao varchar(60),
	Ngay_tao int,
	Ngay_sua_cuoi int,
	CONSTRAINT [PK_Ten_form] PRIMARY KEY CLUSTERED (ID_form),
	CONSTRAINT [FK_Ten_form_Ngay_tao] FOREIGN KEY (Ngay_tao) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Ten_form_Ngay_sua_cuoi] FOREIGN KEY (Ngay_sua_cuoi) REFERENCES DIM_Date(Date_key)
);

------N Bảng DIM_Thu_vien------
CREATE TABLE DIM_Thu_vien ( 
	ID_thu_vien varchar(32) NOT NULL,
	Thu_vien varchar(80),
	Dia_chi nvarchar(MAX),
	Gia_tri varchar(80),
	LocalLib bit,
	CONSTRAINT [PK_Thu_vien] PRIMARY KEY CLUSTERED (ID_thu_vien)
);
------N Bảng DIM_Kho------
CREATE TABLE DIM_Kho ( 
	ID_kho int NOT NULL,
	Kho varchar(80),
	ID_thu_vien varchar(32),
	MaxID INT,
	Mo bit,
	CONSTRAINT [PK_Kho] PRIMARY KEY CLUSTERED (ID_kho),
	CONSTRAINT [FK_Kho_Thu_vien] FOREIGN KEY (ID_thu_vien) REFERENCES DIM_Thu_vien(ID_thu_vien)
);

CREATE TABLE DIM_Ban_doc (
    ID_ban_doc int NOT NULL,
    Ho_ten nvarchar(100) NOT NULL,
    Ngay_sinh int NULL,
    ID_dan_toc int,
    ID_trinh_do int,
	So_dien_thoai nvarchar(14),
	Nghe_nghiep nvarchar(140),
    Co_quan nvarchar(140),
	Chuc_vu nvarchar(140),
	Dia_chi_tam_tru nvarchar(MAX),
	Dia_chi_thuong_tru nvarchar(MAX),
    ID_khoa_hoc varchar(20),
	ID_lop varchar(20),
    Anh varchar(50),
    Ngay_cap int,
    Ngay_het_han int,
    Email varchar(50),
	ID_nhom_ban_doc int,
	ID_nhom_nghanh_nghe int,
	Gioi_tinh bit,
	Tinh_trang int,
	Ghi_chu ntext,
	Mat_khau varchar(50),
    CONSTRAINT [PK_Ban_doc] PRIMARY KEY CLUSTERED (ID_ban_doc),
	CONSTRAINT [FK_Ban_doc_Ngay_sinh] FOREIGN KEY (Ngay_sinh) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Ban_doc_Dan_toc] FOREIGN KEY (ID_dan_toc) REFERENCES DIM_Dan_toc(ID_dan_toc),
	CONSTRAINT [FK_Ban_doc_Trinh_do] FOREIGN KEY (ID_trinh_do) REFERENCES DIM_Trinh_do(ID_trinh_do),
	CONSTRAINT [FK_Ban_doc_Khoa_hoc] FOREIGN KEY (ID_khoa_hoc) REFERENCES DIM_Khoa_hoc(ID_khoa_hoc),
	CONSTRAINT [FK_Ban_doc_Lop] FOREIGN KEY (ID_lop) REFERENCES DIM_Lop(ID_lop),
	CONSTRAINT [FK_Ban_doc_Ngay_cap] FOREIGN KEY (Ngay_cap) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Ban_doc_Ngay_het_han] FOREIGN KEY (Ngay_het_han) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Ban_doc_Nhom_ban_doc] FOREIGN KEY (ID_nhom_ban_doc) REFERENCES DIM_Nhom_ban_doc(ID_nhom_ban_doc),
    CONSTRAINT [FK_Ban_doc_Nhom_nghanh_nghe] FOREIGN KEY (ID_nhom_nghanh_nghe) REFERENCES DIM_Nhom_nghanh_nghe(ID_nhom_nghanh_nghe)
);

CREATE TABLE DIM_Tai_lieu (
    ID_tai_lieu int NOT NULL,
    Ma_tai_lieu varchar(20) NOT NULL,
    Nguoi_nhap_tin varchar(40),
    Nguoi_kiem_tra varchar(40),
    ID_quoc_gia int,
    ID_co_quan_cung_cap int,
    Ngay_giao_dich int NOT NULL,
    Cap_mo_ta_thu_muc varchar(1) NOT NULL,
    Muc_do_mat varchar(1) NOT NULL,
    ID_vat_mang_tin int NOT NULL,
    ID_dang_tai_lieu int NOT NULL,
    Kieu_ban_ghi varchar(1),
    ID_form int NOT NULL,
    Leader varchar (25) NOT NULL,
    Anh_bia varchar(64),
    Ban_ghi_moi bit NOT NULL CONSTRAINT [DF_Tai_lieu_Ban_ghi_moi] DEFAULT (1),
    OPAC bit NOT NULL CONSTRAINT [DF_Tai_lieu_OPAC] DEFAULT (1),
    Bieu_ghi_nhap_hoi_co bit NOT NULL CONSTRAINT [DF_Tai_lieu_Bieu_ghi_nhap_hoi_co] DEFAULT (0),
    CallNumber NVARCHAR(50),
    CONSTRAINT [PK_Tai_lieu] PRIMARY KEY NONCLUSTERED (ID_tai_lieu),
    CONSTRAINT [FK_Tai_lieu_Ten_nuoc] FOREIGN KEY (ID_quoc_gia) REFERENCES DIM_Quoc_gia(ID_quoc_gia),
	CONSTRAINT [FK_Tai_lieu_Ngay_giao_dich] FOREIGN KEY (Ngay_giao_dich) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Tai_lieu_Vat_mang_tin] FOREIGN KEY (ID_vat_mang_tin) REFERENCES DIM_Vat_mang_tin(ID_vat_mang_tin),
    CONSTRAINT [FK_Tai_lieu_Dang_tai_lieu] FOREIGN KEY (ID_dang_tai_lieu) REFERENCES DIM_Dang_tai_lieu(ID_dang_tai_lieu),
    CONSTRAINT [FK_Tai_lieu_Ten_Form] FOREIGN KEY (ID_form) REFERENCES DIM_Ten_form(ID_form)
);

CREATE TABLE DIM_Ma_xep_gia(
	ID_xep_gia int NOT NULL,
    ID_tai_lieu int NOT NULL,
	Ma_xep_gia varchar (32) NOT NULL,
    ID_thu_vien varchar(32) NOT NULL,
    ID_kho int NOT NULL,
	Gia varchar(10),
    Ngay_bo_sung int NOT NULL,
    Cho_nhap_kho bit NOT NULL,
	InUsed bit NOT NULL,
    Gia_tien money,
    InCirculation bit,
    UseCount int NOT NULL CONSTRAINT [DF_Ma_xep_gia_UseCount_1] DEFAULT (0),
    Kiem_ke bit,
	Nguon_Nhap nvarchar(100),
    So_HD nvarchar(50) NULL,
    CONSTRAINT [PK_Ma_xep_gia] PRIMARY KEY CLUSTERED (ID_xep_gia),
	CONSTRAINT [FK_Ma_xep_gia_Tai_lieu] FOREIGN KEY (ID_tai_lieu) REFERENCES DIM_Tai_lieu(ID_tai_lieu),
	CONSTRAINT [FK_Ma_xep_gia_Thu_vien] FOREIGN KEY (ID_thu_vien) REFERENCES DIM_Thu_vien(ID_thu_vien),
	CONSTRAINT [FK_Ma_xep_gia_Kho] FOREIGN KEY (ID_kho) REFERENCES DIM_Kho(ID_kho),
	CONSTRAINT [FK_Ma_xep_Ngay_bo_sung] FOREIGN KEY (Ngay_bo_sung) REFERENCES DIM_Date(Date_key)
);

CREATE TABLE FACT_Phieu_muon_sach (
    ID_phieu_muon int,
    ID_tai_lieu int NOT NULL,
    ID_xep_gia int NOT NULL,
    ID_ban_doc int NOT NULL,
    Ngay_muon int NOT NULL,
    Ngay_tra int,
    LoanType smallint,
    So_luot_gia_han smallint,
    So_ngay_qua_han int,
    Tien_phat money,
    Ghi_chu nvarchar(max),
	CONSTRAINT [PK_Phieu_muon_sach] PRIMARY KEY CLUSTERED (ID_phieu_muon),
	CONSTRAINT [FK_Phieu_muon_sach_Tai_lieu] FOREIGN KEY (ID_tai_lieu) REFERENCES DIM_Tai_lieu(ID_tai_lieu),
	CONSTRAINT [FK_Phieu_muon_sach_Xep_gia] FOREIGN KEY (ID_xep_gia) REFERENCES DIM_Ma_xep_gia(ID_xep_gia),
	CONSTRAINT [FK_Phieu_muon_sach_Ban_doc] FOREIGN KEY (ID_ban_doc) REFERENCES DIM_Ban_doc(ID_ban_doc),
	CONSTRAINT [FK_Phieu_muon_sach_Ngay_muon] FOREIGN KEY (Ngay_muon) REFERENCES DIM_Date(Date_key),
	CONSTRAINT [FK_Phieu_muon_sach_Ngay_tra] FOREIGN KEY (Ngay_tra) REFERENCES DIM_Date(Date_key)
);


