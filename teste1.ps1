try {
    cmd /c ipconfig2 2>$null
    if ($LASTEXITCODE -eq 0)
    {
        Write-Warning "IPConfig Ran" 
    }
    else {
        # throw "Baaaad"
        Write-Error -Message "Houston, we have a problem." -ErrorAction Stop
    }
}
catch {
    Write-Warning "Deu Ruim"

    <#Do this if a terminating exception happens#>
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
}

