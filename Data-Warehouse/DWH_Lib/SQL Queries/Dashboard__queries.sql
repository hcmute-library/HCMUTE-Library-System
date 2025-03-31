-- Các yêu cầu thống kê rút trích dữ liệu( xem Thư viện có đáp ứng các yêu cầu sau)
-- a1) Số đầu sách giáo trình, sách chuyên khảo tính bình quân trên một ngành đào tạo ở mỗi trình độ đào tạo không nhỏ hơn 40;
SELECT DT.Ten_chuong_trinh_dao_tao, 
       COUNT(FTL.ID_tai_lieu) AS Tong_so_dau_sach, 
       COUNT(FTL.ID_tai_lieu) / COUNT(DISTINCT MDT.ID_mon) AS So_dau_sach_binh_quan
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao
HAVING (COUNT(FTL.ID_tai_lieu) / COUNT(DISTINCT MDT.ID_mon)) >= 40
ORDER BY DT.Ten_chuong_trinh_dao_tao

-- a2) Số bản sách giáo trình, sách chuyên khảo tính bình quân trên một ngành đào tạo ở mỗi trình độ đào tạo không nhỏ hơn 40;
SELECT DT.Ten_chuong_trinh_dao_tao, 
       SUM(FTL.So_ban_sach) AS Tong_so_dau_sach, 
       SUM(FTL.So_ban_sach) / COUNT(DISTINCT MDT.ID_mon) AS So_dau_sach_binh_quan
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao
HAVING (COUNT(FTL.ID_tai_lieu) / COUNT(DISTINCT MDT.ID_mon)) >= 40
ORDER BY DT.Ten_chuong_trinh_dao_tao


-- b) Số bản sách giáo trình, sách chuyên khảo tính bình quân trên một người học quy đổi theo trình độ đào tạo không nhỏ hơn 5
SELECT DT.Ten_chuong_trinh_dao_tao,
       SUM(FTL.So_ban_sach) AS Tong_so_ban_sach,
       SUM(FM.So_luot_muon) AS Tong_so_nguoi_hoc,
       (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon)) AS Ban_sach_binh_quan_nguoi_hoc
FROM olap.FACT_Muon FM
JOIN olap.DIM_Tai_lieu TL ON FM.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.FACT_Tai_lieu FTL ON FTL.ID_tai_lieu = FM.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao
HAVING (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon)) >= 5
ORDER BY DT.Ten_chuong_trinh_dao_tao;


-- a) Số tên giáo trình: Có đầy đủ giáo trình theo yêu cầu của chương trình đào tạo dùng cho giảng viên, người học trong giảng dạy và học tập, nghiên cứu khoa học;
SELECT DT.Ten_chuong_trinh_dao_tao,
       COUNT(DISTINCT TL.ID_tai_lieu) AS So_ten_giao_trinh
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao
ORDER BY DT.Ten_chuong_trinh_dao_tao;


-- b) Số bản sách cho mỗi tên giáo trình: Có ít nhất 50 bản sách/1.000 người học;
SELECT TL.ID_tai_lieu,
       SUM(FTL.So_ban_sach) AS Tong_so_ban_sach,
       SUM(FM.So_luot_muon) AS Tong_so_nguoi_hoc,
       (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon) * 1000) AS Ban_sach_tren_1000_nguoi_hoc
FROM olap.FACT_Muon FM
JOIN olap.FACT_Tai_lieu FTL ON FTL.ID_tai_lieu = FM.ID_tai_lieu
JOIN olap.DIM_Tai_lieu TL ON FM.ID_tai_lieu = TL.ID_tai_lieu
GROUP BY TL.ID_tai_lieu
HAVING (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon) * 1000) >= 50


-- c) Số bản sách cho mỗi tên tài liệu tham khảo: Có ít nhất 20 bản sách/1.000 người học;
SELECT TL.ID_tai_lieu, 
       SUM(FTL.So_ban_sach) AS Tong_so_ban_sach, 
       SUM(FM.So_luot_muon) AS Tong_so_nguoi_hoc,
       (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon) * 1000) AS Ban_sach_tren_1000_nguoi_hoc
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.FACT_Muon FM ON FTL.ID_tai_lieu = FM.ID_tai_lieu
GROUP BY TL.ID_tai_lieu
HAVING (SUM(FTL.So_ban_sach) / SUM(FM.So_luot_muon) * 1000) >= 20


-- Số người học theo chuyên ngành
SELECT NNN.Nhom_nghanh_nghe, SUM(FTV.So_luot_dung) AS So_nguoi_doc
FROM olap.FACT_Thu_vien FTV
JOIN olap.DIM_Ban_doc BD ON FTV.ID_ban_doc = BD.ID_ban_doc
JOIN olap.DIM_Nhom_nghanh_nghe NNN ON BD.ID_nhom_nghanh_nghe = NNN.ID_nhom_nghanh_nghe
GROUP BY NNN.Nhom_nghanh_nghe;


