package breath_led

import spinal.core._
class breath_led1 extends Component {
  val io = new Bundle {
    val sys_clk   = in(Bool) // 系统时钟输入端口
    val sys_rst_n = in(Bool) // 复位信号输入端口
    val led       = out(Bool) // LED 输出端口
  }

  // 定义时钟域
  val clkDomain = ClockDomain(
    clock  = io.sys_clk,
    reset  = io.sys_rst_n,
    config = ClockDomainConfig(
      resetKind        = ASYNC,
      resetActiveLevel = LOW
    )
  )

  // 在时钟域内部处理逻辑
  val clkArea = new ClockingArea(clkDomain) {
    // 定义计数器
    val counter = Reg(UInt(28 bits)) init(0) // 使用28位计数器，以满足4秒周期
    counter := counter + 1
    // 输出PWM信号
    val pwmOutput = Reg(Bool) init(False)
    when(counter(26 downto 17) <= counter(16 downto 7)){
      pwmOutput := !counter(27)
    }otherwise{
      pwmOutput := counter(27)
    }
    //pwmOutput := counter.msb ^ (counter(26 downto 17) <= counter(16 downto 7))

    io.led := pwmOutput
  }
  noIoPrefix()
}

// 编译并生成 Verilog
object BreathLEDVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new breath_led1)
  }
}
