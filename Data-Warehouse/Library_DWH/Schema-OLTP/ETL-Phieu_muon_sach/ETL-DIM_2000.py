from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pyodbc
import pandas as pd
import numpy as np


# Hàm kết nối và xử lý dữ liệu
def fetch_data_and_process():
    # Tạo kết nối
    conn_dwh_library = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=192.168.150.6;'  # Địa chỉ IP của SQL Server
        'DATABASE=dwh_library;'         # Tên cơ sở dữ liệu
        'UID=itc;'                # Tên đăng nhập
        'PWD=spkt@2025;'
    )
    conn_Library_DWH = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=192.168.150.6;' # Địa chỉ IP của SQL Server
        'DATABASE=Library_DWH;' # Tên cơ sở dữ liệu
        'UID=itc;'              # Tên đăng nhập
        'PWD=spkt@2025;'
    )


    query_DIM_phieu_muon = """
    SELECT ID_phieu_muon,
        ID_tai_lieu,
        ID_xep_gia,
        ID_ban_doc,
        Ngay_muon,
        Ngay_tra,
        So_luot_gia_han,
        So_ngay_qua_han,
        Tien_phat,
        Ghi_chu
    FROM DIM_Phieu_muon_sach
    """
    df_phieumuon = pd.read_sql(query_DIM_phieu_muon, conn_dwh_library)
    print(df_phieumuon)


    # Tạo cursor để thao tác với cơ sở dữ liệu
    cursor_dwh = conn_Library_DWH.cursor()
    insert_query = """
                    INSERT INTO oltp.Phieu_muon_sach (
                        ID_phieu_muon, 
                        ID_tai_lieu, ID_xep_gia,
                        ID_ban_doc, 
                        Ngay_muon, Ngay_tra, 
                        So_luot_gia_han, So_ngay_qua_han, 
                        Tien_phat, Ghi_chu
                    ) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """
    # Chuyển đổi dữ liệu từ DataFrame thành danh sách các tuple để chèn
    data_to_insert = [
        (
            row['ID_phieu_muon'], 
            row['ID_tai_lieu'], row['ID_xep_gia'], 
            row['ID_ban_doc'],
            row['Ngay_muon'], row['Ngay_tra'], 
            row['So_luot_gia_han'], row['So_ngay_qua_han'], 
            row['Tien_phat'], row['Ghi_chu']
        )
        for index, row in df_phieumuon.iterrows()
    ]
    # Sử dụng executemany để chèn dữ liệu cùng lúc
    cursor_dwh.executemany(insert_query, data_to_insert)
    # Commit thay đổi
    conn_Library_DWH.commit()
    # Đóng cursor và kết nối
    cursor_dwh.close()
    conn_Library_DWH.close()




# Định nghĩa DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'etl_dim_pms_2002',
    default_args=default_args,
    description='etl dữ liệu phiếu mượn sách',
    schedule_interval='@once',
    start_date=datetime(2024, 11, 28, 10, 50),
    catchup=False,
    tags=['etl'],
) as dag:

    # Task thực thi
    task_fetch_and_process = PythonOperator(
        task_id='fetch_and_process_data',
        python_callable=fetch_data_and_process,
    )
