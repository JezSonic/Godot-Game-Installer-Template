extends Control
export var game_name:String
export var version:String
var os = OS.get_name()
var documents = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
var install_dir = 'user://'
var install_editor
var install_leaderboard
var bits = '32'
func _process(delta):
	if not $TabContainer.current_tab == 2:
		$TabContainer.set_tab_disabled(3, true)
	else:
		$TabContainer.set_tab_disabled(3, false)
	if $TabContainer/License/VBoxContainer/yes.pressed == true:
		$TabContainer/License/accept.set_disabled(false)
	else:
		$TabContainer/License/accept.set_disabled(true)
	if $TabContainer/Configurate/Bits/VBoxContainer/CheckBox.pressed == true:
		bits = '32'
	if $TabContainer/Configurate/Bits/VBoxContainer/CheckBox2.pressed == true:
		bits = '64'
	install_editor == $TabContainer/Configurate/AddidtionalComponents/VBoxContainer/LevelEditor.pressed
	install_leaderboard == $TabContainer/Configurate/AddidtionalComponents/VBoxContainer/LevelEditor2.pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	$TabContainer/Finish/Control/Label.set_text('Thank you for installing %s %s.\nYou can close the installer for now.' % [game_name, version])
	if str(os) == 'X11':
		$TabContainer/Configurate/InstallationPath/LineEdit.set_text('/home/User Games/%s' % [game_name])
		install_dir = '/home/User Games/%s' % [game_name]
	if str(os) == 'Windows':
		$TabContainer/Configurate/InstallationPath/LineEdit.set_text('C:/Program Files (x86)/%s' % [game_name])
		install_dir = 'C:/Program Files (x86)/%s' % [game_name]
	get_tree().get_root().set_transparent_background(true)
	$TabContainer/Main/Label.set_text('Welcome to %s %s installer!\n\nClick "Next" to begin installation process.' % [game_name,version])


func _on_Next_pressed():
	$TabContainer.set_current_tab(1)


func _on_Next2_pressed():
	$ConfirmationDialog.popup_centered()


func _on_ConfirmationDialog_confirmed():
	$HTTPRequest.cancel_request()
	$HTTPRequest2.cancel_request()
	get_tree().quit()


func _on_Button_pressed():
	$FileDialog.popup_centered()


func _on_FileDialog_dir_selected(dir):
	$TabContainer/Configurate/InstallationPath/LineEdit.set_text(str(dir))
	install_dir = str(dir)


func _on_Next4_pressed():
	$TabContainer.set_current_tab(1)


func _on_Next5_pressed():
	$TabContainer.set_current_tab(1)


func _on_Next6_pressed():
	$TabContainer.set_current_tab(3)
	_init_game()
	_download()
func _init_game():
	var dir = Directory.new()
	if not dir.dir_exists(str(documents) + '/Pixel Zone/.data/settings/'):
		dir.open(str(documents))
		dir.make_dir(str(documents) + '/Pixel Zone/')
		dir.open(str(documents) + '/Pixel Zone/')
		dir.make(str(documents) + '/Pixel Zone/.data/')
		dir.open(str(documents) + '/Pixel Zone/.data/')
		dir.make(str(documents) + '/Pixel Zone/.data/settings')
	var file = File.new()
	if install_editor == true:
		file.open(str(documents) + '/Pixel Zone/.data/settings/editor.txt', File.WRITE)
		file.close()
	if install_leaderboard == true:
		file.open(str(documents) + '/Pixel Zone/.data/settings/leaderboard.txt', File.WRITE)
		file.close()
func _download():
	var download_file
	var request_file
	#Executable files
	if bits == '64':
		if os == 'Windows':
			download_file = 'PixelZone.exe'
		if os == 'X11':
			download_file = 'PixelZone.x86_64'
	if bits == '32':
		if os == 'Windows':
			download_file = 'PixelZone.exe'
		if os == 'X11':
			download_file = 'PixelZone.x86'
	$HTTPRequest.set_download_file(str(install_dir) + '/' + str(download_file))
	if bits == '64':
		if os == 'Windows':
			request_file = 'https://github.com/MasterPolska123/pixel-zone-master/releases/download/v0.9.2beta-2/Pixel.Zone.-.windows.exe'
		if os == 'X11':
			request_file = 'https://github.com/MasterPolska123/pixel-zone-master/releases/download/v0.9.2beta-2/Pixel.Zone.-.linux.run'
	if bits == '32':
		if os == 'Windows':
			request_file = 'https://github.com/MasterPolska123/pixel-zone-master/releases/download/v0.7.2.1.2/pixelzone-v7.2.1.2-windows-installer.exe'
		if os == 'X11':
			request_file = 'https://github.com/MasterPolska123/pixel-zone-master/releases/download/v0.9.2beta-2/Pixel.Zone.-.linux.run'
			print(str(download_file, request_file))
	$TabContainer/Download/VBoxContainer/Label.set_text('Downloading... Executables')
	$HTTPRequest.request(str(request_file))


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if not result == 0:
		$TabContainer/Download/VBoxContainer/Label.set_text("Can not download %s.\nCheck your WiFi connection" % [game_name])
	else:
		$TabContainer/Download/VBoxContainer/Full2.set_value(50)
		$TabContainer/Download/VBoxContainer/Label.set_text('Downloading... Game Data')
		$HTTPRequest2.set_download_file(str(install_dir) + '/' + 'PixelZone.pck')
		#Download a PCK file
		$HTTPRequest2.request('https://github.com/MasterPolska123/pixel-zone-master/releases/download/v0.7.2.1.2/pixelzone-v7.2.1.2-linux-installer.run')


func _on_HTTPRequest2_request_completed(result, response_code, headers, body):
	if not result == 0:
		$TabContainer/Download/VBoxContainer/Label.set_text("Can not download %s.\nCheck your WiFi connection" % [game_name])
	else:
		$TabContainer/Download/VBoxContainer/Full2.set_value(100)
		$TabContainer/Download/VBoxContainer/Label.set_text("%s has been downloaded" % [game_name])


func _on_nexttab_pressed():
	$TabContainer.set_current_tab(4)


func _on_prevtab_pressed():
	$TabContainer.set_current_tab(2)


func _on_prevtab2_pressed():
	$ConfirmationDialog.popup_centered()


func _on_accept_pressed():
	$TabContainer.set_current_tab(2)


func _on_accept2_pressed():
	$TabContainer.set_current_tab(0)
