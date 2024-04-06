package key_led
import spinal.core._

class KeyLEDs extends Component {
  val io = new Bundle {
    val sys_clk   = in Bool()       // 系统时钟
    val sys_rst_n = in Bool()      // 下降沿复位信号
    val key       = in UInt(2 bits) // 按键输入
    val led       = out UInt(2 bits) // LED输出
  }

  val COUNTER = 25e6.toInt  // 0.5秒计数器

  // 计时器
  val timer_cnt = Reg(UInt(31 bits)) init(0)
  val timer_flg = Reg(Bool) init(False)

  when(!io.sys_rst_n) {
    timer_cnt := 0
  } otherwise {
    when(timer_cnt === (COUNTER - 1)) {
      timer_cnt := 0
    } otherwise {
      timer_cnt := timer_cnt + 1
    }
  }

  // 0.5秒标识
  when(!io.sys_rst_n) {
    timer_flg := False
  } otherwise {
    when(timer_cnt === (COUNTER - 1)) {
      timer_flg := !timer_flg
    }
  }

  // LED控制
  when(!io.sys_rst_n) {
    io.led := 3
  } otherwise {
    switch(io.key) {
      is(0) {
        io.led := 3
      }
      is(1) {
        io.led := (timer_flg ## timer_flg).asUInt
      }
      is(2) {
        io.led := (timer_flg ## ~timer_flg).asUInt
      }
      is(3) {
        io.led := 0
      }
    }
  }
}

object KeyLEDsVerilog {
  def main(args: Array[String]): Unit = {
    SpinalVerilog(new KeyLEDs)
  }
}
