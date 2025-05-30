from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pyodbc
import pandas as pd
import numpy as np


# Hàm kết nối và xử lý dữ liệu
def fetch_data_and_process():
    # Tạo kết nối
    conn_172 = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=192.168.150.6;' # Địa chỉ IP của SQL Server
        'DATABASE=DWH_Lib;' # Tên cơ sở dữ liệu
        'UID=itc;'              # Tên đăng nhập
        'PWD=spkt@2025;')

    # Đọc data từ SQL Server
    query_tailieu = """SELECT ID_tai_lieu, Ma_tai_lieu, Ngay_giao_dich 
                    FROM olap.DIM_Tai_lieu"""
    df_tai_lieu = pd.read_sql(query_tailieu, conn_172)
    query_xepgia = """SELECT ID_xep_gia, ID_tai_lieu 
                    FROM olap.DIM_Xep_gia"""
    df_xep_gia = pd.read_sql(query_xepgia, conn_172)
    
    # Xử lý data số đầu sách
    so_ban_sach = df_xep_gia.groupby('ID_tai_lieu')['ID_xep_gia'].count().reset_index()
    so_ban_sach = so_ban_sach.rename(columns={'ID_xep_gia': 'So_ban_sach'})

    so_dau_sach = df_tai_lieu.groupby('Ma_tai_lieu')['ID_tai_lieu'].nunique().reset_index()
    so_dau_sach = so_dau_sach.rename(columns={'ID_tai_lieu': 'So_dau_sach'})

    # Gộp So_ban_sach vào dữ liệu tài liệu
    df_final = df_tai_lieu.merge(so_ban_sach, on='ID_tai_lieu', how='left')

    # Gộp tiếp So_dau_sach
    df_final = df_final.merge(so_dau_sach, on='Ma_tai_lieu', how='left' )

    # Nếu tài liệu không có bản sách, gán 0
    df_final['So_ban_sach'] = df_final['So_ban_sach'].fillna(0).astype(int)
    print(df_final)

    # load vào datawarehouse
    cursor_dwh = conn_172.cursor()
    insert_query = """
                    INSERT INTO olap.FACT_Tai_lieu (ID_tai_lieu,
                                                    Ma_tai_lieu, 
                                                    ID_date, 
                                                    So_dau_sach,
                                                    So_ban_sach)
                    VALUES (?, ?, ?, ?, ?)"""
    for index, row in df_final.iterrows():
    # Trích xuất giá trị từ các cột
        values = (row['ID_tai_lieu'],
                row['Ma_tai_lieu'],
                row['Ngay_giao_dich'],
                row['So_dau_sach'],
                row['So_ban_sach']) 
        cursor_dwh.execute(insert_query, values)
    conn_172.commit()

# Định nghĩa DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    'etl_fact_tai_lieu',
    default_args=default_args,
    description='Load data vào bảng Thống Kê Tài Liệu',
    schedule_interval='@once',
    start_date=datetime(2025, 3, 27, 14, 40),
    catchup=False,
    tags=['etl'],
) as dag:

    # Task thực thi
    task_fetch_and_process = PythonOperator(
        task_id='fetch_and_process_data',
        python_callable=fetch_data_and_process,
    )
