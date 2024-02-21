#!/bin/bash

# Azure DevOps Project Name
read -p "Environment Name : " env
read -p "Pat Token : " pat

# Azure DevOps Organization URL
org_url="https://dev.azure.com/<org>-$env"
url="https://dev.azure.com/<org>-$env/_apis/projects?api-version=6.0"

# Getting Response 
response=$(curl -s -u ":$pat" "$url")
# Extracting Project name
project_names=$(echo "$response" | jq -r '.value[].name')
# to store count of ALL Pipeline
total_count=0
#Replacing ' ' with '%20'
projects=$(echo "$project_names" | sed 's/ /%20/g; s/'"'"'//g')


while IFS= read -r project; do

# Azure DevOps REST API URL for pipelines in a project
new_project_name=$(echo "$project" | sed 's/%20/ /g')
pipelines_url="$org_url/$project/_apis/pipelines?api-version=7.1"
echo -e "\n"
echo "$project"
echo "------------------------------------"

# Make the API request using curl
pipelines_response=$(curl -s -u ":$pat" "$pipelines_url")


# To Store Pipeline name and Date
declare -a result_array
# To Store count of each Project
count=0

# Getting All Pipeline IDs in array
pipeline_ids=$(echo "$pipelines_response" | jq -r '.value[].id')

# Threshold Date 
threshold_date="2023-09-01T00:00:00Z"

#Converting in timestamp
threshold_date_convert=$(echo "$threshold_date" | cut -d 'T' -f1)
#converting to Integer
date=$(date -jf "%Y-%m-%d" "$threshold_date_convert" "+%s")
echo "Loading..."
for pipeline_id in $pipeline_ids ; do
pipeline_url="$org_url/$project/_apis/build/Definitions/$pipeline_id?revision=1"

# Make the API request using curl
pipeline_response=$(curl -s -u ":$pat" "$pipeline_url")
# getting information from response
pipeline_id=$(echo "$pipeline_response" | jq -r '.id')
pipeline_name=$(echo "$pipeline_response" | jq -r '.name')
creation_date=$(echo "$pipeline_response" | jq -r '.createdDate')

# Converting to yyyy-mm-dd
creation_date_converted=$(echo "$creation_date" | cut -d 'T' -f1)
# Converting to integer
date2=$(date -jf "%Y-%m-%d" "$creation_date_converted" "+%s")

# Check if the pipeline timestamp is after threshold date


 if [ $date2 -gt $date ]; then
    result_array+=("Pipeline $pipeline_name was created on: $creation_date")
    #Writing in a CSV file
    echo "$new_project_name,$pipeline_name" >> "project-pipeline-count-$env.csv"
    ((count++))
    ((total_count++))
  fi
done
echo "$new_project_name,$count" >> "count-pipeline-$env.csv"
echo -e "\n"
for result in "${result_array[@]}"; do
  echo "$result"

done
unset result_array
echo "---------------------------------------------"
echo "Total Pipeline Count : $count"
echo -e "\n"

done <<< "$projects"
# Total Pipeline Count
echo "Total New Pipeline Created are : $total_count"