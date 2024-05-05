package xilinx_ip
import spinal.core._
import spinal.lib._

class clk_wiz_0 extends BlackBox {
  val io = new Bundle {
    val sys_clk  = in Bool()
    val resetn   = in Bool()
    val clk_50m  = out Bool()
    val clk_100m = out Bool()
    val locked   = out Bool()
  }
  //去掉io前缀
  noIoPrefix()
}

class fifo_generator_0 extends BlackBox {
  val io = new Bundle {
    val rst          = in Bool()
    val wr_clk       = in Bool()
    val rd_clk       = in Bool()
    val wr_rst_busy  = out Bool()
    val rd_rst_busy  = out Bool()
    val wr_en        = in Bool()
    val din          = in UInt(16 bits)
    val full         = out Bool()
    val almost_full  = out Bool()
    val rd_en        = in Bool()
    val dout         = out UInt(8 bits)
    val empty        = out Bool()
    val almost_empty = out Bool()

  }
  //去掉io前缀
  noIoPrefix()
}

class blk_mem_gen_0 extends BlackBox {
  val io = new Bundle {
    val clka  = in Bool()
    val addra = in UInt(6 bits)
    val douta = out UInt(16 bits)
  }
  //去掉io前缀
  noIoPrefix()
}

class xbip_dsp48_macro_0 extends BlackBox {
  val io = new Bundle {
    val CLK = in Bool()
    val A   = in UInt(8 bits)
    val B   = in UInt(8 bits)
    val C   = in UInt(16 bits)
    val P   = out UInt(17 bits)
  }
  //去掉io前缀
  noIoPrefix()
}



class xilinx_ip extends Component{
  val io = new Bundle {
    val sys_clk   = in Bool()
    val sys_rst_n = in Bool()
  }

  val clockadomin = new ClockDomain(
    clock = io.sys_clk,
    reset = io.sys_rst_n,
    config = new ClockDomainConfig(
      resetKind = ASYNC,
      resetActiveLevel = LOW
    )
  )

  val clk_50m  = Bool()
  val clk_100m = Bool()
  val locked   = Bool()
  // clock
  val clk_wiz_u = new clk_wiz_0()
  clk_wiz_u.io.sys_clk  <> io.sys_clk
  clk_wiz_u.io.resetn   <> io.sys_rst_n
  clk_wiz_u.io.clk_50m  <> clk_50m
  clk_wiz_u.io.clk_100m <> clk_100m
  clk_wiz_u.io.locked   <> locked

  //fifo
  val rst         = (!io.sys_rst_n | !locked)
  val wr_rst_busy = Bool()
  val rd_rst_busy = Bool()
  val fifo_is_ok  = (wr_rst_busy & rd_rst_busy)
  val fifo_in     = UInt(16 bits)
  val fifo_out    = UInt(8 bits)
  val full , almost_full  = Bool()
  val empty, almost_empty = Bool()
  val rom_addra   =  UInt(6 bits)

  val fifo_generator_u = new fifo_generator_0()
  fifo_generator_u.io.rst          <> rst
  fifo_generator_u.io.wr_clk       <> clk_50m
  fifo_generator_u.io.rd_clk       <> clk_100m
  fifo_generator_u.io.wr_rst_busy  <> wr_rst_busy
  fifo_generator_u.io.rd_rst_busy  <> rd_rst_busy
  fifo_generator_u.io.wr_en        <> fifo_is_ok
  fifo_generator_u.io.din          <> fifo_in
  fifo_generator_u.io.full         <> full
  fifo_generator_u.io.almost_full  <> almost_full
  fifo_generator_u.io.rd_en        <> fifo_is_ok
  fifo_generator_u.io.dout         <> fifo_out
  fifo_generator_u.io.empty        <> empty
  fifo_generator_u.io.almost_empty <> almost_empty

  val blk_mem_gen_u = new blk_mem_gen_0()
  blk_mem_gen_u.io.clka  <> clk_50m
  blk_mem_gen_u.io.addra <> rom_addra
  blk_mem_gen_u.io.douta <> fifo_in

  val clockingarea0 = new ClockingArea(new ClockDomain(clock = clk_50m,reset = rst)) {
    val rom_addr_count = Reg(UInt(6 bits)) init (0)
    when(fifo_is_ok){
      when(rom_addr_count === 63){
        rom_addr_count := 0
      }otherwise {
        rom_addr_count := rom_addr_count + 1
      }
    }
    rom_addra := rom_addr_count
  }

  val dsp_out = UInt(17 bits)
  val clockingarea1 = new ClockingArea(new ClockDomain(clock = clk_100m,reset = rst)) {
    val fifo_dout_d0 = Reg(UInt(8 bits)) init(0)
    val fifo_dout_d1 = Reg(UInt(8 bits)) init(0)
    val fifo_dout_d2 = Reg(UInt(16 bits)) init(0)
    when(fifo_is_ok){
      fifo_dout_d0 := fifo_out
      fifo_dout_d1 := fifo_dout_d0
      fifo_dout_d2 := fifo_dout_d1.resize(16)
    }


    val xbip_dsp48_macro_u = new xbip_dsp48_macro_0()
    xbip_dsp48_macro_u.io.CLK <> clk_100m
    xbip_dsp48_macro_u.io.A   <> fifo_dout_d0
    xbip_dsp48_macro_u.io.B   <> fifo_dout_d1
    xbip_dsp48_macro_u.io.C   <> fifo_dout_d2
    xbip_dsp48_macro_u.io.P   <> dsp_out
  }

  //去掉io前缀
  noIoPrefix()
}

object XilinxIPVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new xilinx_ip)
  }
}
