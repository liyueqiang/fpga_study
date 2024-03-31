#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=D:/FPGA/Xilinx/Vitis/2020.2/bin;D:/FPGA/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/nt64;D:/FPGA/Xilinx/Vivado/2020.2/ids_lite/ISE/lib/nt64:D:/FPGA/Xilinx/Vivado/2020.2/bin
else
  PATH=D:/FPGA/Xilinx/Vitis/2020.2/bin;D:/FPGA/Xilinx/Vivado/2020.2/ids_lite/ISE/bin/nt64;D:/FPGA/Xilinx/Vivado/2020.2/ids_lite/ISE/lib/nt64:D:/FPGA/Xilinx/Vivado/2020.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='E:/FPGA/fpga_study/01_flow_led/prj/flow_led.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .write_bitstream.begin.rst
EAStep vivado -log flow_led.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source flow_led.tcl -notrace


