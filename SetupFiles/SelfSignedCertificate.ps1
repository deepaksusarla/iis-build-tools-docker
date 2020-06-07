# Generates Certificate and import it to Current user's certificate Store
$certificate = New-SelfSignedCertificate `
    -Subject localhost `
    -DnsName localhost `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -NotBefore (Get-Date) `
    -NotAfter (Get-Date).AddYears(2) `
    -CertStoreLocation "cert:CurrentUser\My" `
    -FriendlyName "Docker Localhost Certificate" `
    -HashAlgorithm SHA256 `
    -KeyUsage DigitalSignature, KeyEncipherment, DataEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.1") 
$certificatePath = 'Cert:\CurrentUser\My\' + ($certificate.ThumbPrint)  

# Create temporary certificate path
$tmpPath = "C:\Certs"
If(!(test-path $tmpPath))
{
New-Item -ItemType Directory -Force -Path $tmpPath
}

# Set certificate password here
$pfxPassword = ConvertTo-SecureString -String "Concento#1" -Force -AsPlainText
$pfxFilePath = "C:\Certs\Concento.pfx"
$cerFilePath = "C:\Certs\Concento.cer"

# Create pfx certificate
Export-PfxCertificate -Cert $certificatePath -FilePath $pfxFilePath -Password $pfxPassword
Export-Certificate -Cert $certificatePath -FilePath $cerFilePath

Import-PfxCertificate -Password $pfxPassword -CertStoreLocation Cert:\LocalMachine\My -FilePath $pfxFilePath
$pfxThumbprint = (Get-PfxData -FilePath $pfxFilePath -Password $pfxPassword).EndEntityCertificates.Thumbprint

$binding = New-WebBinding -Name "Default Web Site" -Protocol https -IPAddress * -Port 443;
$binding = Get-WebBinding -Name "Default Web Site" -Protocol https;
$binding.AddSslCertificate($pfxThumbprint, "my");