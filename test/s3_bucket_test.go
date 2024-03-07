package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestS3Bucket(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../examples/s3-bucket",
		TerraformBinary: "tofu",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("terragrunt-infrastructure-modules-examples-test-%s", strings.ToLower(random.UniqueId())),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