-- Số lượng người học theo niên khóa
SELECT NK.Ten_nien_khoa, SUM(FTV.So_luot_dung) AS So_nguoi_doc
FROM olap.FACT_Thu_vien FTV
JOIN olap.DIM_Ban_doc BD ON FTV.ID_ban_doc = BD.ID_ban_doc
JOIN olap.DIM_Nien_khoa NK ON BD.ID_nien_khoa = NK.ID_nien_khoa
GROUP BY NK.Ten_nien_khoa;


-- Số lượng mượn sách của sinh viên trong một năm theo chuyên ngành (Tính từ tháng 8 đến tháng 7 năm sau)
SELECT DT.Ten_chuong_trinh_dao_tao, SUM(FM.So_luot_muon) AS So_luot_muon
FROM olap.FACT_Muon FM
JOIN olap.DIM_Tai_lieu TL ON FM.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao;


-- Số lượng mượn sách của sinh viên theo tháng, theo năm
SELECT D.Month, D.Year, SUM(FM.So_luot_muon) AS So_luot_muon
FROM olap.FACT_Muon FM
JOIN olap.DIM_Date D ON FM.ID_date = D.Date_key
GROUP BY D.Month, D.Year
ORDER BY D.Year DESC, D.Month ASC;


-- Sách mượn nhiều nhất theo từng ngành
WITH SachMuon AS (SELECT NN.Nhom_nghanh_nghe, TL.ID_tai_lieu, 
						SUM(FM.So_luot_muon) AS So_luot_muon,
						ROW_NUMBER() OVER (PARTITION BY NN.Nhom_nghanh_nghe ORDER BY SUM(FM.So_luot_muon) DESC) AS RowNum
				  FROM olap.FACT_Muon FM
						JOIN olap.DIM_Ban_doc BD ON FM.ID_ban_doc = BD.ID_ban_doc
						JOIN olap.DIM_Nhom_nghanh_nghe NN ON BD.ID_nhom_nghanh_nghe = NN.ID_nhom_nghanh_nghe
						JOIN olap.DIM_Tai_lieu TL ON FM.ID_tai_lieu = TL.ID_tai_lieu
				  GROUP BY NN.Nhom_nghanh_nghe, TL.ID_tai_lieu)
SELECT Nhom_nghanh_nghe, ID_tai_lieu, So_luot_muon
FROM SachMuon
WHERE RowNum = 1
ORDER BY Nhom_nghanh_nghe;


-- Sách mượn ích nhất theo ngành
WITH SachMuon AS (SELECT NN.Nhom_nghanh_nghe, TL.ID_tai_lieu, 
						SUM(FM.So_luot_muon) AS So_luot_muon,
						ROW_NUMBER() OVER (PARTITION BY NN.Nhom_nghanh_nghe ORDER BY SUM(FM.So_luot_muon) ASC) AS RowNum
				  FROM olap.FACT_Muon FM
						JOIN olap.DIM_Ban_doc BD ON FM.ID_ban_doc = BD.ID_ban_doc
						JOIN olap.DIM_Nhom_nghanh_nghe NN ON BD.ID_nhom_nghanh_nghe = NN.ID_nhom_nghanh_nghe
						JOIN olap.DIM_Tai_lieu TL ON FM.ID_tai_lieu = TL.ID_tai_lieu
				  GROUP BY NN.Nhom_nghanh_nghe, TL.ID_tai_lieu)
SELECT Nhom_nghanh_nghe, ID_tai_lieu, So_luot_muon
FROM SachMuon
WHERE RowNum = 1
ORDER BY Nhom_nghanh_nghe;


-- Số lượng sinh viên sử dụng thư viện (ra vào) theo tuần, tháng, quý, năm
SELECT D.Year, D.Month, D.Week_of_quarter, TV.Thu_vien, SUM(FTV.So_luot_dung) AS So_luot_dung
FROM olap.FACT_Thu_vien FTV
JOIN olap.DIM_date D ON FTV.ID_date = D.Date_key
JOIN olap.DIM_Xep_gia XG ON FTV.ID_xep_gia = XG.ID_xep_gia
JOIN olap.DIM_Thu_vien TV ON XG.ID_thu_vien = TV.ID_thu_vien
GROUP BY D.Year, D.Month, D.Week_of_quarter, TV.Thu_vien
ORDER BY  D.Year DESC, D.Month ASC, D.Week_of_quarter, TV.Thu_vien;


-- Số lượng đầu sách phục vụ cho chương trình đào tạo trên tổng số môn của chương trình đào tạo
SELECT DT.Ten_chuong_trinh_dao_tao, COUNT(FTL.ID_tai_lieu)
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao;

-- Số lượng bản (đếm MaXepGia) sách phục vụ cho chương trình đào tạo trên tổng số môn của chương trình đào tạo
SELECT DT.Ten_chuong_trinh_dao_tao, SUM(So_ban_sach)
FROM olap.FACT_Tai_lieu FTL
JOIN olap.DIM_Tai_lieu TL ON FTL.ID_tai_lieu = TL.ID_tai_lieu
JOIN olap.DIM_Mon_CTDT MDT ON TL.ID_mon = MDT.ID_mon
JOIN olap.DIM_CTDT DT ON MDT.ID_ctdt = DT.ID_ctdt
GROUP BY DT.Ten_chuong_trinh_dao_tao;

