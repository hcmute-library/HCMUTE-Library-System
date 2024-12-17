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
    'SERVER=192.168.150.6;' # Địa chỉ IP của SQL Server
    'DATABASE=dwh_library;' # Tên cơ sở dữ liệu
    'UID=itc;'              # Tên đăng nhập
    'PWD=spkt@2024;')
    query_phieumuon = """SELECT PMS.ID_phieu_muon, PMS.ID_ban_doc, PMS.ID_tai_lieu, Ma_xep_gia, Ngay_muon 
                            FROM DIM_Phieu_muon_sach PMS
                                    JOIN DIM_Ban_doc BD ON BD.ID_ban_doc = PMS.ID_ban_doc
                                    JOIN DIM_Xep_gia XG ON XG.ID_xep_gia = PMS.ID_xep_gia 
                            WHERE Ngay_muon < 20110101"""
    df_phieumuon = pd.read_sql(query_phieumuon, conn_dwh_library)
    
    


    # Tính số lượng mượn sách
    so_luong_muon_sach = df_phieumuon.groupby(['ID_ban_doc', 'ID_tai_lieu', 'Ma_xep_gia', 'Ngay_muon'])['ID_phieu_muon'].count().reset_index()
    so_luong_muon_sach = so_luong_muon_sach.rename(columns={'ID_phieu_muon': 'So_luot_muon'})



    #LOAD
    cursor_dwh = conn_dwh_library.cursor()
    insert_query = """
                    INSERT INTO FACT_Thong_ke_muon (ID_ban_doc, 
                                                    ID_tai_lieu,
                                                    Ma_xep_gia, 
                                                    ID_date,
                                                    So_luot_muon)
                    VALUES (?, ?, ?, ?, ?)
                    """
    for index, row in so_luong_muon_sach.iterrows():
    # Trích xuất giá trị từ các cột
        values = (row['ID_ban_doc'],
                row['ID_tai_lieu'],
                row['Ma_xep_gia'],
                row['Ngay_muon'],
                row['So_luot_muon'])  # Nếu cột này có tên đúng
        cursor_dwh.execute(insert_query, values)
    conn_dwh_library.commit()


# Định nghĩa DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'etl_fact_tkm_2010',
    default_args=default_args,
    description='Load data vào bảng Thống Kê Mượn ',
    schedule_interval='@once',
    start_date=datetime(2024, 12, 1, 16, 15),
    catchup=False,
    tags=['etl'],
) as dag:

    # Task thực thi
    task_fetch_and_process = PythonOperator(
        task_id='fetch_and_process_data',
        python_callable=fetch_data_and_process,
    )
