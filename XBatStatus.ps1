Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Xbox Battery Status"
$form.Width = 300
$form.Height = 170

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Press the button to check battery status:"
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.Width = 150
$label.Height = 30
$form.Controls.Add($label)

# Create a button (Click event triggers initial check and starts timer)
$button = New-Object System.Windows.Forms.Button
$button.Text = "Get Battery Status"
$button.Location = New-Object System.Drawing.Point(20, 60)
$button.Add_Click({
		$atimer.Start() # Start the timer after initial check
	})
$form.Controls.Add($button)

# Create a text box
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 100)
$textBox.Width = 110
$form.Controls.Add($textBox)

# Create a timer (Updates text box with battery status at interval)
$atimer = New-Object System.Windows.Forms.Timer
$atimer.Interval = 1500 # Set the interval in milliseconds (1.5 second)
#$timer.AutoReset = true
#$atimer.Enabled = $true
$atimer.Add_Tick({
		$batteryStatus = (Get-PnpDevice -Class 'Bluetooth' -InstanceId 'BTHLE\DEV_0C3526770446\7&9B9FC6C&0&0C3526770446' |
			Get-PnpDeviceProperty -KeyName '{104EA319-6EE2-4701-BD47-8DDBF425BBE5} 2').Data
		$textBox.Text = "Battery Status: $batteryStatus%"
	})
$atimer.Stop() # Stop the timer initially
$atimer.Dispose()
#$form.Controls.Add($atimer)

# Show the form
$form.ShowDialog()
