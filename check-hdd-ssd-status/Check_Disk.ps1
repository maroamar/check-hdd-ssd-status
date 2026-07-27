Write-Host "===================================================" -ForegroundColor Green
Write-Host "       Hard Drive S.M.A.R.T. Diagnostic Tool       " -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Write-Host ""

Write-Host "--- [1] Power-On Hours & Usage ---" -ForegroundColor Cyan
Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictData | ForEach-Object {
    $bytes = $_.VendorSpecific
    for ($i = 2; $i -lt $bytes.Length - 12; $i += 12) {
        if ($bytes[$i] -eq 9) {
            $hours = [BitConverter]::ToUInt32($bytes, $i + 5)
            [PSCustomObject]@{
                "Hard Drive Hours" = $hours
                "Days Active"      = [math]::Round($hours / 24, 1)
            }
        }
    }
} | Format-Table -AutoSize

Write-Host "--- [2] Physical Health & Operational Status ---" -ForegroundColor Cyan
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, HealthStatus, OperationalStatus | Format-Table -AutoSize

Write-Host "--- [3] Hardware Failure Prediction Check ---" -ForegroundColor Cyan
Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select-Object PredictFailure, Reason | Format-Table -AutoSize

Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")