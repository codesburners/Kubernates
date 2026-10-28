# PowerShell script to create/update all 15 Jenkins Pipeline jobs
$ErrorActionPreference = "Stop"

$baseUrl = "http://localhost:8080"
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Fetch CSRF Crumb
$crumbRes = Invoke-RestMethod -Uri "$baseUrl/crumbIssuer/api/json" -WebSession $session -UseBasicParsing
$crumbHeader = @{
    $crumbRes.crumbRequestField = $crumbRes.crumb
    "Content-Type" = "application/xml"
}

$jobs = @(
    @{ Name = "Set-01-Kubernetes-Connection"; File = "Set-01-Kubernetes-Connection.jenkinsfile"; Desc = "Set 1: Configure Jenkins to connect to Kubernetes and verify connection" },
    @{ Name = "Set-02-Sample-Deployment"; File = "Set-02-Sample-Deployment.jenkinsfile"; Desc = "Set 2: Create a Jenkins Pipeline to deploy a sample application" },
    @{ Name = "Set-03-Pod-YAML"; File = "Set-03-Pod-YAML.jenkinsfile"; Desc = "Set 3: Implement a Jenkins Pipeline to create a Kubernetes Pod using YAML" },
    @{ Name = "Set-04-Web-Deployment"; File = "Set-04-Web-Deployment.jenkinsfile"; Desc = "Set 4: Use Jenkins to deploy a web application using a Deployment" },
    @{ Name = "Set-05-Expose-Service"; File = "Set-05-Expose-Service.jenkinsfile"; Desc = "Set 5: Configure Jenkins to expose a Kubernetes application using a Service" },
    @{ Name = "Set-06-Scale-Deployment"; File = "Set-06-Scale-Deployment.jenkinsfile"; Desc = "Set 6: Implement a Jenkins Pipeline to scale a Deployment to 3 replicas" },
    @{ Name = "Set-07-Update-Image"; File = "Set-07-Update-Image.jenkinsfile"; Desc = "Set 7: Use Jenkins to update a Deployment with a new Docker image" },
    @{ Name = "Set-08-ConfigMap"; File = "Set-08-ConfigMap.jenkinsfile"; Desc = "Set 8: Configure a Jenkins Pipeline to deploy an application using a ConfigMap" },
    @{ Name = "Set-09-Persistent-Storage"; File = "Set-09-Persistent-Storage.jenkinsfile"; Desc = "Set 9: Use Jenkins to create a PVC and mount it inside a Pod" },
    @{ Name = "Set-10-Readiness-Probe"; File = "Set-10-Readiness-Probe.jenkinsfile"; Desc = "Set 10: Implement a Jenkins Pipeline to configure a readiness probe" },
    @{ Name = "Set-11-GitHub-Integration"; File = "Set-11-GitHub-Integration.jenkinsfile"; Desc = "Set 11: Integrate GitHub with Jenkins to automatically deploy code changes" },
    @{ Name = "Set-12-Docker-Build-Deploy"; File = "Set-12-Docker-Build-Deploy.jenkinsfile"; Desc = "Set 12: Create a Jenkins CI/CD Pipeline to build Docker image and deploy" },
    @{ Name = "Set-13-Rolling-Update"; File = "Set-13-Rolling-Update.jenkinsfile"; Desc = "Set 13: Configure Jenkins to perform rolling updates and verify rollout status" },
    @{ Name = "Set-14-Troubleshooting"; File = "Set-14-Troubleshooting.jenkinsfile"; Desc = "Set 14: Implement a Jenkins Pipeline to detect and troubleshoot failures" },
    @{ Name = "Set-15-Complete-CI-CD"; File = "Set-15-Complete-CI-CD.jenkinsfile"; Desc = "Set 15: Complete CI/CD pipeline using GitHub, Jenkins, Docker, and Kubernetes" }
)

$pipelineDir = "C:\Users\gowth\Desktop\Kubernates\pipelines"

foreach ($job in $jobs) {
    $filePath = Join-Path $pipelineDir $job.File
    if (-not (Test-Path $filePath)) {
        Write-Warning "File not found: $filePath"
        continue
    }

    $scriptContent = Get-Content $filePath -Raw
    $escapedScript = [System.Security.SecurityElement]::Escape($scriptContent)
    $escapedDesc = [System.Security.SecurityElement]::Escape($job.Desc)

    $xmlConfig = @"
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <actions/>
  <description>$escapedDesc</description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps">
    <script>$escapedScript</script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
"@

    # Check if job already exists
    $jobUrl = "$baseUrl/job/$($job.Name)/config.xml"
    $exists = $false
    try {
        $null = Invoke-WebRequest -Uri $jobUrl -Method Get -WebSession $session -UseBasicParsing -ErrorAction SilentlyContinue
        $exists = $true
    } catch {
        $exists = $false
    }

    if ($exists) {
        Write-Host "Updating job: $($job.Name)..."
        $null = Invoke-WebRequest -Uri $jobUrl -Method Post -Body $xmlConfig -Headers $crumbHeader -WebSession $session -UseBasicParsing
        Write-Host "Updated: $($job.Name)" -ForegroundColor Green
    } else {
        Write-Host "Creating job: $($job.Name)..."
        $createUrl = "$baseUrl/createItem?name=$($job.Name)"
        $null = Invoke-WebRequest -Uri $createUrl -Method Post -Body $xmlConfig -Headers $crumbHeader -WebSession $session -UseBasicParsing
        Write-Host "Created: $($job.Name)" -ForegroundColor Green
    }
}

Write-Host "`nAll 15 Jenkins Pipeline jobs are successfully configured!" -ForegroundColor Cyan
