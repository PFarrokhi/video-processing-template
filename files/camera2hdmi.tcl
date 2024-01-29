
################################################################
# This is a generated script based on design: camera2hdmi
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source camera2hdmi_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART myir.com:mys-7z020:part0:2.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name camera2hdmi

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:v_axi4s_vid_out:4.0\
xilinx.com:ip:v_frmbuf_rd:2.1\
xilinx.com:ip:v_tc:6.2\
xilinx.com:ip:v_frmbuf_wr:2.1\
parham:pk:video_stream_not:1.0\
xilinx.com:ip:v_tpg:8.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: video2hdmi
proc create_hier_cell_video2hdmi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_video2hdmi() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 hdmi_data
  create_bd_pin -dir I -from 23 -to 0 video_data

  # Create instance: hdmi_data, and set properties
  set hdmi_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 hdmi_data ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {5} \
   CONFIG.IN1_WIDTH {6} \
   CONFIG.IN2_WIDTH {5} \
   CONFIG.NUM_PORTS {3} \
 ] $hdmi_data

  # Create instance: video_data1, and set properties
  set video_data1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 video_data1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {6} \
 ] $video_data1

  # Create instance: video_data2, and set properties
  set video_data2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 video_data2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {11} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {5} \
 ] $video_data2

  # Create instance: video_data3, and set properties
  set video_data3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 video_data3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {19} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {5} \
 ] $video_data3

  # Create port connections
  connect_bd_net -net v_axi4s_vid_out_0_vid_data [get_bd_pins video_data] [get_bd_pins video_data1/Din] [get_bd_pins video_data2/Din] [get_bd_pins video_data3/Din]
  connect_bd_net -net video_data1_Dout [get_bd_pins hdmi_data/In1] [get_bd_pins video_data1/Dout]
  connect_bd_net -net video_data2_Dout [get_bd_pins hdmi_data/In0] [get_bd_pins video_data2/Dout]
  connect_bd_net -net video_data3_Dout [get_bd_pins hdmi_data/In2] [get_bd_pins video_data3/Dout]
  connect_bd_net -net xlslice_HDMI_data_dout [get_bd_pins hdmi_data] [get_bd_pins hdmi_data/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: video2mem
proc create_hier_cell_video2mem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_video2mem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_write

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_tpg_CTRL

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_vfb_CTRL


  # Create pins
  create_bd_pin -dir I -type clk system_clk
  create_bd_pin -dir I -type rst system_rst_n
  create_bd_pin -dir O -type clk tpg_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst tpg_rst_n
  create_bd_pin -dir O -type intr write_interrupt

  # Create instance: tpg_clk, and set properties
  set tpg_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 tpg_clk ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {151.636} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
   CONFIG.USE_RESET {false} \
 ] $tpg_clk

  # Create instance: tpg_rst, and set properties
  set tpg_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 tpg_rst ]

  # Create instance: v_frmbuf_wr_tpg, and set properties
  set v_frmbuf_wr_tpg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.1 v_frmbuf_wr_tpg ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_tpg

  # Create instance: v_tpg, and set properties
  set v_tpg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:8.0 v_tpg ]
  set_property -dict [ list \
   CONFIG.COLOR_SWEEP {0} \
   CONFIG.DISPLAY_PORT {0} \
   CONFIG.FOREGROUND {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.ZONE_PLATE {0} \
 ] $v_tpg

  # Create interface connections
  connect_bd_intf_net -intf_net prepherals_interconnect_M05_AXI [get_bd_intf_pins s_axi_tpg_CTRL] [get_bd_intf_pins v_tpg/s_axi_CTRL]
  connect_bd_intf_net -intf_net prepherals_interconnect_M06_AXI [get_bd_intf_pins s_axi_vfb_CTRL] [get_bd_intf_pins v_frmbuf_wr_tpg/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_frmbuf_wr_0_m_axi_mm_video [get_bd_intf_pins m_axi_mm_video_write] [get_bd_intf_pins v_frmbuf_wr_tpg/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_tpg_0_m_axis_video [get_bd_intf_pins v_frmbuf_wr_tpg/s_axis_video] [get_bd_intf_pins v_tpg/m_axis_video]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins tpg_clk] [get_bd_pins tpg_clk/clk_out1] [get_bd_pins tpg_rst/slowest_sync_clk] [get_bd_pins v_frmbuf_wr_tpg/ap_clk] [get_bd_pins v_tpg/ap_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins tpg_clk/locked] [get_bd_pins tpg_rst/dcm_locked]
  connect_bd_net -net mem2video_reset1_Dout [get_bd_pins system_rst_n] [get_bd_pins tpg_rst/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins tpg_rst_n] [get_bd_pins tpg_rst/peripheral_aresetn] [get_bd_pins v_frmbuf_wr_tpg/ap_rst_n] [get_bd_pins v_tpg/ap_rst_n]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins system_clk] [get_bd_pins tpg_clk/clk_in1]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins write_interrupt] [get_bd_pins v_frmbuf_wr_tpg/interrupt]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: operation
