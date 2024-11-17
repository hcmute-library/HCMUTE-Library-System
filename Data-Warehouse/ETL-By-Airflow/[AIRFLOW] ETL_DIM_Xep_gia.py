import pyodbc
import pandas as pd
import numpy as np

conn_libol = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=192.168.150.6;'  # Địa chỉ IP của SQL Server
    'DATABASE=libol;'         # Tên cơ sở dữ liệu
    'UID=itc;'                # Tên đăng nhập
    'PWD=spkt@2024;'
)
conn_dwh_lib = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=192.168.150.6;'  # Địa chỉ IP của SQL Server
    'DATABASE=dwh_lib;'         # Tên cơ sở dữ liệu
    'UID=itc;'                # Tên đăng nhập
    'PWD=spkt@2024;'
)

# Hàm đọc dữ liệu từng phần và xử lý lỗi
def fetch_data_in_batches(query_base, connection, batch_size=100):
    offset = 0
    all_data = []  # Lưu tất cả các hàng hợp lệ
    while True:
        query = f"""
        {query_base}
        ORDER BY ID
        OFFSET {offset} ROWS FETCH NEXT {batch_size} ROWS ONLY
        """
        try:
            # Đọc dữ liệu batch hiện tại
            df_batch = pd.read_sql(query, connection)
            if df_batch.empty:  # Nếu không còn dữ liệu, dừng vòng lặp
                break
            all_data.append(df_batch)  # Lưu batch hợp lệ
            offset += batch_size  # Tăng offset để đọc batch tiếp theo
        except Exception as e:
            print(f"Lỗi xảy ra khi xử lý batch từ {offset}: {e}")
            offset += batch_size  # Bỏ qua batch bị lỗi và tiếp tục
    # Gộp tất cả các batch thành DataFrame duy nhất
    return pd.concat(all_data, ignore_index=True) if all_data else pd.DataFrame()

query_Xepgia = """
SELECT ID,
       Tai_lieu_ID, 
       Ma_xep_gia,
       Ten_thu_vien_ID,
       Kho_ID,
       Ngay_bo_sung,
       Cho_nhap_kho,
       InUsed,
       Gia,
       Gia_tien,
       InCirculation,
       Kiem_ke,
       dbo.DecodeUTF8String(Nguon_Nhap) AS Nguon_Nhap,
       dbo.DecodeUTF8String(Callnumber) AS Callnumber,
       So_HD
  FROM Ma_xep_gia
"""
df_xepgia = fetch_data_in_batches(query_Xepgia, conn_libol, batch_size=100)



# Tạo DataFrame `new_row` chứa dòng dữ liệu giả định
new_row = pd.DataFrame({
    'ID': [0],
    'Tai_lieu_ID': ['0'],
    'Ma_xep_gia': ['(Không xác định)'],
    'Ten_thu_vien_ID': ['0'],
    'Kho_ID': [0],
    'Ngay_bo_sung': ['1024-01-01 00:00:00'],
    'Cho_nhap_kho': [0],
    'InUsed': [0],
    'Gia': [0],
    'Gia_tien': [0],
    'InCirculation': [0],
    'Kiem_ke': [0],
    'Nguon_Nhap': ['(Không xác định)'],
    'Callnumber': ['(Không xác định)'],
    'So_HD': ['(Không xác định)']
})
df_xepgia = pd.concat([df_xepgia, new_row], ignore_index=True) # Thêm vào dataframe
df_xepgia = df_xepgia.sort_values(by="ID", ascending=True).reset_index(drop=True) # sắp xếp từ nhỏ đến lớn           



# Xử lý NaN và ""
df_xepgia = df_xepgia.replace('', None)
df_xepgia = df_xepgia.replace(np.nan, None)



# Xử lý Date
query_date = "SELECT Date_key FROM DIM_Date"
df_date = pd.read_sql(query_date, conn_dwh_lib)
date_ids = set(df_date['Date_key'])
# chuyển date về dang int 
# kiểm tra nhưng ngày đó có tồn tại trong date_key của bảng DIM_date hay không ?
df_xepgia['Ngay_bo_sung'] = pd.to_datetime(df_xepgia['Ngay_bo_sung'], errors='coerce')
df_xepgia['Ngay_bo_sung'] = df_xepgia['Ngay_bo_sung'].apply(lambda x: int(x.strftime('%Y%m%d')) if pd.notna(x) and int(x.strftime('%Y%m%d')) in date_ids else 0)
print(df_xepgia[['Ngay_bo_sung']])



