import spinal.core._

class Key_Debounce extends Component {
  val io = new Bundle {
    val sys_clk   = in Bool()
    val sys_rst_n = in Bool()
    val key_in    = in Bool()
    val key_out   = out Bool()
  }
  //clock
  val clkDomain = ClockDomain(
    clock = io.sys_clk,
    reset = io.sys_rst_n,
    config = ClockDomainConfig(
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )
  //parameter
  val COUNTER_MAX = U(1000000,20bits)
  val clockingArea = new ClockingArea(clkDomain){
    val key_fltReg = Reg(Bool) init (True)
    val key_in_d0  = Reg(Bool()) init (true)
    val key_in_d1  = Reg(Bool()) init (true)
    val key_in_chg = key_in_d0 =/= key_in_d1
    val counter = Reg(UInt(20 bits)) init (0)

    key_in_d0 := io.key_in
    key_in_d1 := key_in_d0
    // 消抖
    when(key_in_chg) {
      counter := COUNTER_MAX
    } elsewhen (counter =/= 0) {
      counter := counter - 1
    }
    // 输出
    when(counter === 1){
      key_fltReg := key_in_d1
    }
    io.key_out := key_fltReg
  }
  noIoPrefix()
}

class Key_Beep extends Component {
  val io = new Bundle {
    val sys_clk   = in Bool()
    val sys_rst_n = in Bool()
    val key       = in Bool()
    val beep      = out Bool()
  }
  //clock
  val clkDomain = ClockDomain(
    clock = io.sys_clk,
    reset = io.sys_rst_n,
    config = ClockDomainConfig(
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )

  val key_flter = Bool()
  //消抖
  var keydebounce = new Key_Debounce
  keydebounce.io.sys_clk   <> io.sys_clk
  keydebounce.io.sys_rst_n <> io.sys_rst_n
  keydebounce.io.key_in    <> io.key
  val sysctrl    = new ClockingArea(clkDomain){
    keydebounce.io.key_out   <> key_flter
    val key_flt_d0 = Reg(Bool) init (True)
    val key_flt_d1 = Reg(Bool) init (True)
    val beep       = Reg(Bool) init (False)

    key_flt_d0 := key_flter
    key_flt_d1 := key_flt_d0

    when(key_flt_d1 && !key_flt_d0) {
      beep := ~beep
    }
    io.beep := beep
  }
  noIoPrefix()
}

object KeyBeepVerilog {
  def main(args: Array[String]): Unit = {
    SpinalConfig(targetDirectory = "output/").generateVerilog(new Key_Beep)
  }
}