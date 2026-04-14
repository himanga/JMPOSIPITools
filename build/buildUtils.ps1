function Get-CustomMetadata {
    param($Path)

    $content = Get-Content $Path -Raw
    $id      = [regex]::Match($content, 'List\(\s*"id",\s*"([^"]+)"').Groups[1].Value
    $version = [regex]::Match($content, 'List\(\s*"addinVersion",\s*([\d.]+)').Groups[1].Value
    $state   = [regex]::Match($content, 'List\(\s*"state",\s*"([^"]+)"').Groups[1].Value

    return [pscustomobject]@{
        Id      = $id
        Version = $version
        State   = $state
    }
}

function Get-TimestampForJMP {
    $epoch = Get-Date "1970-01-01T00:00:00Z"
    $now   = (Get-Date).ToUniversalTime()

    $unixSeconds = [math]::Round( ($now - $epoch).TotalSeconds )
    return $unixSeconds + 2082823200
}