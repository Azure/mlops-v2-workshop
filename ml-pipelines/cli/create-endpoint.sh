name=$1 
resource_group=$2
workspace-name=$3

endpoint=$(az ml online-endpoint list  --query "[].{Name:name}"  --output table \
--resource-group $resource_group --workspace-name $workspace_name | grep -q '$name' )
if [[ -z "$endpoint" ]]
then
  az ml online-endpoint create --name $name \
  -f ${{ github.workspace }}/ml-pipelines/cli/deploy/online/online-endpoint.yml --resource-group $resource_group \
  --workspace-name $workspace_name
else
  echo "Endpoint $name exists"
fi       
