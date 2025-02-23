from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pyodbc
import pandas as pd
import numpy as np
def fetch_data_and_process():
    conn_libol = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=192.168.150.6;'  # Địa chỉ IP của SQL Server
    'DATABASE=libol;'         # Tên cơ sở dữ liệu
    'UID=itc;'                # Tên đăng nhập
    'PWD=spkt@2025;'
    )
    conn_dwh_library = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=192.168.150.6;' # Địa chỉ IP của SQL Server
        'DATABASE=Library_DWH;' # Tên cơ sở dữ liệu
        'UID=itc;'              # Tên đăng nhập
        'PWD=spkt@2025;'
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
    df_xepgia = fetch_data_in_batches(query_Xepgia, conn_libol, batch_size=100) # Gọi hàm để lấy dữ liệu


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
    # Thêm dòng dữ liệu giả định vào `df` bằng `pd.concat`
    df_xepgia = pd.concat([df_xepgia, new_row], ignore_index=True) # Thêm vào dataframe
    df_xepgia = df_xepgia.sort_values(by="ID", ascending=True).reset_index(drop=True) # sắp xếp từ nhỏ đến lớn           
    df_xepgia = df_xepgia.replace('', None)
    df_xepgia = df_xepgia.replace(np.nan, None)



    #Xử lý date
    query_date = "SELECT Date_key FROM olap.DIM_Date"
    df_date = pd.read_sql(query_date, conn_dwh_library)
    date_ids = set(df_date['Date_key'])
    # chuyển date về dang int 
    # kiểm tra nhưng ngày đó có tồn tại trong date_key của bảng DIM_date hay không ?
    df_xepgia['Ngay_bo_sung'] = pd.to_datetime(df_xepgia['Ngay_bo_sung'], errors='coerce')
    df_xepgia['Ngay_bo_sung'] = df_xepgia['Ngay_bo_sung'].apply(lambda x: int(x.strftime('%Y%m%d')) if pd.notna(x) and int(x.strftime('%Y%m%d')) in date_ids else 0)



    # Xử lý ID_thu_vien
    # truy xuất dữ liệu từ libol ra
    query_Thuvien = "SELECT Thu_vien_ID, dbo.DecodeUTF8String(Ten_viet_tat) AS Ten_viet_tat FROM Thu_vien"
    df_thuvien = pd.read_sql(query_Thuvien, conn_libol)
    map_dict = dict(zip(df_thuvien['Thu_vien_ID'], df_thuvien['Ten_viet_tat'])) # mapping lại 1:DHSPKT 2:ĐHSPKT
    # kiểm tra id trong mapping nếu trùng với Thu_vien_ID thì đổi thành Ten_viet_tat
    # vd 1 -> DHSPKT
    df_xepgia['Ten_thu_vien_ID'] = df_xepgia['Ten_thu_vien_ID'].map(map_dict).fillna(df_xepgia['Ten_thu_vien_ID'])
    # truy xuất dữ liệu từ dwh bảng DIM_Thu_vien ra
    query_Thuvien = "SELECT ID_thu_vien FROM olap.DIM_Thu_vien"
    df_thuvien = pd.read_sql(query_Thuvien, conn_dwh_library)
    thuvien_ids = set(df_thuvien['ID_thu_vien'])
    # kiểm tra tên viết tắt ở trên kìa có trong bảng DIM_Thu_vien không? có thì bỏ qua không thì bằng 0
    df_xepgia['Ten_thu_vien_ID'] = df_xepgia['Ten_thu_vien_ID'].apply(lambda x: x if x in thuvien_ids else 0)
    print(df_xepgia[['Ten_thu_vien_ID']])



    # Xử lý ID_kho
    query_Kho = "SELECT ID_kho FROM olap.DIM_Kho"
    df_kho = pd.read_sql(query_Kho, conn_dwh_library)
    kho_ids = set(df_kho['ID_kho'])
    # chuyển date về dang int 
    # kiểm tra id đó có tồn tại trong ID_kho của bảng DIM_Kho hay không ?
    df_xepgia['Kho_ID'] = df_xepgia['Kho_ID'].apply(lambda x: x if pd.notna(x) and x in kho_ids else 0)
    print(df_xepgia[['Kho_ID']])



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

        # Tạo cursor để thao tác với cơ sở dữ liệu
    cursor_dwh = conn_dwh_library.cursor()

    # Chuẩn bị câu lệnh chèn dữ liệu
    insert_query = """
                    INSERT INTO olap.DIM_Xep_gia (
                        ID_xep_gia, ID_tai_lieu, Ma_xep_gia,
                        ID_thu_vien, ID_kho, 
                        Ngay_bo_sung,
                        Cho_nhap_kho, InUsed,
                        Gia_tien, InCirculation, Kiem_ke,
                        Nguon_Nhap, Callnumber, So_HD
                    ) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """
    # Chuyển đổi dữ liệu từ DataFrame thành danh sách các tuple để chèn
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
    # Sử dụng executemany để chèn dữ liệu cùng lúc
    cursor_dwh.executemany(insert_query, data_to_insert)
    # Commit thay đổi
    conn_dwh_library.commit()
    # Đóng cursor và kết nối
    cursor_dwh.close()
    conn_dwh_library.close()



# Định nghĩa DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'ETL-Xep_gia',
    default_args=default_args,
    description='DAG xử lý DIM xếp giá',
    schedule_interval='@once',  # Chạy thủ công
    start_date=datetime(2025, 2, 24, 3, 35),
    catchup=False,
    tags=['etl'],
) as dag:

    # Task thực thi
    task_fetch_and_process = PythonOperator(
        task_id='fetch_and_process_data',
        python_callable=fetch_data_and_process,
    )
