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



    query_phieumuon = """SELECT PMS.ID_phieu_muon, PMS.ID_ban_doc, ID_thu_vien, ID_nhom_ban_doc, Ngay_muon 
                        FROM DIM_Phieu_muon_sach PMS
                                JOIN DIM_Ban_doc BD ON PMS.ID_ban_doc = BD.ID_ban_doc
                                JOIN DIM_Xep_gia XG ON PMS.ID_xep_gia =  XG.ID_xep_gia
                        WHERE Ngay_muon >= 20110101 AND Ngay_muon < 20210101"""
    df_phieumuon = pd.read_sql(query_phieumuon, conn_dwh_library)   
    


    # Tính số lượng mượn sách
    So_nguoi_dung = df_phieumuon.groupby(['ID_thu_vien', 'ID_nhom_ban_doc', 'Ngay_muon'])['ID_ban_doc'].count().reset_index()
    So_nguoi_dung = So_nguoi_dung.rename(columns={'ID_ban_doc': 'So_nguoi_dung'})



    #LOAD
    cursor_dwh = conn_dwh_library.cursor()
    insert_query = """
                    INSERT INTO FACT_Thu_vien (ID_thu_vien, 
                                                ID_nhom_ban_doc,  
                                                ID_date, 
                                                So_nguoi_dung)
                    VALUES (?, ?, ?, ?)
                    """
    for index, row in So_nguoi_dung.iterrows():
    # Trích xuất giá trị từ các cột
        values = (row['ID_thu_vien'],
                row['ID_nhom_ban_doc'],
                row['Ngay_muon'],
                row['So_nguoi_dung'])  # Nếu cột này có tên đúng
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
    'etl_fact_tktv_2020',
    default_args=default_args,
    description='Load data vào bảng Thống Kê Thư Viện',
    schedule_interval='@once',
    start_date=datetime(2024, 12, 18, 4, 30),
    catchup=False,
    tags=['etl'],
) as dag:

    # Task thực thi
    task_fetch_and_process = PythonOperator(
        task_id='fetch_and_process_data',
        python_callable=fetch_data_and_process,
    )
