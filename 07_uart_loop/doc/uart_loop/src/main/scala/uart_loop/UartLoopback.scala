import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._

class UartLoopback extends Component {
  val io = new Bundle {
    val sys_clk  = in Bool()      // 系统时钟信号
    val sys_rstn = in Bool()      // 系统复位信号
    val uart     = master(Uart()) // UART 接口
  }

  // 时钟和复位管理
  val resetCtrlClockDomain = ClockDomain(
    clock     = io.sys_clk,
    reset     = io.sys_rstn,
    frequency = FixedFrequency(50 MHz),
    config    = ClockDomainConfig(resetKind = SYNC, resetActiveLevel = LOW)
  )

  // 使用 ClockingArea 将逻辑放在自定义时钟域中
  val clockingarea = new ClockingArea(resetCtrlClockDomain) {
    // UART 控制器配置
    val uartCtrlConfig = UartCtrlGenerics(
      dataWidthMax      = 8,  // 数据宽度（最大8位）
      clockDividerWidth = 20, // 时钟分频器宽度
      preSamplingSize   = 1,  // 预采样大小
      samplingSize      = 5,  // 采样大小
      postSamplingSize  = 2   // 后采样大小
    )

    // 实例化 UART 控制器
    val uartCtrl: UartCtrl = UartCtrl(UartCtrlInitConfig(
      baudrate   = 115200,
      dataLength = 7,
      parity     = UartParityType.NONE,
      stop       = UartStopType.ONE
    ))
    uartCtrl.io.uart <> io.uart


    // 接收数据逻辑
    val rxData = Reg(UInt(8 bits)) init(0)
    uartCtrl.io.read.ready := uartCtrl.io.read.valid

    when(uartCtrl.io.read.valid) {
      rxData := uartCtrl.io.read.toFlow.toReg().asUInt
    }

    // 发送数据逻辑
    val write = Stream(Bits(8 bits))
    write.valid := RegNext(uartCtrl.io.read.valid)
    write.payload := rxData.asBits
    write >-> uartCtrl.io.write
  }
  noIoPrefix()
}

object UartLoopback {
  def main(args: Array[String]): Unit = {
    SpinalConfig(
      mode = Verilog,
      defaultClockDomainFrequency = FixedFrequency(50 MHz)
    ).generate(new UartLoopback)
  }
}