
`timescale 1 ns / 1 ps

module video_stream_not_v1_0 #
(
	parameter integer CTRL_DATA_WIDTH	= 32,
	parameter integer CTRL_ADDR_WIDTH	= 4,
	parameter integer VIDEO_DATA_WIDTH	= 24
)
(
	input wire  aclk,
	input wire  aresetn,

	// Ports of Axi Slave Bus Interface S_AXI_CTRL
	input wire [CTRL_ADDR_WIDTH-1 : 0] s_axi_ctrl_awaddr,
	input wire [2 : 0] s_axi_ctrl_awprot,
	input wire  s_axi_ctrl_awvalid,
	output wire  s_axi_ctrl_awready,
	input wire [CTRL_DATA_WIDTH-1 : 0] s_axi_ctrl_wdata,
	input wire [(CTRL_DATA_WIDTH/8)-1 : 0] s_axi_ctrl_wstrb,
	input wire  s_axi_ctrl_wvalid,
	output wire  s_axi_ctrl_wready,
	output wire [1 : 0] s_axi_ctrl_bresp,
	output wire  s_axi_ctrl_bvalid,
	input wire  s_axi_ctrl_bready,
	input wire [CTRL_ADDR_WIDTH-1 : 0] s_axi_ctrl_araddr,
	input wire [2 : 0] s_axi_ctrl_arprot,
	input wire  s_axi_ctrl_arvalid,
	output wire  s_axi_ctrl_arready,
	output wire [CTRL_DATA_WIDTH-1 : 0] s_axi_ctrl_rdata,
	output wire [1 : 0] s_axi_ctrl_rresp,
	output wire  s_axi_ctrl_rvalid,
	input wire  s_axi_ctrl_rready,

	// ports of axis slave video_in
	input wire [VIDEO_DATA_WIDTH-1 : 0] s_axis_video_tdata,
	input wire s_axis_video_tvalid,
	output wire s_axis_video_tready,
	input wire s_axis_video_tlast,
	input wire s_axis_video_tuser,
	input wire s_axis_video_id,
	input wire [(VIDEO_DATA_WIDTH/8)-1 : 0] s_axis_video_keep,
	input wire [(VIDEO_DATA_WIDTH/8)-1 : 0] s_axis_video_strb,
	input wire s_axis_video_dest,

	// ports of axis master video_out
	output wire [VIDEO_DATA_WIDTH-1 : 0] m_axis_video_tdata,
	output wire m_axis_video_tvalid,
	input wire m_axis_video_tready,
	output wire m_axis_video_tlast,
	output wire m_axis_video_tuser,
	output wire m_axis_video_id,
	output wire [(VIDEO_DATA_WIDTH/8)-1 : 0] m_axis_video_keep,
	output wire [(VIDEO_DATA_WIDTH/8)-1 : 0] m_axis_video_strb,
	output wire m_axis_video_dest
);

	wire start;

	// Instantiation of Axi Bus Interface S_AXI_CTRL
	video_stream_not_v1_0_S_AXI_CTRL # (
		.CTRL_DATA_WIDTH(CTRL_DATA_WIDTH),
		.CTRL_ADDR_WIDTH(CTRL_ADDR_WIDTH)
	) video_stream_not_v1_0_S_AXI_CTRL_inst (
		.S_AXI_ACLK(aclk),
		.S_AXI_ARESETN(aresetn),
		.S_AXI_AWADDR(s_axi_ctrl_awaddr),
		.S_AXI_AWPROT(s_axi_ctrl_awprot),
		.S_AXI_AWVALID(s_axi_ctrl_awvalid),
		.S_AXI_AWREADY(s_axi_ctrl_awready),
		.S_AXI_WDATA(s_axi_ctrl_wdata),
		.S_AXI_WSTRB(s_axi_ctrl_wstrb),
		.S_AXI_WVALID(s_axi_ctrl_wvalid),
		.S_AXI_WREADY(s_axi_ctrl_wready),
		.S_AXI_BRESP(s_axi_ctrl_bresp),
		.S_AXI_BVALID(s_axi_ctrl_bvalid),
		.S_AXI_BREADY(s_axi_ctrl_bready),
		.S_AXI_ARADDR(s_axi_ctrl_araddr),
		.S_AXI_ARPROT(s_axi_ctrl_arprot),
		.S_AXI_ARVALID(s_axi_ctrl_arvalid),
		.S_AXI_ARREADY(s_axi_ctrl_arready),
		.S_AXI_RDATA(s_axi_ctrl_rdata),
		.S_AXI_RRESP(s_axi_ctrl_rresp),
		.S_AXI_RVALID(s_axi_ctrl_rvalid),
		.S_AXI_RREADY(s_axi_ctrl_rready),
		.start(start)
	);

	assign m_axis_video_tdata = ~s_axis_video_tdata;
	assign m_axis_video_tvalid = start ? s_axis_video_tvalid : 1'b0;
	assign s_axis_video_tready = start ? m_axis_video_tready : 1'b0;
	assign m_axis_video_tlast = s_axis_video_tlast;
	assign m_axis_video_tuser = s_axis_video_tuser;
	assign m_axis_video_id = s_axis_video_id;
	assign m_axis_video_keep = s_axis_video_keep;
	assign m_axis_video_strb = s_axis_video_strb;
	assign m_axis_video_dest = s_axis_video_dest;

endmodule
