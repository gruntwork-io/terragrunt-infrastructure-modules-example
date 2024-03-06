package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMySql(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../examples/mysql",
		TerraformBinary: "tofu",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("mysqltest%s", random.UniqueId()),
		},
		EnvVars: map[string]string{
			"TF_VAR_master_username": "username",
			"TF_VAR_master_password": "password",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
