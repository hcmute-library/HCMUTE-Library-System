SELECT 
    d.Year AS Nam,
    d.Quarter AS Quy,
    d.Month AS Thang,
    d.Week AS Tuan,
    SUM(tv.So_nguoi_dung) AS So_sinh_vien_su_dung
FROM 
    FACT_Thu_vien tv
    JOIN DIM_Date d ON tv.ID_date = d.Date_key
GROUP BY 
    d.Year, d.Quarter, d.Month, d.Week;
