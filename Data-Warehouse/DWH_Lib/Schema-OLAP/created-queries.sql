------------Tạo scheme để dễ dàng quản lý
------------Những bảng trong schema này chỉ để lưu trữ
CREATE SCHEMA olap;

CREATE TABLE olap.DIM_Date (
    Date_key int, -- Khóa chính
    Full_date date, -- Ngày đầy đủ
    Date_text varchar(50), -- Ngày dạng chuỗi
    Day tinyint, -- Ngày trong tháng
    Week_of_quarter tinyint, -- Tuần trong quý
    Month tinyint, -- Tháng
    Quarter tinyint, -- Quý
    Year smallint, -- Năm
    Day_of_week tinyint, -- Ngày trong tuần
    Day_name varchar(50), -- Tên ngày
    CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED (Date_key) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Nien_khoa
CREATE TABLE olap.DIM_Nien_khoa (
    ID_nien_khoa int NOT NULL, -- Mã niên khóa, khóa chính
    Ten_nien_khoa nvarchar(128) NOT NULL, -- Tên niên khóa
    CONSTRAINT [PK_NienKhoa] PRIMARY KEY CLUSTERED (ID_nien_khoa) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Dan_toc
CREATE TABLE olap.DIM_Dan_toc (
    ID_dan_toc INT NOT NULL, -- Mã dân tộc, khóa chính
    Dan_toc nvarchar(30) NOT NULL, -- Tên dân tộc
    Ten_khac nvarchar(MAX) NULL, -- Tên khác (nếu có)
    CONSTRAINT [PK_Dan_toc] PRIMARY KEY CLUSTERED (ID_dan_toc) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Trinh_do
CREATE TABLE olap.DIM_Trinh_do (
    ID_trinh_do INT NOT NULL, -- Mã trình độ, khóa chính
    Loai_trinh_do nvarchar(50) NOT NULL, -- Loại trình độ

    CONSTRAINT [PK_Trinh_do] PRIMARY KEY CLUSTERED (ID_trinh_do) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Khoa, DIM_Lop
CREATE TABLE olap.DIM_Khoa (
    ID_khoa INT NOT NULL, -- Mã khoa, khóa chính
    Ten_khoa nvarchar(50) NOT NULL, -- Tên khoa
    CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED (ID_khoa) -- Khóa chính dạng clustered
);
CREATE TABLE olap.DIM_Lop (
    ID_lop varchar(20) NOT NULL, -- Mã lớp, khóa chính
    ID_khoa int NOT NULL, -- Mã khoa (FK đến DIM_Khoa)
    CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED (ID_lop), -- Khóa chính dạng clustered
    CONSTRAINT [FK_Lop_Khoa] FOREIGN KEY (ID_khoa) REFERENCES olap.DIM_Khoa(ID_Khoa) -- Khóa ngoại liên kết với DIM_Khoa
);

-- TẠO BẢNG DIM_Nhom_ban_doc
CREATE TABLE olap.DIM_Nhom_ban_doc (
    ID_nhom_ban_doc int NOT NULL, -- Mã nhóm bạn đọc, khóa chính
    Nhom_ban_doc nvarchar(50) NULL, -- Tên nhóm bạn đọc
    CONSTRAINT [PK_Nhom_ban_doc] PRIMARY KEY CLUSTERED (ID_nhom_ban_doc) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Nhom_nghanh_nghe
CREATE TABLE olap.DIM_Nhom_nghanh_nghe (
    ID_nhom_nghanh_nghe int NOT NULL, -- Mã nhóm ngành nghề, khóa chính
    Nhom_nghanh_nghe nvarchar(50) NULL, -- Tên nhóm ngành nghề
    CONSTRAINT [PK_Nhom_nghanh_nghe] PRIMARY KEY CLUSTERED (ID_nhom_nghanh_nghe) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Ban_doc
CREATE TABLE olap.DIM_Ban_doc (
    ID_ban_doc nvarchar(100) NOT NULL, -- Mã bạn đọc, khóa chính
    Ho_ten nvarchar(100) NOT NULL, -- Họ và tên
    Ngay_sinh int NULL, -- Ngày sinh (FK đến DIM_Date)
    ID_dan_toc int, -- FK đến dân tộc
    ID_trinh_do int, -- FK đến trình độ
    ID_nien_khoa int, -- FK đến niên khóa
    So_dien_thoai nvarchar(14), -- Số điện thoại
    Nghe_nghiep nvarchar(140), -- Nghề nghiệp
    Co_quan nvarchar(140), -- Cơ quan
    Chuc_vu nvarchar(140), -- Chức vụ
    Dia_chi_tam_tru nvarchar(MAX), -- Địa chỉ tạm trú
    Dia_chi_thuong_tru nvarchar(MAX), -- Địa chỉ thường trú
    ID_lop varchar(20), -- FK đến lớp
    Anh varchar(50), -- Ảnh bạn đọc
    Ngay_cap int, -- Ngày cấp thẻ (FK đến DIM_Date)
    Ngay_het_han int, -- Ngày hết hạn thẻ (FK đến DIM_Date)
    Email varchar(50), -- Email
    ID_nhom_ban_doc int, -- FK đến nhóm bạn đọc
    ID_nhom_nghanh_nghe int, -- FK đến nhóm ngành nghề
    Gioi_tinh bit, -- Giới tính
    Tinh_trang int, -- Tình trạng
    Ghi_chu nvarchar(MAXMAX), -- Ghi chú
    Mat_khau varchar(50), -- Mật khẩu
    -- Khóa chính clustered
    CONSTRAINT [PK_Ban_doc] PRIMARY KEY CLUSTERED (ID_ban_doc), -- Khóa chính clustered
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Ban_doc_Ngay_sinh] FOREIGN KEY (Ngay_sinh) REFERENCES olap.DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Dan_toc] FOREIGN KEY (ID_dan_toc) REFERENCES olap.DIM_Dan_toc(ID_dan_toc),
    CONSTRAINT [FK_Ban_doc_Trinh_do] FOREIGN KEY (ID_trinh_do) REFERENCES olap.DIM_Trinh_do(ID_trinh_do),
    CONSTRAINT [FK_Ban_doc_Nien_khoa] FOREIGN KEY (ID_nien_khoa) REFERENCES olap.DIM_Nien_khoa(ID_nien_khoa),
    CONSTRAINT [FK_Ban_doc_Lop] FOREIGN KEY (ID_lop) REFERENCES olap.DIM_Lop(ID_lop),
    CONSTRAINT [FK_Ban_doc_Ngay_cap] FOREIGN KEY (Ngay_cap) REFERENCES olap.DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Ngay_het_han] FOREIGN KEY (Ngay_het_han) REFERENCES olap.DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Nhom_ban_doc] FOREIGN KEY (ID_nhom_ban_doc) REFERENCES olap.DIM_Nhom_ban_doc(ID_nhom_ban_doc),
    CONSTRAINT [FK_Ban_doc_Nhom_nghanh_nghe] FOREIGN KEY (ID_nhom_nghanh_nghe) REFERENCES olap.DIM_Nhom_nghanh_nghe(ID_nhom_nghanh_nghe)
);

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TẠO BẢNG DIM_Ten_form
CREATE TABLE olap.DIM_Ten_form (
    ID_form int NOT NULL, -- Mã form, khóa chính
    Ten_form nvarchar(128) NULL, -- Tên form
    Nguoi_tao nvarchar(60) NULL, -- Người tạo form
    Ngay_tao int NULL, -- Ngày tạo form
    Ngay_sua_cuoi int NULL, -- Ngày sửa cuối cùng
    CONSTRAINT [PK_Ten_form] PRIMARY KEY CLUSTERED (ID_form), -- Khóa chính dạng clustered
    CONSTRAINT [FK_Ten_form_Ngay_tao] FOREIGN KEY (Ngay_tao) REFERENCES olap.DIM_Date(Date_key), -- FK đến DIM_Date
    CONSTRAINT [FK_Ten_form_Ngay_sua_cuoi] FOREIGN KEY (Ngay_sua_cuoi) REFERENCES olap.DIM_Date(Date_key) -- FK đến DIM_Date
);

-- TẠO BẢNG DIM_Quoc_gia
CREATE TABLE olap.DIM_Quoc_gia (
    ID_quoc_gia int NOT NULL, -- Mã quốc gia, khóa chính
    Ma_ISO varchar(2) NULL, -- Mã ISO quốc gia
    Ten_nuoc_ISO nvarchar(30) NULL, -- Tên quốc gia theo mã ISO
    CONSTRAINT [PK_Quoc_gia] PRIMARY KEY CLUSTERED (ID_quoc_gia) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Vat_mang_tin
CREATE TABLE olap.DIM_Vat_mang_tin (
    ID_vat_mang_tin int NOT NULL, -- Mã vật mang tin, khóa chính
    Ky_hieu nvarchar(6) NULL, -- Ký hiệu vật mang tin
    Vat_mang_tin nvarchar(32) NULL, -- Tên vật mang tin
    CONSTRAINT [PK_Vat_mang_tin] PRIMARY KEY CLUSTERED (ID_vat_mang_tin) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Dang_tai_lieu
CREATE TABLE olap.DIM_Dang_tai_lieu (
    ID_dang_tai_lieu int NOT NULL, -- Mã dạng tài liệu, khóa chính
    Dang_tai_lieu nvarchar(164) NULL, -- Tên dạng tài liệu
    Ky_hieu_tai_lieu varchar(6) NULL, -- Ký hiệu tài liệu
    LoanPeriod smallint NULL, -- Thời gian mượn
    Renewals tinyint NULL, -- Số lần gia hạn
    RenewalPeriod tinyint NULL, -- Thời gian gia hạn
    TimeUnit tinyint NULL, -- Đơn vị thời gian
    Fee money NULL, -- Phí mượn
    OverdueFine money NULL, -- Phí quá hạn
    FixedFee bit NULL, -- Phí cố định
    CONSTRAINT [PK_Dang_tai_lieu] PRIMARY KEY CLUSTERED (ID_dang_tai_lieu) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Mon DIM_CTDT, DIM_CTDT, DIM_Mon_CTDT
CREATE TABLE olap.DIM_Mon (
    ID_mon int NOT NULL, -- Mã môn học, khóa chính
    Ten_mon nvarchar(max) NOT NULL, -- Tên môn học
    Ky_hieu nvarchar(50) NULL, -- Ký hiệu môn học
    CONSTRAINT [PK_Mon] PRIMARY KEY CLUSTERED (ID_mon) -- Khóa chính dạng clustered
);
CREATE TABLE olap.DIM_CTDT (
    ID_ctdt int NOT NULL, -- Mã chương trình đào tạo, khóa chính
    Ten_chuong_trinh_dao_tao nvarchar(128) NOT NULL, -- Tên chương trình đào tạo
    NamBH int NULL, -- Năm bắt đầu chương trình đào tạo
    ID_khoa int NULL, -- Mã khoa (FK đến DIM_Khoa)
    CONSTRAINT [PK_CTDT] PRIMARY KEY CLUSTERED (ID_ctdt), -- Khóa chính dạng clustered
    CONSTRAINT [FK_CTDT_Khoa] FOREIGN KEY (ID_khoa) REFERENCES olap.DIM_Khoa(ID_khoa), -- FK đến DIM_Date
);
CREATE TABLE olap.DIM_Mon_CTDT (
    ID_mon INT, -- Khóa chính, mã định danh môn học
    ID_ctdt int, -- Khóa chính, mã định danh chương trình đào tạo
    CONSTRAINT [PK_Mon_CTDT] PRIMARY KEY CLUSTERED (ID_mon, ID_ctdt), -- Khóa chính dạng clustered
    CONSTRAINT [FK_CTDT_Mon] FOREIGN KEY (ID_mon) REFERENCES olap.DIM_Mon(ID_mon), -- FK đến DIM_Mon
    CONSTRAINT [FK_CTDT_CTDT] FOREIGN KEY (ID_ctdt) REFERENCES olap.DIM_CTDT(ID_ctdt) -- FK đến DIM_CTDT
);

-- TẠO BẢNG DIM_Tai_lieu
CREATE TABLE olap.DIM_Tai_lieu (
    ID_tai_lieu int NOT NULL, -- Mã tài liệu, khóa chính
    Ma_tai_lieu nvarchar(20) NOT NULL, -- Mã tài liệu
    Ten_tai_lieu nvarchar(20) NULL,
    Nguoi_nhap_tin nvarchar(40) NULL, -- Người nhập tin
    Nguoi_kiem_tra nvarchar(40) NULL, -- Người kiểm tra
    ID_mon int NOT NULL, -- Mã môn học (FK đến DIM_Mon)
    ID_quoc_gia int NULL, -- Mã quốc gia (FK đến DIM_Quoc_gia)
    ID_co_quan_cung_cap int NULL, -- Mã cơ quan cung cấp
    Ngay_giao_dich int NOT NULL, -- Ngày giao dịch (FK đến DIM_Date)
    Cap_mo_ta_thu_muc varchar(1) NOT NULL, -- Cấp mô tả thư mục
    Muc_do_mat varchar(1) NOT NULL, -- Mức độ mật
    ID_vat_mang_tin int NOT NULL, -- Mã vật mang tin (FK đến DIM_Vat_mang_tin)
    ID_dang_tai_lieu int NOT NULL, -- Mã dạng tài liệu (FK đến DIM_Dang_tai_lieu)
    Kieu_ban_ghi varchar(1) NULL, -- Kiểu bản ghi
    ID_form int NOT NULL, -- Mã form (FK đến DIM_Ten_form)
    Leader varchar(25) NOT NULL, -- Người lãnh đạo
    Anh_bia varchar(64) NULL, -- Ảnh bìa
    CallNumber nvarchar(50) NULL, -- Số gọi
    -- Khóa chính dạng non-clustered
    CONSTRAINT [PK_Tai_lieu] PRIMARY KEY NONCLUSTERED (ID_tai_lieu), 
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Tai_lieu_Dang_tai_lieu] FOREIGN KEY([ID_dang_tai_lieu]) REFERENCES [olap].[DIM_Dang_tai_lieu]([ID_dang_tai_lieu]),
    CONSTRAINT [FK_Tai_lieu_Mon] FOREIGN KEY([ID_mon]) REFERENCES [olap].[DIM_Mon]([ID_mon]),
    CONSTRAINT [FK_Tai_lieu_Ngay_giao_dich] FOREIGN KEY([Ngay_giao_dich]) REFERENCES [olap].[DIM_Date]([Date_key]),
    CONSTRAINT [FK_Tai_lieu_Quoc_gia] FOREIGN KEY([ID_quoc_gia]) REFERENCES [olap].[DIM_Quoc_gia]([ID_quoc_gia]),
    CONSTRAINT [FK_Tai_lieu_Ten_Form] FOREIGN KEY([ID_form]) REFERENCES [olap].[DIM_Ten_form]([ID_form]),
    CONSTRAINT [FK_Tai_lieu_Vat_mang_tin] FOREIGN KEY([ID_vat_mang_tin]) REFERENCES [olap].[DIM_Vat_mang_tin]([ID_vat_mang_tin])
);


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TẠO BẢNG DIM_Thu_vien
CREATE TABLE olap.DIM_Thu_vien (
    ID_thu_vien nvarchar(32) NOT NULL, -- Mã thư viện, khóa chính
    Thu_vien nvarchar(80) NULL, -- Tên thư viện
    Dia_chi nvarchar(max) NULL, -- Địa chỉ thư viện
    Gia_tri varchar(80) NULL, -- Giá trị thư viện
    LocalLib bit NULL, -- Thư viện cục bộ
    CONSTRAINT [PK_Thu_vien] PRIMARY KEY CLUSTERED (ID_thu_vien) -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Kho
CREATE TABLE olap.DIM_Kho (
    ID_kho int NOT NULL, -- Mã kho, khóa chính
    Kho nvarchar(80) NULL, -- Tên kho
    MaxID int NULL, -- Mã tối đa
    Mo bit NULL, -- Trạng thái kho (mở/đóng)
    CONSTRAINT [PK_Kho] PRIMARY KEY CLUSTERED (ID_kho), -- Khóa chính dạng clustered
);

-- TẠO BẢNG DIM_Xep_gia
CREATE TABLE olap.DIM_Xep_gia (
    ID_xep_gia int NOT NULL, -- Mã xếp giá, khóa chính
    ID_tai_lieu int NOT NULL, -- Mã tài liệu (FK đến DIM_Tai_lieu)
    Ma_xep_gia nvarchar(32) NOT NULL, -- Mã xếp giá
    ID_thu_vien nvarchar(32) NOT NULL, -- Mã thư viện (FK đến DIM_Thu_vien)
    ID_kho int NOT NULL, -- Mã kho (FK đến DIM_Kho)
    Ngay_bo_sung int NOT NULL, -- Ngày bổ sung (FK đến DIM_Date)
    Cho_nhap_kho bit NOT NULL, -- Cho phép nhập kho
    InUsed bit NOT NULL, -- Đang sử dụng
    Gia_tien money NULL, -- Giá tiền
    InCirculation bit NULL, -- Đang lưu hành
    Kiem_ke bit NULL, -- Kiểm kê
    Nguon_Nhap nvarchar(100) NULL, -- Nguồn nhập
    Callnumber nvarchar(50) NULL, -- Số gọi
    So_HD nvarchar(50) NULL, -- Số hợp đồng
    -- Khóa chính dạng clustered
    CONSTRAINT [PK_Ma_xep_gia] PRIMARY KEY CLUSTERED (ID_xep_gia), 
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Ma_xep_gia_Kho] FOREIGN KEY([ID_kho]) REFERENCES [olap].[DIM_Kho]([ID_kho]),
    CONSTRAINT [FK_Ma_xep_gia_Tai_lieu] FOREIGN KEY([ID_tai_lieu]) REFERENCES [olap].[DIM_Tai_lieu]([ID_tai_lieu]),
    CONSTRAINT [FK_Ma_xep_gia_Thu_vien] FOREIGN KEY([ID_thu_vien]) REFERENCES [olap].[DIM_Thu_vien]([ID_thu_vien]),
    CONSTRAINT [FK_Ma_xep_Ngay_bo_sung] FOREIGN KEY([Ngay_bo_sung]) REFERENCES [olap].[DIM_Date]([Date_key])
);



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE TABLE olap.FACT_Muon (
    ID_ban_doc nvarchar(100) NOT NULL, -- Mã lớp (FK đến DIM_Lop)
    ID_tai_lieu int NOT NULL, -- Mã khoa (FK đến DIM_Khoa)
    Ma_xep_gia int NOT NULL, -- Mã ngày (FK đến DIM_Date)
    ID_date int NOT NULL, -- Mã ngày (FK đến DIM_Date)
    So_luot_muon int NULL, -- Số lượng sinh viên
    CONSTRAINT [PK_Thong_ke_sinh_vien] PRIMARY KEY CLUSTERED (
        [ID_ban_doc] ASC,
        [ID_tai_lieu] ASC,
        [Ma_xep_gia] ASC,
        [ID_date] ASC
    ), -- Khóa chính dạng clustered
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Muon_BanDoc] FOREIGN KEY([ID_ban_doc]) REFERENCES olap.DIM_Ban_doc([ID_ban_doc]),
    CONSTRAINT [FK_Muon_TaiLieu] FOREIGN KEY([ID_tai_lieu]) REFERENCES olap.DIM_Tai_lieu([ID_tai_lieu]),
    CONSTRAINT [FK_Muon_Date] FOREIGN KEY([ID_date]) REFERENCES olap.DIM_Date([Date_key]),
);

-- TẠO BẢNG FACT_Thu_vien
CREATE TABLE olap.FACT_Thu_vien (
    ID_ban_doc nvarchar(100) NOT NULL, -- Mã thư viện (FK đến DIM_Thu_vien)
    ID_xep_gia int NOT NULL, -- Mã nhóm bạn đọc (FK đến DIM_Nhom_ban_doc)
    ID_date int NOT NULL, -- Mã ngày (FK đến DIM_Date)
    So_luot_dung int NULL, -- Số người dùng
    CONSTRAINT [PK_FACT_Thu_vien] PRIMARY KEY CLUSTERED (
        [ID_ban_doc] ASC,
        [ID_xep_gia] ASC,
        [ID_date] ASC
    ), -- Khóa chính dạng clustered
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_Thuvien_BanDoc] FOREIGN KEY([ID_ban_doc]) REFERENCES olap.DIM_Ban_doc([ID_ban_doc]),
    CONSTRAINT [FK_Thuvien_XepGia] FOREIGN KEY([ID_xep_gia]) REFERENCES olap.DIM_Xep_gia([ID_xep_gia]),
    CONSTRAINT [FK_Thuvien_Date] FOREIGN KEY([ID_date]) REFERENCES olap.DIM_Date([Date_key])
);

-- TẠO BẢNG FACT_Thong_ke_tai_lieu
CREATE TABLE olap.FACT_Tai_lieu (
    ID_tai_lieu int NOT NULL, -- Mã tài liệu (FK đến DIM_Tai_lieu)
    Ma_xep_gia nvarchar(32) NOT NULL, -- Mã xếp giá
    ID_date int NOT NULL, -- Mã ngày (FK đến DIM_Date)
    So_ban_sach int NULL, -- Số bản sách
    CONSTRAINT [PK_FACT_Thong_ke_tai_lieu] PRIMARY KEY CLUSTERED (
        [ID_tai_lieu] ASC,
        [Ma_xep_gia] ASC,
        [ID_date] ASC
    ), -- Khóa chính dạng clustered
    -- Các ràng buộc khóa ngoại
    CONSTRAINT [FK_TKTaiLieu_Tailieu] FOREIGN KEY([ID_tai_lieu]) REFERENCES olap.DIM_Tai_lieu([ID_tai_lieu]),
    CONSTRAINT [FK_TKTaiLieu_Date] FOREIGN KEY([ID_date]) REFERENCES olap.DIM_Date([Date_key])
);