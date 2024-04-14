package breath_led

import spinal.core._

class breath_led0 extends Component {
  val io = new Bundle{
    val sys_clk   = in(Bool) //系统时钟
    val sys_rst_n = in(Bool) //系统复位
    val led       = out(Bool)//输出led
  }
  //系统时钟
  val clockdomain = new ClockDomain(
    clock = io.sys_clk,
    reset = io.sys_rst_n,
    config = ClockDomainConfig(
      resetActiveLevel = LOW,
      resetKind = ASYNC
    )
  )
  val clockarea = new ClockingArea(clockdomain){
    //2us
    val clk_2us_cnt = Reg(UInt(8 bits)) init(0)
    val clk_2us_flg = RegNext(clk_2us_cnt === 100-1,False)
    clk_2us_cnt := clk_2us_cnt + 1
    when(clk_2us_cnt === 100-1){
      clk_2us_cnt := 0
    }
    //2ms
    val clk_2ms_cnt = Reg(UInt(10 bits)) init(0)
    val clk_2ms_flg = RegNext(clk_2ms_cnt === 1000-1,False)
    clk_2ms_cnt := clk_2ms_cnt + clk_2us_flg.asUInt
    when(clk_2ms_cnt === 1000-1){
      clk_2ms_cnt := 0
    }
    //2s
    val clk_2s_cnt = Reg(UInt(10 bits)) init(0)
    val clk_2s_flag= Reg(Bool) init (false)
    clk_2s_cnt := clk_2s_cnt + clk_2ms_flg.asUInt
    when(clk_2s_cnt === 1000-1){
      clk_2s_cnt := 0
      clk_2s_flag := !clk_2s_flag
    }
    //pwm
    val led_state = Reg(Bool) init(false)
    when(!clk_2s_flag){
      led_state := clk_2ms_cnt <= clk_2s_cnt
    }otherwise{
      led_state := clk_2ms_cnt > clk_2s_cnt
    }
    io.led := led_state
  }
  noIoPrefix()
}
object Breath_LEDVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new breath_led0)
  }
}
