

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "video_stream_not" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_CTRL_BASEADDR" "C_S_AXI_CTRL_HIGHADDR"
}
