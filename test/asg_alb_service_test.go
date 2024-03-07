package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAsgAlbService(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:    "../examples/asg-alb-service",
		TerraformBinary: "tofu",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("asg-alb-test-%s", random.UniqueId()),
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	url := terraform.Output(t, terraformOptions, "url")
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World", 30, 5*time.Second)
}
