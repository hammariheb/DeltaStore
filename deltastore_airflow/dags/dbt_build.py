from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "retries": 3
}

with DAG(
    "dbt_build",
    default_args=default_args,
    schedule_interval="0 2 * * *",
    catchup=False,
) as dag:

    source_freshness = BashOperator(
        task_id="source_freshness",
        bash_command="cd /opt/dbt && dbt source freshness",
    )
    # Run dbt build inside the container
    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="cd /opt/dbt && dbt build --target prod",
    )

    # Notify success
    notify_success = BashOperator(
        task_id="notify_success",
        bash_command="echo 'job completed successfully!'"
    )

    # The order of execution
    source_freshness >> dbt_build >> notify_success
