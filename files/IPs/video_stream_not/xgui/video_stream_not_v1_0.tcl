# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {interface}]
  #Adding Group
  set control_interface [ipgui::add_group $IPINST -name "control interface" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "CTRL_DATA_WIDTH" -parent ${control_interface}
  ipgui::add_param $IPINST -name "CTRL_ADDR_WIDTH" -parent ${control_interface}

  #Adding Group
  set video_interface [ipgui::add_group $IPINST -name "video interface" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "VIDEO_DATA_WIDTH" -parent ${video_interface}



}

proc update_PARAM_VALUE.CTRL_ADDR_WIDTH { PARAM_VALUE.CTRL_ADDR_WIDTH } {
	# Procedure called to update CTRL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_ADDR_WIDTH { PARAM_VALUE.CTRL_ADDR_WIDTH } {
	# Procedure called to validate CTRL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.CTRL_DATA_WIDTH { PARAM_VALUE.CTRL_DATA_WIDTH } {
	# Procedure called to update CTRL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_DATA_WIDTH { PARAM_VALUE.CTRL_DATA_WIDTH } {
	# Procedure called to validate CTRL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.VIDEO_DATA_WIDTH { PARAM_VALUE.VIDEO_DATA_WIDTH } {
	# Procedure called to update VIDEO_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VIDEO_DATA_WIDTH { PARAM_VALUE.VIDEO_DATA_WIDTH } {
	# Procedure called to validate VIDEO_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.CTRL_BASEADDR { PARAM_VALUE.CTRL_BASEADDR } {
	# Procedure called to update CTRL_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_BASEADDR { PARAM_VALUE.CTRL_BASEADDR } {
	# Procedure called to validate CTRL_BASEADDR
	return true
}

proc update_PARAM_VALUE.CTRL_HIGHADDR { PARAM_VALUE.CTRL_HIGHADDR } {
	# Procedure called to update CTRL_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_HIGHADDR { PARAM_VALUE.CTRL_HIGHADDR } {
	# Procedure called to validate CTRL_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.CTRL_DATA_WIDTH { MODELPARAM_VALUE.CTRL_DATA_WIDTH PARAM_VALUE.CTRL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CTRL_DATA_WIDTH}] ${MODELPARAM_VALUE.CTRL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.CTRL_ADDR_WIDTH { MODELPARAM_VALUE.CTRL_ADDR_WIDTH PARAM_VALUE.CTRL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CTRL_ADDR_WIDTH}] ${MODELPARAM_VALUE.CTRL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.VIDEO_DATA_WIDTH { MODELPARAM_VALUE.VIDEO_DATA_WIDTH PARAM_VALUE.VIDEO_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VIDEO_DATA_WIDTH}] ${MODELPARAM_VALUE.VIDEO_DATA_WIDTH}
}

