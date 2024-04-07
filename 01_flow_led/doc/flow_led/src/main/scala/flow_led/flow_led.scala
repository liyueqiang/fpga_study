package flow_led

import spinal.core._

class FlowLED extends Component {
  val io = new Bundle {
    val sys_clk = in Bool()      // 系统时钟
    val sys_rst_n = in Bool()    // 系统复位
    val led = out UInt(2 bits)   // 输出LED
  }

  val COUNTER = 25000000

  // 定义时钟域
  val sys_clk = new ClockDomain(clock = io.sys_clk,
    reset = !io.sys_rst_n)

  val clkCtrl = new ClockingArea(sys_clk) {
    // 计数器
    val flow_led_cnt = Reg(UInt(32 bits)) init(0)
    when(!io.sys_rst_n) {
      flow_led_cnt := 0
    } elsewhen(flow_led_cnt === COUNTER - 1) {
      flow_led_cnt := 0
    } otherwise {
      flow_led_cnt := flow_led_cnt + 1
    }

    // 状态机
    val flow_led_flag = Reg(UInt(3 bits)) init(0)
    when(!io.sys_rst_n) {
      flow_led_flag := 0
    } elsewhen(flow_led_cnt === COUNTER - 1 && flow_led_flag === 3) {
      flow_led_flag := 0
    } elsewhen(flow_led_cnt === COUNTER - 1 && flow_led_flag =/= 3) {
      flow_led_flag := flow_led_flag + 1
    }

    // LED输出逻辑
    switch(flow_led_flag) {
      is(0) { io.led := 1 }
      is(1) { io.led := 1 }
      is(2) { io.led := 1 }
      is(3) { io.led := 2 }
      default { io.led := 0 }
    }
  }
  noIoPrefix()
}

object FlowLEDVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new FlowLED)
  }
}
