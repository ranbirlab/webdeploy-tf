locals {
  web_deployment_data_dir = "${path.root}/data"

  # landing_zone_files is the list of landing zone YAML files to be processed
  #file_name = var.input_data_format == "json" ? "web_deploy*.json" : "web_deploy*.yaml"

  web_deploy_input_files = fileset(local.web_deployment_data_dir, "web_deploy*.json")

  web_deploy_data_map = {
    for f in local.web_deploy_input_files :
    f => jsondecode(file("${local.web_deployment_data_dir}/${f}"))
  }



  # landing_zone_data_map is the decoded YAML data stored in a map
  /*web_deploy_data_map = var.input_data_format == "json" ? {
    for f in locals.web_deploy_input_files :
    f => jsondecode(file("${web_deployment_data_dir}/${f}"))
    } : {
    for f in locals.web_deploy_input_files :
    f => yamldecode(file("${web_deployment_data_dir}/${f}"))
  }*/




}
