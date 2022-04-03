from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime
import os

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2020,8,1),
    'retries': 0
}

with DAG('dbt_models', default_args=default_args, schedule_interval='@once') as dag:
    staging = BashOperator(
        task_id='staging',
        bash_command='cd /dbt && dbt run --models staging --profiles-dir .',
        env={
            'dbt_user': '{{ var.value.dbt_user }}',
            'dbt_password': '{{ var.value.dbt_password }}',
            **os.environ
        },
        dag=dag
    )

    score = BashOperator(
        task_id='IMDB_weighted_rating',
        bash_command='cd /dbt && dbt run --models marts.score --profiles-dir .',
        env={
            'dbt_user': '{{ var.value.dbt_user }}',
            'dbt_password': '{{ var.value.dbt_password }}',
            **os.environ
        },
        dag=dag
    )

    q_movies = BashOperator(
        task_id='q_movies',
        bash_command='cd /dbt && dbt run --models marts.q_movies --profiles-dir .',
        env={
            'dbt_user': '{{ var.value.dbt_user }}',
            'dbt_password': '{{ var.value.dbt_password }}',
            **os.environ
        },
        dag=dag
    )

    movies = BashOperator(
        task_id='tmdb_movies_report',
        bash_command='cd /dbt && dbt run --models marts.movies --profiles-dir .',
        env={
            'dbt_user': '{{ var.value.dbt_user }}',
            'dbt_password': '{{ var.value.dbt_password }}',
            **os.environ
        },
        dag=dag
    )

    credits = BashOperator(
        task_id='tmdb_credits_report',
        bash_command='cd /dbt && dbt run --models marts.credits --profiles-dir .',
        env={
            'dbt_user': '{{ var.value.dbt_user }}',
            'dbt_password': '{{ var.value.dbt_password }}',
            **os.environ
        },
        dag=dag
    )

    staging >> score >> q_movies >> [credits, movies] 