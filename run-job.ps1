param (
    [Parameter(Mandatory=$true)]
    [string]$JobName
)

$baseUrl = "http://localhost:8080"
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

# Get Crumb
$crumbRes = Invoke-RestMethod -Uri "$baseUrl/crumbIssuer/api/json" -WebSession $session -UseBasicParsing
$headers = @{
    $crumbRes.crumbRequestField = $crumbRes.crumb
}

Write-Host "Triggering build for job: $JobName..." -ForegroundColor Cyan
$buildRes = Invoke-WebRequest -Uri "$baseUrl/job/$JobName/build" -Method Post -Headers $headers -WebSession $session -UseBasicParsing

$queueUrl = $buildRes.Headers["Location"]
Write-Host "Queued at: $queueUrl"

# Wait for build to start
Start-Sleep -Seconds 3

# Find latest build number
$buildNumber = 0
for ($i = 0; $i -lt 10; $i++) {
    try {
        $jobInfo = Invoke-RestMethod -Uri "$baseUrl/job/$JobName/api/json" -WebSession $session -UseBasicParsing
        if ($jobInfo.lastBuild) {
            $buildNumber = $jobInfo.lastBuild.number
            break
        }
    } catch {}
    Start-Sleep -Seconds 2
}

if ($buildNumber -eq 0) {
    Write-Warning "Could not find build number."
    exit 1
}

Write-Host "Running Build #$buildNumber..." -ForegroundColor Cyan

# Wait for build completion
while ($true) {
    $bInfo = Invoke-RestMethod -Uri "$baseUrl/job/$JobName/$buildNumber/api/json" -WebSession $session -UseBasicParsing
    if (-not $bInfo.building) {
        $color = if ($bInfo.result -eq "SUCCESS") { "Green" } else { "Red" }
        Write-Host "`nBuild #$buildNumber finished with status: $($bInfo.result)" -ForegroundColor $color
        break
    }
    Start-Sleep -Seconds 2
}

# Fetch Console Output
$log = Invoke-RestMethod -Uri "$baseUrl/job/$JobName/$buildNumber/consoleText" -WebSession $session -UseBasicParsing
Write-Host "`n--- Console Output (Build #$buildNumber) ---" -ForegroundColor Yellow
Write-Host $log
