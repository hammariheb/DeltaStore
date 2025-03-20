import json
# Load dbt run results
with open("target/run_results.json") as f:
    run_results = json.load(f)
# Define SLO for model execution (e.g., 3 min)
SLO_THRESHOLD = 3*60 # 3 minutes in seconds
# Check if any models exceeded SLO
slow_models = [
    result["unique_id"] for result in run_results["results"]
    if result["execution_time"] > SLO_THRESHOLD
]
if slow_models:
    print(f"🚨 SLO Breached! Slow Models: {slow_models}")