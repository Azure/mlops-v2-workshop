yaml_path=$1
name=$2 


endpoint=$(az ml online-endpoint list  --query "[].{Name:name}"  --output table | grep $name'$' )
if [[ -z "$endpoint" ]]
then
  az ml online-endpoint create --name $name -f $1 
else
  echo "Endpoint $name exists"
fi       