# Xử lý ID_tai_lieu
query_Tailieu = "SELECT ID_tai_lieu FROM DIM_Tai_lieu"
df_tailieu = pd.read_sql(query_Tailieu, conn_dwh_lib)
tailieu_ids = set(df_tailieu['ID_tai_lieu'])
# chuyển date về dang int 
# kiểm tra nhưng ngày đó có tồn tại trong ID_tai_lieu của bảng DIM_Tai_lieu hay không ?
df_xepgia['Tai_lieu_ID'] = df_xepgia['Tai_lieu_ID'].apply(lambda x: x if pd.notna(x) and x in tailieu_ids else 0)
print(df_xepgia[['Tai_lieu_ID']])



# Xử lý ID_Thu_vien
# truy xuất dữ liệu từ libol ra
query_Thuvien = "SELECT Thu_vien_ID, dbo.DecodeUTF8String(Ten_viet_tat) AS Ten_viet_tat FROM Thu_vien"
df_thuvien = pd.read_sql(query_Thuvien, conn_libol)
map_dict = dict(zip(df_thuvien['Thu_vien_ID'], df_thuvien['Ten_viet_tat'])) # mapping lại 1:DHSPKT 2:ĐHSPKT
# kiểm tra id trong mapping nếu trùng với Thu_vien_ID thì đổi thành Ten_viet_tat
# vd 1 -> DHSPKT
df_xepgia['Ten_thu_vien_ID'] = df_xepgia['Ten_thu_vien_ID'].map(map_dict).fillna(df_xepgia['Ten_thu_vien_ID'])
# truy xuất dữ liệu từ dwh bảng DIM_Thu_vien ra
query_Thuvien = "SELECT ID_thu_vien FROM DIM_Thu_vien"
df_thuvien = pd.read_sql(query_Thuvien, conn_dwh_lib)
thuvien_ids = set(df_thuvien['ID_thu_vien'])
# kiểm tra tên viết tắt ở trên kìa có trong bảng DIM_Thu_vien không? có thì bỏ qua không thì bằng 0
df_xepgia['Ten_thu_vien_ID'] = df_xepgia['Ten_thu_vien_ID'].apply(lambda x: x if x in thuvien_ids else 0)
print(df_xepgia[['Ten_thu_vien_ID']])



#Xử lý ID_Kho
query_Kho = "SELECT ID_kho FROM DIM_Kho"
df_kho = pd.read_sql(query_Kho, conn_dwh_lib)
kho_ids = set(df_kho['ID_kho'])
# chuyển date về dang int 
# kiểm tra id đó có tồn tại trong ID_kho của bảng DIM_Kho hay không ?
df_xepgia['Kho_ID'] = df_xepgia['Kho_ID'].apply(lambda x: x if pd.notna(x) and x in kho_ids else 0)
print(df_xepgia[['Kho_ID']])



# Xử lý ID_Gia_tien
# Gia với Gia_tien giống nhau
# Gia kiểu varchar và Gia_tien kiểu money
# quét qua từng hàng
for index, row in df_xepgia.iterrows(): 
    if pd.isnull(row['Gia_tien']): # nếu gia tiền null và gia đang có giá trị thì chuyển về float và dán lại
        if not pd.isnull(row['Gia']):
            df_xepgia.at[index, 'Gia_tien'] = float(row['Gia'])
        else:
            df_xepgia.at[index, 'Gia_tien'] = 0;
print(df_xepgia['Gia_tien'])



# LOAD DATA 
cursor_dwh = conn_dwh_lib.cursor() # Tạo cursor để thao tác với cơ sở dữ liệu
insert_query = """
                INSERT INTO DIM_Xep_gia (
                    ID_xep_gia, ID_tai_lieu, Ma_xep_gia,
                    ID_thu_vien, ID_kho, 
                    Ngay_bo_sung,
                    Cho_nhap_kho, InUsed,
                    Gia_tien, InCirculation, Kiem_ke,
                    Nguon_Nhap, Callnumber, So_HD
                ) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
               """
data_to_insert = [
    (
        row['ID'], row['Tai_lieu_ID'], row['Ma_xep_gia'], 
        row['Ten_thu_vien_ID'], row['Kho_ID'], 
        row['Ngay_bo_sung'],
        row['Cho_nhap_kho'], row['InUsed'],
        row['Gia_tien'], row['InCirculation'], row['Kiem_ke'], 
        row['Nguon_Nhap'], row['Callnumber'], row['So_HD']
    )
    for index, row in df_xepgia.iterrows()
]
cursor_dwh.executemany(insert_query, data_to_insert) # Sử dụng executemany để chèn dữ liệu cùng lúc
conn_dwh_lib.commit( ) # Commit thay đổi
cursor_dwh.close() # Đóng cursor và kết nối
conn_dwh_lib.close()