proc create_hier_cell_operation { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_operation() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_read

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_write

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL_operation

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL_read

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL_write


  # Create pins
  create_bd_pin -dir O -type clk operation_clk
  create_bd_pin -dir O -from 0 -to 0 operation_rst_n
  create_bd_pin -dir O -type intr read_interrupt
  create_bd_pin -dir I -type clk system_clk
  create_bd_pin -dir I -type rst system_rst_n
  create_bd_pin -dir O -type intr write_interrupt

  # Create instance: operation_clk, and set properties
  set operation_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 operation_clk ]
  set_property -dict [ list \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {false} \
 ] $operation_clk

  # Create instance: operation_rst, and set properties
  set operation_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 operation_rst ]

  # Create instance: v_frmbuf_rd_operation, and set properties
  set v_frmbuf_rd_operation [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd:2.1 v_frmbuf_rd_operation ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_UYVY8 {0} \
   CONFIG.HAS_YUYV8 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_rd_operation

  # Create instance: v_frmbuf_wr_operation, and set properties
  set v_frmbuf_wr_operation [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.1 v_frmbuf_wr_operation ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_UYVY8 {0} \
   CONFIG.HAS_YUYV8 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_operation

  # Create instance: video_stream_not_0, and set properties
  set video_stream_not_0 [ create_bd_cell -type ip -vlnv parham:pk:video_stream_not:1.0 video_stream_not_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_CTRL_operation] [get_bd_intf_pins video_stream_not_0/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M02_AXI [get_bd_intf_pins s_axi_CTRL_read] [get_bd_intf_pins v_frmbuf_rd_operation/s_axi_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M03_AXI [get_bd_intf_pins s_axi_CTRL_write] [get_bd_intf_pins v_frmbuf_wr_operation/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_frmbuf_rd_0_m_axi_mm_video [get_bd_intf_pins m_axi_mm_video_read] [get_bd_intf_pins v_frmbuf_rd_operation/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_frmbuf_rd_operation_m_axis_video [get_bd_intf_pins v_frmbuf_rd_operation/m_axis_video] [get_bd_intf_pins video_stream_not_0/video_in]
  connect_bd_intf_net -intf_net v_frmbuf_wr_1_m_axi_mm_video [get_bd_intf_pins m_axi_mm_video_write] [get_bd_intf_pins v_frmbuf_wr_operation/m_axi_mm_video]
  connect_bd_intf_net -intf_net video_stream_not_0_video_out [get_bd_intf_pins v_frmbuf_wr_operation/s_axis_video] [get_bd_intf_pins video_stream_not_0/video_out]

  # Create port connections
  connect_bd_net -net clk_wiz_transmition_clk_out1 [get_bd_pins operation_clk] [get_bd_pins operation_clk/clk_out1] [get_bd_pins operation_rst/slowest_sync_clk] [get_bd_pins v_frmbuf_rd_operation/ap_clk] [get_bd_pins v_frmbuf_wr_operation/ap_clk] [get_bd_pins video_stream_not_0/aclk]
  connect_bd_net -net mem2mem_interrupt [get_bd_pins write_interrupt] [get_bd_pins v_frmbuf_wr_operation/interrupt]
  connect_bd_net -net mem2mem_interrupt1 [get_bd_pins read_interrupt] [get_bd_pins v_frmbuf_rd_operation/interrupt]
  connect_bd_net -net operation_clk_locked [get_bd_pins operation_clk/locked] [get_bd_pins operation_rst/dcm_locked]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins system_clk] [get_bd_pins operation_clk/clk_in1]
  connect_bd_net -net rst_clk_wiz_transmition_100M_peripheral_aresetn [get_bd_pins operation_rst_n] [get_bd_pins operation_rst/peripheral_aresetn] [get_bd_pins v_frmbuf_rd_operation/ap_rst_n] [get_bd_pins v_frmbuf_wr_operation/ap_rst_n] [get_bd_pins video_stream_not_0/aresetn]
  connect_bd_net -net system_rst_n_1 [get_bd_pins system_rst_n] [get_bd_pins operation_rst/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mem2video
proc create_hier_cell_mem2video { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mem2video() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video_read

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_vfb_CTRL


  # Create pins
  create_bd_pin -dir O hdmi_active
  create_bd_pin -dir O -type clk hdmi_clk
  create_bd_pin -dir O -from 15 -to 0 hdmi_data
  create_bd_pin -dir O hdmi_hsync
  create_bd_pin -dir O -from 0 -to 0 hdmi_rst_n
  create_bd_pin -dir O hdmi_vsync
  create_bd_pin -dir O -type intr read_interrupt
  create_bd_pin -dir I -type clk system_clk
  create_bd_pin -dir I -type rst system_rst_n

  # Create instance: hdmi_clk, and set properties
  set hdmi_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 hdmi_clk ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {327.249} \
   CONFIG.CLKOUT1_PHASE_ERROR {300.388} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.2} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {47.250} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {37.500} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_RESET {false} \
 ] $hdmi_clk

  # Create instance: hdmi_rst, and set properties
  set hdmi_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 hdmi_rst ]

  # Create instance: v_axi4s_vid_out, and set properties
  set v_axi4s_vid_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {11} \
   CONFIG.C_HAS_ASYNC_CLK {0} \
   CONFIG.C_PIXELS_PER_CLOCK {1} \
   CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_S_AXIS_VIDEO_FORMAT {2} \
   CONFIG.C_VTG_MASTER_SLAVE {1} \
 ] $v_axi4s_vid_out

  # Create instance: v_frmbuf_rd_hdmi, and set properties
  set v_frmbuf_rd_hdmi [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd:2.1 v_frmbuf_rd_hdmi ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {0} \
   CONFIG.HAS_YUYV8 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_rd_hdmi

  # Create instance: v_tc, and set properties
  set v_tc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 v_tc ]
  set_property -dict [ list \
   CONFIG.GEN_F0_VBLANK_HEND {640} \
   CONFIG.GEN_F0_VBLANK_HSTART {640} \
   CONFIG.GEN_F0_VFRAME_SIZE {525} \
   CONFIG.GEN_F0_VSYNC_HEND {695} \
   CONFIG.GEN_F0_VSYNC_HSTART {695} \
   CONFIG.GEN_F0_VSYNC_VEND {491} \
   CONFIG.GEN_F0_VSYNC_VSTART {489} \
   CONFIG.GEN_F1_VBLANK_HEND {640} \
   CONFIG.GEN_F1_VBLANK_HSTART {640} \
   CONFIG.GEN_F1_VFRAME_SIZE {525} \
   CONFIG.GEN_F1_VSYNC_HEND {695} \
   CONFIG.GEN_F1_VSYNC_HSTART {695} \
   CONFIG.GEN_F1_VSYNC_VEND {491} \
   CONFIG.GEN_F1_VSYNC_VSTART {489} \
   CONFIG.GEN_HACTIVE_SIZE {640} \
   CONFIG.GEN_HFRAME_SIZE {800} \
   CONFIG.GEN_HSYNC_END {752} \
   CONFIG.GEN_HSYNC_START {656} \
   CONFIG.GEN_VACTIVE_SIZE {480} \
   CONFIG.HAS_AXI4_LITE {false} \
   CONFIG.HAS_INTC_IF {false} \
   CONFIG.VIDEO_MODE {480p} \
   CONFIG.enable_detection {false} \
   CONFIG.horizontal_blank_generation {true} \
   CONFIG.vertical_blank_generation {true} \
 ] $v_tc

  # Create instance: video2hdmi
  create_hier_cell_video2hdmi $hier_obj video2hdmi

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M04_AXI [get_bd_intf_pins s_axi_vfb_CTRL] [get_bd_intf_pins v_frmbuf_rd_hdmi/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_frmbuf_rd_1_m_axi_mm_video [get_bd_intf_pins m_axi_mm_video_read] [get_bd_intf_pins v_frmbuf_rd_hdmi/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_frmbuf_rd_hdmi_m_axis_video [get_bd_intf_pins v_axi4s_vid_out/video_in] [get_bd_intf_pins v_frmbuf_rd_hdmi/m_axis_video]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out/vtiming_in] [get_bd_intf_pins v_tc/vtiming_out]

  # Create port connections
  connect_bd_net -net clk_wiz_output_clk_out1 [get_bd_pins hdmi_clk] [get_bd_pins hdmi_clk/clk_out1] [get_bd_pins hdmi_rst/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out/aclk] [get_bd_pins v_frmbuf_rd_hdmi/ap_clk] [get_bd_pins v_tc/clk]
  connect_bd_net -net hdmi_clk_locked [get_bd_pins hdmi_clk/locked] [get_bd_pins hdmi_rst/dcm_locked]
  connect_bd_net -net hls_rst_n_1 [get_bd_pins system_rst_n] [get_bd_pins hdmi_rst/ext_reset_in]
  connect_bd_net -net mem2video_HDMI_active [get_bd_pins hdmi_active] [get_bd_pins v_axi4s_vid_out/vid_active_video]
  connect_bd_net -net mem2video_HDMI_data [get_bd_pins hdmi_data] [get_bd_pins video2hdmi/hdmi_data]
  connect_bd_net -net mem2video_HDMI_hsync [get_bd_pins hdmi_hsync] [get_bd_pins v_axi4s_vid_out/vid_hsync]
  connect_bd_net -net mem2video_HDMI_vsync [get_bd_pins hdmi_vsync] [get_bd_pins v_axi4s_vid_out/vid_vsync]
  connect_bd_net -net mem2video_interrupt [get_bd_pins read_interrupt] [get_bd_pins v_frmbuf_rd_hdmi/interrupt]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins system_clk] [get_bd_pins hdmi_clk/clk_in1]
  connect_bd_net -net rst_clk_wiz_output_100M_peripheral_aresetn [get_bd_pins hdmi_rst_n] [get_bd_pins hdmi_rst/peripheral_aresetn] [get_bd_pins v_axi4s_vid_out/aresetn] [get_bd_pins v_frmbuf_rd_hdmi/ap_rst_n] [get_bd_pins v_tc/resetn]
  connect_bd_net -net v_axi4s_vid_out_0_vid_data [get_bd_pins v_axi4s_vid_out/vid_data] [get_bd_pins video2hdmi/video_data]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out/vtg_ce] [get_bd_pins v_tc/gen_clken]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set sii9022_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 sii9022_i2c ]


  # Create ports
  set hdmi_active [ create_bd_port -dir O hdmi_active ]
  set hdmi_clk [ create_bd_port -dir O hdmi_clk ]
  set hdmi_data [ create_bd_port -dir O -from 15 -to 0 hdmi_data ]
  set hdmi_hsync [ create_bd_port -dir O hdmi_hsync ]
  set hdmi_intn [ create_bd_port -dir I -type intr hdmi_intn ]
  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] $hdmi_intn
  set hdmi_vsync [ create_bd_port -dir O hdmi_vsync ]

  # Create instance: gpio_reset, and set properties
  set gpio_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_reset ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x00000007} \
   CONFIG.C_GPIO_WIDTH {3} \
 ] $gpio_reset

  # Create instance: interrupts, and set properties
  set interrupts [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 interrupts ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $interrupts

  # Create instance: mem2video
  create_hier_cell_mem2video [current_bd_instance .] mem2video

  # Create instance: mem2video_reset, and set properties
  set mem2video_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mem2video_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $mem2video_reset

  # Create instance: memory_interconnect_operation, and set properties
  set memory_interconnect_operation [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 memory_interconnect_operation ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $memory_interconnect_operation

  # Create instance: memory_interconnect_video_in, and set properties
  set memory_interconnect_video_in [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 memory_interconnect_video_in ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $memory_interconnect_video_in

  # Create instance: memory_interconnect_video_out, and set properties
  set memory_interconnect_video_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 memory_interconnect_video_out ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $memory_interconnect_video_out

  # Create instance: operation
  create_hier_cell_operation [current_bd_instance .] operation

  # Create instance: operation_reset, and set properties
  set operation_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 operation_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $operation_reset

  # Create instance: prepherals_interconnect, and set properties
  set prepherals_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 prepherals_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $prepherals_interconnect

  # Create instance: processing_system7, and set properties
  set processing_system7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {500.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_CAN0_CAN0_IO {MIO 14 .. 15} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 51} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CAN0 {1} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {0} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {4} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_I2C1_IO {MIO 12 .. 13} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {83.333336} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {48} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {in} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {out} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {out} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#GPIO#UART 0#UART 0#I2C 1#I2C 1#CAN 0#CAN 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#ENET Reset#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#gpio[9]#rx#tx#scl#sda#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#wp#tx#rx#gpio[50]#reset#mdc#mdio} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.089} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.075} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.025} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.014} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_PACKAGE_NAME {clg400} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {MIO 47} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {16} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 10 .. 11} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {16} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.271} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.259} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.219} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.207} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.229} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.250} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.121} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.146} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_RESET_IO {<Select>} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
 ] $processing_system7

  # Create instance: ps_rst_n, and set properties
  set ps_rst_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ps_rst_n ]

  # Create instance: util_vector_logic_hdmi_intr, and set properties
  set util_vector_logic_hdmi_intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_hdmi_intr ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_hdmi_intr

  # Create instance: video2mem
  create_hier_cell_video2mem [current_bd_instance .] video2mem

  # Create instance: video2mem_reset, and set properties
  set video2mem_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 video2mem_reset ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $video2mem_reset

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins prepherals_interconnect/S00_AXI] [get_bd_intf_pins processing_system7/M_AXI_GP0]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins memory_interconnect_operation/S00_AXI] [get_bd_intf_pins operation/m_axi_mm_video_read]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins memory_interconnect_operation/S01_AXI] [get_bd_intf_pins operation/m_axi_mm_video_write]
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M02_AXI [get_bd_intf_pins operation/s_axi_CTRL_read] [get_bd_intf_pins prepherals_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M03_AXI [get_bd_intf_pins operation/s_axi_CTRL_write] [get_bd_intf_pins prepherals_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_prepherals_M04_AXI [get_bd_intf_pins mem2video/s_axi_vfb_CTRL] [get_bd_intf_pins prepherals_interconnect/M04_AXI]
  connect_bd_intf_net -intf_net mem2video_m_axi_mm_video_read [get_bd_intf_pins mem2video/m_axi_mm_video_read] [get_bd_intf_pins memory_interconnect_video_out/S00_AXI]
  connect_bd_intf_net -intf_net memory_interconnect_operation_M00_AXI [get_bd_intf_pins memory_interconnect_operation/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP1]
  connect_bd_intf_net -intf_net memory_interconnect_video_out1_M00_AXI [get_bd_intf_pins memory_interconnect_video_in/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP2]
  connect_bd_intf_net -intf_net memory_interconnect_video_out_M00_AXI [get_bd_intf_pins memory_interconnect_video_out/M00_AXI] [get_bd_intf_pins processing_system7/S_AXI_HP0]
  connect_bd_intf_net -intf_net prepherals_interconnect_M00_AXI [get_bd_intf_pins gpio_reset/S_AXI] [get_bd_intf_pins prepherals_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net prepherals_interconnect_M05_AXI [get_bd_intf_pins prepherals_interconnect/M05_AXI] [get_bd_intf_pins video2mem/s_axi_tpg_CTRL]
  connect_bd_intf_net -intf_net prepherals_interconnect_M06_AXI [get_bd_intf_pins prepherals_interconnect/M06_AXI] [get_bd_intf_pins video2mem/s_axi_vfb_CTRL]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_IIC_0 [get_bd_intf_ports sii9022_i2c] [get_bd_intf_pins processing_system7/IIC_0]
  connect_bd_intf_net -intf_net s_axi_CTRL_operation_1 [get_bd_intf_pins operation/s_axi_CTRL_operation] [get_bd_intf_pins prepherals_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net v_frmbuf_wr_0_m_axi_mm_video [get_bd_intf_pins memory_interconnect_video_in/S00_AXI] [get_bd_intf_pins video2mem/m_axi_mm_video_write]

  # Create port connections
  connect_bd_net -net S03_ARESETN_1 [get_bd_pins mem2video/hdmi_rst_n] [get_bd_pins memory_interconnect_video_out/ARESETN] [get_bd_pins memory_interconnect_video_out/M00_ARESETN] [get_bd_pins memory_interconnect_video_out/S00_ARESETN] [get_bd_pins prepherals_interconnect/M04_ARESETN]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins gpio_reset/gpio_io_o] [get_bd_pins mem2video_reset/Din] [get_bd_pins operation_reset/Din] [get_bd_pins video2mem_reset/Din]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins memory_interconnect_video_in/ACLK] [get_bd_pins memory_interconnect_video_in/M00_ACLK] [get_bd_pins memory_interconnect_video_in/S00_ACLK] [get_bd_pins prepherals_interconnect/M05_ACLK] [get_bd_pins prepherals_interconnect/M06_ACLK] [get_bd_pins processing_system7/S_AXI_HP2_ACLK] [get_bd_pins video2mem/tpg_clk]
  connect_bd_net -net clk_wiz_output_clk_out1 [get_bd_ports hdmi_clk] [get_bd_pins mem2video/hdmi_clk] [get_bd_pins memory_interconnect_video_out/ACLK] [get_bd_pins memory_interconnect_video_out/M00_ACLK] [get_bd_pins memory_interconnect_video_out/S00_ACLK] [get_bd_pins prepherals_interconnect/M04_ACLK] [get_bd_pins processing_system7/S_AXI_HP0_ACLK]
  connect_bd_net -net clk_wiz_transmition_clk_out1 [get_bd_pins memory_interconnect_operation/ACLK] [get_bd_pins memory_interconnect_operation/M00_ACLK] [get_bd_pins memory_interconnect_operation/S00_ACLK] [get_bd_pins memory_interconnect_operation/S01_ACLK] [get_bd_pins operation/operation_clk] [get_bd_pins prepherals_interconnect/M01_ACLK] [get_bd_pins prepherals_interconnect/M02_ACLK] [get_bd_pins prepherals_interconnect/M03_ACLK] [get_bd_pins processing_system7/S_AXI_HP1_ACLK]
  connect_bd_net -net hdmi_intn_1 [get_bd_ports hdmi_intn] [get_bd_pins util_vector_logic_hdmi_intr/Op1]
  connect_bd_net -net interrupts_dout [get_bd_pins interrupts/dout] [get_bd_pins processing_system7/IRQ_F2P]
  connect_bd_net -net mem2mem_interrupt [get_bd_pins interrupts/In3] [get_bd_pins operation/write_interrupt]
  connect_bd_net -net mem2mem_interrupt1 [get_bd_pins interrupts/In2] [get_bd_pins operation/read_interrupt]
  connect_bd_net -net mem2mem_operation_rst_n [get_bd_pins memory_interconnect_operation/ARESETN] [get_bd_pins memory_interconnect_operation/M00_ARESETN] [get_bd_pins memory_interconnect_operation/S00_ARESETN] [get_bd_pins memory_interconnect_operation/S01_ARESETN] [get_bd_pins operation/operation_rst_n] [get_bd_pins prepherals_interconnect/M01_ARESETN] [get_bd_pins prepherals_interconnect/M02_ARESETN] [get_bd_pins prepherals_interconnect/M03_ARESETN]
  connect_bd_net -net mem2video_hdmi_active [get_bd_ports hdmi_active] [get_bd_pins mem2video/hdmi_active]
  connect_bd_net -net mem2video_hdmi_data [get_bd_ports hdmi_data] [get_bd_pins mem2video/hdmi_data]
  connect_bd_net -net mem2video_hdmi_hsync [get_bd_ports hdmi_hsync] [get_bd_pins mem2video/hdmi_hsync]
  connect_bd_net -net mem2video_hdmi_vsync [get_bd_ports hdmi_vsync] [get_bd_pins mem2video/hdmi_vsync]
  connect_bd_net -net mem2video_interrupt [get_bd_pins interrupts/In4] [get_bd_pins mem2video/read_interrupt]
  connect_bd_net -net mem2video_reset1_Dout [get_bd_pins video2mem/system_rst_n] [get_bd_pins video2mem_reset/Dout]
  connect_bd_net -net mem2video_reset_Dout [get_bd_pins mem2video/system_rst_n] [get_bd_pins mem2video_reset/Dout]
  connect_bd_net -net operation_reset_Dout [get_bd_pins operation/system_rst_n] [get_bd_pins operation_reset/Dout]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins memory_interconnect_video_in/ARESETN] [get_bd_pins memory_interconnect_video_in/M00_ARESETN] [get_bd_pins memory_interconnect_video_in/S00_ARESETN] [get_bd_pins prepherals_interconnect/M05_ARESETN] [get_bd_pins prepherals_interconnect/M06_ARESETN] [get_bd_pins video2mem/tpg_rst_n]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins gpio_reset/s_axi_aclk] [get_bd_pins mem2video/system_clk] [get_bd_pins operation/system_clk] [get_bd_pins prepherals_interconnect/ACLK] [get_bd_pins prepherals_interconnect/M00_ACLK] [get_bd_pins prepherals_interconnect/S00_ACLK] [get_bd_pins processing_system7/FCLK_CLK0] [get_bd_pins processing_system7/M_AXI_GP0_ACLK] [get_bd_pins ps_rst_n/slowest_sync_clk] [get_bd_pins video2mem/system_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7/FCLK_RESET0_N] [get_bd_pins ps_rst_n/ext_reset_in]
  connect_bd_net -net rst_ps7_100M_peripheral_aresetn [get_bd_pins gpio_reset/s_axi_aresetn] [get_bd_pins prepherals_interconnect/ARESETN] [get_bd_pins prepherals_interconnect/M00_ARESETN] [get_bd_pins prepherals_interconnect/S00_ARESETN] [get_bd_pins ps_rst_n/peripheral_aresetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins interrupts/In0] [get_bd_pins util_vector_logic_hdmi_intr/Res]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins interrupts/In1] [get_bd_pins video2mem/write_interrupt]

  # Create address segments
  assign_bd_address -offset 0x40100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs gpio_reset/S_AXI/Reg] -force
  assign_bd_address -offset 0x40020000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs mem2video/v_frmbuf_rd_hdmi/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs operation/v_frmbuf_rd_operation/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x40011000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs operation/v_frmbuf_wr_operation/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x40001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs video2mem/v_frmbuf_wr_tpg/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs video2mem/v_tpg/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x40012000 -range 0x00001000 -target_address_space [get_bd_addr_spaces processing_system7/Data] [get_bd_addr_segs operation/video_stream_not_0/S_AXI_CTRL/S_AXI_CTRL_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces mem2video/v_frmbuf_rd_hdmi/Data_m_axi_mm_video] [get_bd_addr_segs processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces operation/v_frmbuf_rd_operation/Data_m_axi_mm_video] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces operation/v_frmbuf_wr_operation/Data_m_axi_mm_video] [get_bd_addr_segs processing_system7/S_AXI_HP1/HP1_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces video2mem/v_frmbuf_wr_tpg/Data_m_axi_mm_video] [get_bd_addr_segs processing_system7/S_AXI_HP2/HP2_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


