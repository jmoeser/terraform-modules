package test

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/terraform"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

func checkVault(t *testing.T, expectedCode int) {

	maxRetries := 5
	timeBetweenRetries := 2 * time.Second
	url := "https://localhost:8200/v1/sys/health"

	CAPool := x509.NewCertPool()
	severCert, err := ioutil.ReadFile("./vault-certs/vault-ca.crt")
	if err != nil {
		log.Fatal("Could not load Vault CA certificate!")
	}
	CAPool.AppendCertsFromPEM(severCert)

	tlsConfig := tls.Config{
		RootCAs:    CAPool,
		ServerName: "vault",
	}

	http_helper.HttpGetWithRetryWithCustomValidation(t, url, &tlsConfig, maxRetries, timeBetweenRetries, func(status int, body string) bool {
		return status == expectedCode
	})

}

func TestVault(t *testing.T) {

	makeCertsCommand := shell.Command{
		Command: "./make_certs.sh",
	}

	// removeCertsCommand := shell.Command{
	// 	Command: "rm",
	// 	Args: []string{
	// 		"-rf", "vault-certs",
	// 	},
	// }

	workDir, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	// fmt.Println(workDir)

	// removeTerragruntCacheCommand := shell.Command{
	// 	Command: "find",
	// 	Args: []string{
	// 		workDir, "-type", "d", "-iname", ".terragrunt-cache", "-prune", "-exec", "rm", "-rf", "{}", "\;"
	// 	},
	// }

	tempDir, err := ioutil.TempDir(os.TempDir(), "terratest-")
	if err != nil {
		log.Fatal(err)
	}
	defer os.RemoveAll(tempDir)

	dockerOptions := &docker.Options{}

	// Make sure to shut down the Docker container at the end of the test
	defer docker.RunDockerCompose(t, dockerOptions, "down", "-v")

	shell.RunCommand(t, makeCertsCommand)
	//defer shell.RunCommand(t, removeCertsCommand)
	defer os.RemoveAll(filepath.Join(workDir, "vault-certs"))
	//defer shell.RunCommand(t, removeTerragruntCacheCommand)

	// Run Docker Compose to start Vault.
	docker.RunDockerCompose(t, dockerOptions, "up", "-d", "vault")

	// Verify that we get back a 501 for Vault not initialised as expected
	// https://www.vaultproject.io/api/system/health.html
	checkVault(t, 501)

	initVaultCommand := shell.Command{
		Command: "./vault_init.sh",
	}

	shell.RunCommand(t, initVaultCommand)

	// Verify that we get back a 200 for Vault being initialised and unsealed
	// https://www.vaultproject.io/api/system/health.html
	checkVault(t, 200)

	// run base, get the output, then run concourse?
	baseTerraformOptions := &terraform.Options{
		TerraformBinary: "terragrunt",
		// The path to where our Terraform code is located
		TerraformDir: "./base",

		// // Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"VAULT_ADDR": "https://127.0.0.1:8200",
			//"VAULT_CACERT": "tests/vault-certs/vault-ca.crt",
			"VAULT_CACERT":        filepath.Join(filepath.Dir(workDir), "tests/vault-certs/vault-ca.crt"),
			"TERRAGRUNT_DOWNLOAD": filepath.Join(tempDir, "base"),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, baseTerraformOptions)
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	fmt.Println(path) // for example /home/user
	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, baseTerraformOptions)

	provisionerToken := terraform.Output(t, baseTerraformOptions, "provisioner_client_token")

	// run base, get the output, then run concourse?
	terraformOptions := &terraform.Options{
		TerraformBinary: "terragrunt",
		// The path to where our Terraform code is located
		TerraformDir: "./concourse",

		// // Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"VAULT_ADDR":          "https://127.0.0.1:8200",
			"VAULT_CACERT":        filepath.Join(filepath.Dir(workDir), "tests/vault-certs/vault-ca.crt"),
			"VAULT_TOKEN":         provisionerToken,
			"TERRAGRUNT_DOWNLOAD": filepath.Join(tempDir, "concourse"),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values  our output variables
	roleID := terraform.Output(t, terraformOptions, "role_id")
	secretID := terraform.Output(t, terraformOptions, "secret_id")

	roleParam := fmt.Sprintf("role_id:%s,secret_id:%s", roleID, secretID)

	concourseDockerOptions := &docker.Options{
		EnvVars: map[string]string{
			"CONCOURSE_VAULT_AUTH_PARAM": roleParam,
		},
	}

	// Run Docker Compose to start Postgres and Concourse
	docker.RunDockerCompose(t, concourseDockerOptions, "up", "-d")

	// test can read secret from /concourse path?
	// test can't read secret from other path?

}
