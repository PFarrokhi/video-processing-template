################################################################################
################################## HDMI I2C ####################################
################################################################################
set_property PACKAGE_PIN P15 [get_ports sii9022_i2c_sda_io]
set_property PACKAGE_PIN P16 [get_ports sii9022_i2c_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports sii9022_i2c_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports sii9022_i2c_scl_io]
set_property PULLUP true [get_ports sii9022_i2c_sda_io]
set_property PULLUP true [get_ports sii9022_i2c_scl_io]
################################################################################
