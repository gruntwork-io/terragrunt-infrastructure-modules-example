package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestLambdaService(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../examples/lambda-service",
		TerraformBinary: "tofu",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("lambda-service-test-%s", random.UniqueId()),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	url := terraform.Output(t, terraformOptions, "api_endpoint")
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World!", 30, 5*time.Second)
}
