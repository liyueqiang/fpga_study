package touch_led
import spinal.core._

class TouchLED extends Component {
  val io = new Bundle {
    val sys_clk   = in Bool()   // 系统时钟
    val sys_rst_n = in Bool()   // 下降沿复位信号
    val touch     = in Bool()   // 触摸输入
    val led       = out Bool()  // LED输出
  }
  // 创建时钟域
  val clkDomain = ClockDomain(
    clock = io.sys_clk,
    reset = !io.sys_rst_n
  )

  // 在时钟域内部执行操作
  val area = new ClockingArea(clkDomain) {
    // 触摸状态寄存器
    val touch_d0 = Reg(Bool) init(False)
    val touch_d1 = Reg(Bool) init(False)
    val touch_d2 = Reg(Bool) init(False)

    // 触摸上升沿信号
    val touch_rise = !touch_d2 & touch_d1

    // LED状态寄存器
    val led_state = Reg(Bool) init(False)

    // 触摸状态更新
    when(!io.sys_rst_n) {
      touch_d0 := False
      touch_d1 := False
      touch_d2 := False
    } otherwise {
      touch_d0 := io.touch
      touch_d1 := touch_d0
      touch_d2 := touch_d1
    }

    // LED状态更新
    when(touch_rise) {
      led_state := ~led_state
    }

    // LED输出
    io.led := led_state
  }
  noIoPrefix()
}

object FlowLEDVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new TouchLED)
  }
}
