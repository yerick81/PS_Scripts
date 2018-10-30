#Primero debemos importar las librerias de .Net para formularios, seguidamente debemos crear un objeto de tipo formulario, 
#y sobre el le agregaremos valores a algunas de sus propiedades
$Form = New-Object system.Windows.Forms.Form 
$Form.Size = New-Object System.Drawing.Size(300,200) 
$Form.StartPosition = "CenterScreen"  
$Form.Text = "GUI PRUEBA ALAN"
$Form.Width = 600
$Form.Height = 400

#AutiSize para extirar la ventana a placer
$Form.AutoSize = $true

#Etiqueta para mostrar un mensaje
$Label = New-Object System.Windows.Forms.Label 
$Label.Text = "Escoja la accion" 
$Label.AutoSize = $true 
$Label.Location = New-Object System.Drawing.Size(75,50) 
$Font = New-Object System.Drawing.Font("Arial",15,[System.Drawing.FontStyle]::Bold) 
$Label.Font = $Font 
$Form.Controls.Add($Label)

# 2 Botones para  mostrar resultado
$Okbutton = New-Object System.Windows.Forms.Button 
$Okbutton.Location = New-Object System.Drawing.Size(40,80) 
$Okbutton.Size = New-Object System.Drawing.Size(100,30) 
$Okbutton.Text = "Informacion Usuario"



$var = (((quser) -replace '^>', '') -replace '\s{2,}', ',').Trim() | ForEach-Object {
    if ($_.Split(',').Count -eq 5) {
        Write-Output ($_ -replace '(^[^,]+)', '$1,')
    } else {
        Write-Output $_
    }
} | ConvertFrom-Csv

$var.USERNAME
$var.SESSIONNAME
$var.ID
$var.STATE
$var.'LOGON TIME'
$var.'IDLE TIME'
 
$Okbutton.Add_Click(
    {
        $var =(((quser) -replace '^>', '') -replace '\s{2,}', ','.Trim() | ForEach-Object {
        if ($_.Split(',').Count -eq 5) {
            Write-Output ($_ -replace '(^[^,]+)', '$1,')
        } else {
            Write-Output $_
        }
        } | ConvertFrom-Csv)

        $LabelUserName = New-Object System.Windows.Forms.Label 
        $LabelUserName.Text = $var.USERNAME 
        $LabelUserName.AutoSize = $true 
        $LabelUserName.Location = New-Object System.Drawing.Size(250,150) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelUserName.Font = $Font 
        $Form.Controls.Add($LabelUserName)

        $LabelSessionName = New-Object System.Windows.Forms.Label 
        $LabelSessionName.Text = $var.SessionName
        $LabelSessionName.AutoSize = $true 
        $LabelSessionName.Location = New-Object System.Drawing.Size(250,170) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelSessionName.Font = $Font 
        $Form.Controls.Add($LabelSessionName)

        $LabelId = New-Object System.Windows.Forms.Label 
        $LabelId.Text = $var.ID 
        $LabelId.AutoSize = $true 
        $LabelId.Location = New-Object System.Drawing.Size(250,190) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelUserName.Font = $Font 
        $Form.Controls.Add($LabelId)

        $LabelState = New-Object System.Windows.Forms.Label 
        $LabelState.Text = $var.STATE 
        $LabelState.AutoSize = $true 
        $LabelState.Location = New-Object System.Drawing.Size(250,210) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelState.Font = $Font 
        $Form.Controls.Add($LabelState)

        $LabelLogonTime = New-Object System.Windows.Forms.Label 
        $LabelLogonTime.Text = $var.'LOGON TIME' 
        $LabelLogonTime.AutoSize = $true 
        $LabelLogonTime.Location = New-Object System.Drawing.Size(250,230) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelLogonTime.Font = $Font 
        $Form.Controls.Add($LabelLogonTime)

        $LabelIdleTime= New-Object System.Windows.Forms.Label 
        $LabelIdleTime.Text = $var.'IDLE TIME' 
        $LabelIdleTime.AutoSize = $true 
        $LabelIdleTime.Location = New-Object System.Drawing.Size(250,250) 
        $Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold) 
        $LabelIdleTime.Font = $Font 
        $Form.Controls.Add($LabelIdleTime)
    }
)
   


$Form.Controls.Add($Okbutton)


$Closebutton = New-Object System.Windows.Forms.Button 
$Closebutton.Location = New-Object System.Drawing.Size(150,80) 
$Closebutton.Size = New-Object System.Drawing.Size(100,30) 
$Closebutton.Text = "Close"

$Closebutton.Add_Click({$Form.Close()}) 
$Form.Controls.Add($Closebutton)
  
#Mostrar ventana	
$Form.ShowDialog()


