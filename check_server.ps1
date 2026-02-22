try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/sensors" -UseBasicParsing -TimeoutSec 2
    $response.Content | Out-File -Encoding utf8 status_3000.txt
}
catch {
    "Failed" | Out-File -Encoding utf8 status_3000.txt
}
