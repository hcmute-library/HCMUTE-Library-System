------N Bảng [Date] ------
CREATE TABLE DIM_Date (
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
------N Bảng [Khoa] ------
CREATE TABLE DIM_Khoa (
    ID_khoa varchar(20) NOT NULL, -- Mã khoa, khóa chính
    Ten_khoa nvarchar(50) NOT NULL, -- Tên khoa
    CONSTRAINT [PK_Khoa] PRIMARY KEY CLUSTERED (ID_khoa) -- Khóa chính dạng clustered
);
------N Bảng [Dan_toc] ------
CREATE TABLE DIM_Dan_toc (
    ID_dan_toc int NOT NULL, -- Mã dân tộc, khóa chính
    Dan_toc nvarchar(30) NOT NULL, -- Tên dân tộc
    Ten_khac nvarchar(MAX), -- Tên gọi khác
    CONSTRAINT [PK_Dan_toc] PRIMARY KEY (ID_dan_toc) -- Khóa chính
);
------N Bảng [Trinh_do] ------
CREATE TABLE DIM_Trinh_do (
    ID_trinh_do int NOT NULL, -- Mã trình độ, khóa chính
    Loai_trinh_do nvarchar(50) NOT NULL, -- Loại trình độ
    CONSTRAINT [PK_Trinh_do] PRIMARY KEY CLUSTERED (ID_trinh_do) -- Khóa chính dạng clustered
);
------N Bảng [Lop]------
CREATE TABLE DIM_Lop (
    ID_lop varchar(20) NOT NULL, -- Mã lớp, khóa chính
    ID_khoa varchar(20) NOT NULL, -- Mã khoa (liên kết đến bảng Khoa)
    CONSTRAINT [PK_Lop] PRIMARY KEY CLUSTERED (ID_lop), -- Khóa chính dạng clustered
    CONSTRAINT [FK_Lop_Khoa] FOREIGN KEY (ID_khoa) REFERENCES DIM_Khoa(ID_Khoa) -- Khóa ngoại liên kết với DIM_Khoa
);
------N Bảng DIM_Nhom_ban_doc------
CREATE TABLE DIM_Nhom_ban_doc ( 
    ID_nhom_ban_doc int NOT NULL, -- Mã nhóm bạn đọc, khóa chính
    Nhom_ban_doc nvarchar(50), -- Tên nhóm bạn đọc
    CONSTRAINT [PK_Nhom_ban_doc] PRIMARY KEY CLUSTERED (ID_nhom_ban_doc) -- Khóa chính dạng clustered
);
------N Bảng DIM_Nhom_nghanh_nghe------
CREATE TABLE DIM_Nhom_nghanh_nghe ( 
    ID_nhom_nghanh_nghe int NOT NULL, -- Mã nhóm ngành nghề, khóa chính
    Nhom_nghanh_nghe nvarchar(50), -- Tên nhóm ngành nghề
    CONSTRAINT [PK_Nhom_nghanh_nghe] PRIMARY KEY CLUSTERED (ID_nhom_nghanh_nghe) -- Khóa chính dạng clustered
);
------N Bảng DIM_Quoc_gia------
CREATE TABLE DIM_Quoc_gia ( 
    ID_quoc_gia int NOT NULL, -- Mã quốc gia, khóa chính
    Ma_ISO varchar(2), -- Mã ISO quốc gia
    Ten_nuoc_ISO varchar(30), -- Tên nước theo mã ISO
    CONSTRAINT [PK_Quoc_gia] PRIMARY KEY CLUSTERED (ID_quoc_gia) -- Khóa chính dạng clustered
);
------N Bảng DIM_Vat_mang_tin------
CREATE TABLE DIM_Vat_mang_tin ( 
    ID_vat_mang_tin int NOT NULL, -- Mã vật mang tin, khóa chính
    Ky_hieu nvarchar(6), -- Ký hiệu của vật mang tin
    Vat_mang_tin nvarchar(32), -- Tên vật mang tin
    CONSTRAINT [PK_Vat_mang_tin] PRIMARY KEY CLUSTERED (ID_vat_mang_tin) -- Khóa chính dạng clustered
);
------N Bảng DIM_Dang_tai_lieu------
CREATE TABLE DIM_Dang_tai_lieu ( 
    ID_dang_tai_lieu int NOT NULL, -- Mã dạng tài liệu, khóa chính
    Dang_tai_lieu nvarchar(164), -- Tên dạng tài liệu
    Ky_hieu_tai_lieu varchar(6), -- Ký hiệu tài liệu
    LoanPeriod smallint, -- Thời gian mượn
    Renewals tinyint, -- Số lần gia hạn
    RenewalPeriod tinyint, -- Thời gian gia hạn
    TimeUnit tinyint, -- Đơn vị thời gian
    Fee money, -- Phí mượn
    OverdueFine money, -- Phí quá hạn
    FixedFee bit, -- Phí cố định
    CONSTRAINT [PK_Dang_tai_lieu] PRIMARY KEY CLUSTERED (ID_dang_tai_lieu) -- Khóa chính clustered
);
------N Bảng DIM_Ten_form------
CREATE TABLE DIM_Ten_form ( 
    ID_form int NOT NULL, -- Mã form, khóa chính
    Ten_form varchar(128), -- Tên form
    Nguoi_tao varchar(60), -- Người tạo
    Ngay_tao int, -- Ngày tạo (liên kết với DIM_Date)
    Ngay_sua_cuoi int, -- Ngày sửa cuối (liên kết với DIM_Date)
    CONSTRAINT [PK_Ten_form] PRIMARY KEY CLUSTERED (ID_form), -- Khóa chính clustered
    CONSTRAINT [FK_Ten_form_Ngay_tao] FOREIGN KEY (Ngay_tao) REFERENCES DIM_Date(Date_key), -- FK đến DIM_Date
    CONSTRAINT [FK_Ten_form_Ngay_sua_cuoi] FOREIGN KEY (Ngay_sua_cuoi) REFERENCES DIM_Date(Date_key) -- FK đến DIM_Date
);
------N Bảng DIM_Thu_vien------
CREATE TABLE DIM_Thu_vien ( 
    ID_thu_vien nvarchar(32) NOT NULL, -- Mã thư viện, khóa chính
    Thu_vien varchar(80), -- Tên thư viện
    Dia_chi nvarchar(MAX), -- Địa chỉ thư viện
    Gia_tri varchar(80), -- Giá trị
    LocalLib bit, -- Thư viện địa phương
    CONSTRAINT [PK_Thu_vien] PRIMARY KEY CLUSTERED (ID_thu_vien) -- Khóa chính clustered
);
------N Bảng DIM_Kho------
CREATE TABLE DIM_Kho ( 
    ID_kho int NOT NULL, -- Mã kho, khóa chính
    Kho varchar(80), -- Tên kho
    ID_thu_vien varchar(32), -- FK đến thư viện
    MaxID INT, -- ID lớn nhất
    Mo bit, -- Kho mở
    CONSTRAINT [PK_Kho] PRIMARY KEY CLUSTERED (ID_kho), -- Khóa chính clustered
    CONSTRAINT [FK_Kho_Thu_vien] FOREIGN KEY (ID_thu_vien) REFERENCES DIM_Thu_vien(ID_thu_vien) -- FK đến DIM_Thu_vien
);
------N Bảng DIM_Ban_doc------
CREATE TABLE DIM_Ban_doc (
    ID_ban_doc int NOT NULL, -- Mã bạn đọc, khóa chính
    Ho_ten nvarchar(100) NOT NULL, -- Họ và tên
    Ngay_sinh int NULL, -- Ngày sinh (FK đến DIM_Date)
    ID_dan_toc int, -- FK đến dân tộc
    ID_trinh_do int, -- FK đến trình độ
    So_dien_thoai nvarchar(14), -- Số điện thoại
    Nghe_nghiep nvarchar(140), -- Nghề nghiệp
    Co_quan nvarchar(140), -- Cơ quan
    Chuc_vu nvarchar(140), -- Chức vụ
    Dia_chi_tam_tru nvarchar(MAX), -- Địa chỉ tạm trú
    Dia_chi_thuong_tru nvarchar(MAX), -- Địa chỉ thường trú
    ID_khoa_hoc varchar(20), -- FK đến khóa học
    ID_lop varchar(20), -- FK đến lớp
    Anh varchar(50), -- Ảnh bạn đọc
    Ngay_cap int, -- Ngày cấp thẻ (FK đến DIM_Date)
    Ngay_het_han int, -- Ngày hết hạn thẻ (FK đến DIM_Date)
    Email varchar(50), -- Email
    ID_nhom_ban_doc int, -- FK đến nhóm bạn đọc
    ID_nhom_nghanh_nghe int, -- FK đến nhóm ngành nghề
    Gioi_tinh bit, -- Giới tính
    Tinh_trang int, -- Tình trạng
    Ghi_chu ntext, -- Ghi chú
    Mat_khau varchar(50), -- Mật khẩu
    CONSTRAINT [PK_Ban_doc] PRIMARY KEY CLUSTERED (ID_ban_doc), -- Khóa chính clustered
    CONSTRAINT [FK_Ban_doc_Ngay_sinh] FOREIGN KEY (Ngay_sinh) REFERENCES DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Dan_toc] FOREIGN KEY (ID_dan_toc) REFERENCES DIM_Dan_toc(ID_dan_toc),
    CONSTRAINT [FK_Ban_doc_Trinh_do] FOREIGN KEY (ID_trinh_do) REFERENCES DIM_Trinh_do(ID_trinh_do),
    CONSTRAINT [FK_Ban_doc_Lop] FOREIGN KEY (ID_lop) REFERENCES DIM_Lop(ID_lop),
    CONSTRAINT [FK_Ban_doc_Ngay_cap] FOREIGN KEY (Ngay_cap) REFERENCES DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Ngay_het_han] FOREIGN KEY (Ngay_het_han) REFERENCES DIM_Date(Date_key),
    CONSTRAINT [FK_Ban_doc_Nhom_ban_doc] FOREIGN KEY (ID_nhom_ban_doc) REFERENCES DIM_Nhom_ban_doc(ID_nhom_ban_doc),
    CONSTRAINT [FK_Ban_doc_Nhom_nghanh_nghe] FOREIGN KEY (ID_nhom_nghanh_nghe) REFERENCES DIM_Nhom_nghanh_nghe(ID_nhom_nghanh_nghe)
);
------N Bảng DIM_Tai_lieu------
CREATE TABLE DIM_Tai_lieu (
    ID_tai_lieu int NOT NULL, -- Mã tài liệu, khóa chính
    Ma_tai_lieu nvarchar(20) NOT NULL, -- Mã tài liệu
    Nguoi_nhap_tin nvarchar(40), -- Người nhập tin
    Nguoi_kiem_tra nvarchar(40), -- Người kiểm tra
    ID_quoc_gia int, -- FK đến quốc gia
    ID_co_quan_cung_cap int, -- FK đến cơ quan cung cấp
    Ngay_giao_dich int NOT NULL, -- Ngày giao dịch (FK đến DIM_Date)
    Cap_mo_ta_thu_muc varchar(1) NOT NULL, -- Cấp mô tả thư mục
    Muc_do_mat varchar(1) NOT NULL, -- Mức độ mật
    ID_vat_mang_tin int NOT NULL, -- FK đến vật mang tin
    ID_dang_tai_lieu int NOT NULL, -- FK đến dạng tài liệu
    Kieu_ban_ghi varchar(1), -- Kiểu bản ghi
    ID_form int NOT NULL, -- FK đến form
    Leader varchar (25) NOT NULL, -- Leader
    Anh_bia varchar(64), -- Ảnh bìa
    CallNumber NVARCHAR(50), -- Số phân loại
    CONSTRAINT [PK_Tai_lieu] PRIMARY KEY NONCLUSTERED (ID_tai_lieu), -- Khóa chính non-clustered
    CONSTRAINT [FK_Tai_lieu_Ten_nuoc] FOREIGN KEY (ID_quoc_gia) REFERENCES DIM_Quoc_gia(ID_quoc_gia),
    CONSTRAINT [FK_Tai_lieu_Ngay_giao_dich] FOREIGN KEY (Ngay_giao_dich) REFERENCES DIM_Date(Date_key),
    CONSTRAINT [FK_Tai_lieu_Vat_mang_tin] FOREIGN KEY (ID_vat_mang_tin) REFERENCES DIM_Vat_mang_tin(ID_vat_mang_tin),
    CONSTRAINT [FK_Tai_lieu_Dang_tai_lieu] FOREIGN KEY (ID_dang_tai_lieu) REFERENCES DIM_Dang_tai_lieu(ID_dang_tai_lieu),
    CONSTRAINT [FK_Tai_lieu_Ten_Form] FOREIGN KEY (ID_form) REFERENCES DIM_Ten_form(ID_form)
);
------N Bảng DIM_Xep_gia------
CREATE TABLE DIM_Xep_gia(
    ID_xep_gia int NOT NULL, -- Mã xếp giá, khóa chính
    ID_tai_lieu int NOT NULL, -- FK đến tài liệu
    Ma_xep_gia nvarchar(32) NOT NULL, -- Mã xếp giá
    ID_thu_vien nvarchar(32) NOT NULL, -- FK đến thư viện
    ID_kho int NOT NULL, -- FK đến kho
    Ngay_bo_sung int NOT NULL, -- Ngày bổ sung (FK đến DIM_Date)
    Cho_nhap_kho bit NOT NULL, -- Cho nhập kho
    InUsed bit NOT NULL, -- Đang sử dụng
    Gia_tien money, -- Giá tiền
    InCirculation bit, -- Đang lưu hành
    Kiem_ke bit, -- Đã kiểm kê
    Nguon_Nhap nvarchar(100), -- Nguồn nhập
    Callnumber nvarchar(50), -- Số phân loại
    So_HD nvarchar(50), -- Số hợp đồng
    CONSTRAINT [PK_Ma_xep_gia] PRIMARY KEY CLUSTERED (ID_xep_gia), -- Khóa chính
    CONSTRAINT [FK_Ma_xep_gia_Tai_lieu] FOREIGN KEY (ID_tai_lieu) REFERENCES DIM_Tai_lieu(ID_tai_lieu), -- FK tài liệu
    CONSTRAINT [FK_Ma_xep_gia_Thu_vien] FOREIGN KEY (ID_thu_vien) REFERENCES DIM_Thu_vien(ID_thu_vien), -- FK thư viện
    CONSTRAINT [FK_Ma_xep_gia_Kho] FOREIGN KEY (ID_kho) REFERENCES DIM_Kho(ID_kho), -- FK kho
    CONSTRAINT [FK_Ma_xep_Ngay_bo_sung] FOREIGN KEY (Ngay_bo_sung) REFERENCES DIM_Date(Date_key) -- FK ngày bổ sung
);
------N Bảng FACT_Phieu_muon_sach------
CREATE TABLE FACT_Phieu_muon_sach (
    ID_phieu_muon int, -- Mã phiếu mượn, khóa chính
    ID_tai_lieu int NOT NULL, -- FK đến bảng tài liệu
    ID_xep_gia int NOT NULL, -- FK đến bảng mã xếp giá
    ID_ban_doc nvarchar(50) NOT NULL, -- FK đến bảng bạn đọc
    Ngay_muon int NOT NULL, -- Ngày mượn, FK đến bảng ngày
    Ngay_tra int, -- Ngày trả, FK đến bảng ngày
    So_luot_gia_han smallint, -- Số lượt gia hạn
    So_ngay_qua_han int, -- Số ngày quá hạn
    Tien_phat money, -- Tiền phạt
    Ghi_chu nvarchar(max), -- Ghi chú cho phiếu mượn
    CONSTRAINT [PK_Phieu_muon_sach] PRIMARY KEY CLUSTERED (ID_phieu_muon), -- Khóa chính clustered
    CONSTRAINT [FK_Phieu_muon_sach_Tai_lieu] FOREIGN KEY (ID_tai_lieu) REFERENCES DIM_Tai_lieu(ID_tai_lieu), -- FK đến bảng tài liệu
    CONSTRAINT [FK_Phieu_muon_sach_Xep_gia] FOREIGN KEY (ID_xep_gia) REFERENCES DIM_Xep_gia(ID_xep_gia), -- FK đến bảng mã xếp giá
    CONSTRAINT [FK_Phieu_muon_sach_Ban_doc] FOREIGN KEY (ID_ban_doc) REFERENCES DIM_Ban_doc(ID_ban_doc), -- FK đến bảng bạn đọc
    CONSTRAINT [FK_Phieu_muon_sach_Ngay_muon] FOREIGN KEY (Ngay_muon) REFERENCES DIM_Date(Date_key), -- FK đến ngày mượn
    CONSTRAINT [FK_Phieu_muon_sach_Ngay_tra] FOREIGN KEY (Ngay_tra) REFERENCES DIM_Date(Date_key) -- FK đến ngày trả
);
