# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Smart Ping Checker"
$form.Width = 300
$form.Height = 160

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Press the button to ping:"
$label.Location = New-Object System.Drawing.Point(20, 15)
$label.Width = 190
$label.Height = 25
$form.Controls.Add($label)

# Create a button 
$button = New-Object System.Windows.Forms.Button
$button.Text = "Ping Check"
$button.Location = New-Object System.Drawing.Point(20, 40)
$button.Add_Click({
		$ipAddress = $textBox.Text
		$pingResult = Test-Connection -ComputerName $ipAddress -Count 4
		if ($pingResult.ResponseTime -lt 15)
		{
			$textBox2.Text = "Ping response time: $($pingResult.ResponseTime) ms"
			$textBox2.ForeColor = [System.Drawing.Color]::Green
		}
		elseif ($pingResult.ResponseTime -lt 50)
		{
			$textBox2.Text = "Ping response time: $($pingResult.ResponseTime) ms"
			$textBox2.ForeColor = [System.Drawing.Color]::DarkOrange
		}
		else
		{
			$textBox2.Text = "Ping response time: $($pingResult.ResponseTime) ms"
			$textBox2.ForeColor = [System.Drawing.Color]::Red
		}
	})
$form.Controls.Add($button)


# Create a text box for IP address input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 65)
$textBox.Width = 90
$form.Controls.Add($textBox)

# Create a text box for displaying results
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(20, 90)
$textBox2.Width = 200
$textBox2.Multiline = $true
$form.Controls.Add($textBox2)

# Create a "Legend" button
$legendButton = New-Object System.Windows.Forms.Button
$legendButton.Text = "?"
$legendButton.Width = 30
$legendButton.Location = New-Object System.Drawing.Point(240, 90)
$legendButton.Add_Click({
		Show-LegendPopup
	})
$form.Controls.Add($legendButton)

# Function to show the legend popup window
function Show-LegendPopup
{
	$legendMessage = @"
Legend:
<15 ms: Green
16-50 ms: Orange
>51 ms: Red
"@
	Show-Popup "Ping Response Legend" $legendMessage
}

# Function to show a popup window
function Show-Popup
{
	param (
		[string]$title,
		[string]$message
	)
	
	$popupForm = New-Object System.Windows.Forms.Form
	$popupForm.Text = $title
	$popupForm.Width = 320
	$popupForm.Height = 150
	
	$popupLabel = New-Object System.Windows.Forms.Label
	$popupLabel.Text = $message
	$popupLabel.Location = New-Object System.Drawing.Point(20, 20)
	$popupLabel.Width = 200
	$popupLabel.Height = 80
	$popupForm.Controls.Add($popupLabel)
	
	$popupForm.ShowDialog()
}

$form.ShowDialog()
